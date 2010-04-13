// *****************************************************************************************
// Renderer.as
// 
// Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// *****************************************************************************************
// 
// +          +          +          +          +          +          +          +          +
// 
// *****************************************************************************************

// PACKAGE /////////////////////////////////////////////////////////////////////////////////

package com.boostworthy.animation.rendering
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.core.Global;
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.utils.logger.ILog;
	import com.boostworthy.utils.logger.LogFactory;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Renderer' class is essentially a wrapper API around the different render
	 * methods. You can use it to routinely call methods using the enter frame event
	 * or a timer event.
	 * 
	 * @see	com.boostworthy.animation.RenderMethod
	 */
	public class Renderer extends EventDispatcher implements IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds a reference to the enter frame event handler.
		 */
		protected var m_fncOnEnterFrame:Function;
		
		/**
		 * Holds a timer instance to be used by this renderer.
		 */
		protected var m_objTimer:Timer;
		
		/**
		 * Holds a reference to the timer event handler.
		 */
		protected var m_fncOnTimer:Function;
		
		/**
		 * Holds a reference to the stage to be used for adding/removing listeners 
		 * to the enter frame event.
		 */
		protected var m_objStage:Stage;
		
		/**
		 * Holds a log for logging output about this object.
		 */
		protected var m_objLog:ILog;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	fncOnEnterFrame		A reference to the event handler for the enter frame event.
		 * @param	fncOnTimer			A reference to the event handler for the timer event.
		 * @param	nRefreshRate		This interval for the timer to be set at. The value is in milliseconds.
		 */
		public function Renderer(fncOnEnterFrame:Function, fncOnTimer:Function, nRefreshRate:Number)
		{
			// Check to see if enter frame is being used.
			if(fncOnEnterFrame != null)
			{
				// Store a reference to the enter frame event handler.
				m_fncOnEnterFrame = fncOnEnterFrame;
				
				// Get a reference to the stage.
				m_objStage = Global.stage;
			}
			
			// Check to see if a timer is being used.
			if(fncOnTimer != null)
			{
				// Store a reference the timer event handler.
				m_fncOnTimer = fncOnTimer;
				
				// Create a new timer.
				m_objTimer = new Timer(nRefreshRate, 0);
				
				// Add a listener for the timer event.
				m_objTimer.addEventListener(TimerEvent.TIMER, m_fncOnTimer);
			}
			
			// Get a unique log from the log factory for this object.
			m_objLog = LogFactory.getInstance().getLog("Renderer");
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Starts rendering for the specified render method.
		 * 
		 * @param	nRenderMethod	The method to start rendering for.
		 * 
		 * @see com.boostworthy.animation.rendering.RenderMethod
		 */
		public function start(nRenderMethod:Number):void
		{
			// Check to see if the render method is enter frame.
			if(nRenderMethod == RenderMethod.ENTER_FRAME)
			{
				// Start rendering for enter frame.
				startEnterFrame();
			}
			// Check to see if the render method is timer.
			else if(nRenderMethod == RenderMethod.TIMER)
			{
				// Start rendering for timer.
				startTimer();
			}
		}
		
		/**
		 * Stops rendering for the specified render method.
		 * 
		 * @param	nRenderMethod	The method to stop rendering for.
		 * 
		 * @see com.boostworthy.animation.rendering.RenderMethod
		 */
		public function stop(nRenderMethod:Number):void
		{
			// Check to see if the render method is enter frame.
			if(nRenderMethod == RenderMethod.ENTER_FRAME)
			{
				// Stop rendering for enter frame.
				stopEnterFrame();
			}
			// Check to see if the render method is timer.
			else if(nRenderMethod == RenderMethod.TIMER)
			{
				// Stop rendering for timer.
				stopTimer();
			}
		}
		
		/**
		 * Starts rendering for all render methods.
		 */
		public function startAll():void
		{
			// Start enter frame rendering.
			startEnterFrame();
			
			// Start timer rendering.
			startTimer();
		}
		
		/**
	 	 * Stops rendering for all render methods.
		 */
		public function stopAll():void
		{
			// Stop enter frame rendering.
			stopEnterFrame();
			
			// Stop timer rendering.
			stopTimer();
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Make sure 'enter frame' rendering is in use before removing the listener.
			if(m_fncOnEnterFrame != null && m_objStage != null)
			{
				// Remove the event listener from the stage.
				m_objStage.removeEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
			}
			
			// Make sure 'timer' rendering is in use before removing the listener.
			if(m_objTimer != null)
			{
				// Remove the event listener from the timer.
				m_objTimer.removeEventListener(TimerEvent.TIMER, m_fncOnTimer);
			}
			
			// Null out the object references.
			m_fncOnEnterFrame = null;
			m_objTimer        = null;
			m_fncOnTimer      = null;
			m_objStage        = null;
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// ENTER FRAME /////////////////////////////////////////////////////////////////////
		
		/**
		 * Starts listening for the enter frame event.
		 */
		protected function startEnterFrame():void
		{
			// Check to see if a reference to the stage exists.
			if(!m_objStage)
			{
				// Get a reference to the stage if possible.
				m_objStage = Global.stage;
			}
					
			// Make sure a reference to the stage exists.
			if(m_objStage)
			{
				// Add a listener to the stage's enter frame event.
				m_objStage.addEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
			}
			else
			{
				// Log a message warning the user that a global stage reference does not exist.
				m_objLog.warning("startEnterFrame :: Unable to add a listener to the enter frame event because a global stage reference does not exist.");
			}
		}
		
		/**
		 * Stops listening for the enter frame event.
		 */
		protected function stopEnterFrame():void
		{
			// Make sure a reference to the stage exists.
			if(m_objStage)
			{
				// Remove the listener to the stage's enter frame event.
				m_objStage.removeEventListener(Event.ENTER_FRAME, m_fncOnEnterFrame);
			}
		}
		
		// TIMER ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Starts the timer.
		 */
		protected function startTimer():void
		{
			// Start the timer.
			m_objTimer.start();
		}
		
		/**
		 * Stops the timer.
		 */
		protected function stopTimer():void
		{
			// Stop the timer.
			m_objTimer.stop();
		}
	}
}