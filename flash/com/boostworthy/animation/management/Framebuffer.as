// *****************************************************************************************
// Framebuffer.as
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

package com.boostworthy.animation.management
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	
	import com.boostworthy.animation.BoostworthyAnimation;
	import com.boostworthy.animation.management.Buffer;
	import com.boostworthy.animation.management.types.abstract.IAnimation;
	import com.boostworthy.animation.rendering.Renderer;
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.collections.iterators.IIterator;
	import com.boostworthy.collections.iterators.IteratorType;
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.events.AnimationEvent;
	
	// META ////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Dispatched when an animation starts.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.START
	 */
	[Event(name="animationStart", type="com.boostworthy.events.AnimationEvent")]
	
	/**
	 * Dispatched when an animation changes.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.CHANGE
	 */
	[Event(name="animationChange", type="com.boostworthy.events.AnimationEvent")]
	
	/**
	 * Dispatched when an animation stops.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.STOP
	 */
	[Event(name="animationStop", type="com.boostworthy.events.AnimationEvent")]
	
	/**
	 * Dispatched when an animation is finished.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.FINISH
	 */
	[Event(name="animationFinish", type="com.boostworthy.events.AnimationEvent")]
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	* The 'Framebuffer' class works with buffers and a renderer to handle the process
	* of rendering multiple animations at the same time.
	* 
	* @see	com.boostworthy.animation.management.Buffer
	* @see	com.boostworthy.animation.rendering.Renderer
	*/
	public class Framebuffer extends EventDispatcher implements IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds all animation objects to be rendered on enter frame.
		 * 
		 * @see	com.boostworthy.animation.management.Buffer
		 */
		protected var m_objBufferEF:Buffer;
		
		/**
		 * Holds all animation objects to be rendered on timer.
		 * 
		 * @see	com.boostworthy.animation.management.Buffer
		 */
		protected var m_objBufferT:Buffer;
		
		/**
		 * The renderer instance to be used to render the contents of the buffers.
		 * 
		 * @see	com.boostworthy.animation.rendering.Renderer
		 */
		protected var m_objRenderer:Renderer;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	nRefreshRate	This rate in which animations being rendered using the 'RenderMethod.TIMER' method will be refreshed. The value is in milliseconds.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		public function Framebuffer(nRefreshRate:Number)
		{
			// Initialize this object.
			init(nRefreshRate);
		}
		
		// RENDER EVENTS ///////////////////////////////////////////////////////////////////
		
		/**
		 * Event handler for the enter frame event. Loops through the contents of the buffer and updates each animation.
		 * 
		 * @param	objEvent	An object containing information about the event.
		 */
		protected function onRenderEF(objEvent:Event):void
		{
			// Update the enter frame buffer's animations.
			m_objBufferEF.render();
			
			// Stop the enter frame renderer if the buffer is now empty.
			checkBufferLengthEF();
		}
		
		/**
		 * Event handler for the timer event.
		 * <p>
		 * Loops through the contents of the buffer and updates each animation.
		 * 
		 * @param	objEvent	An object containing information about the event.
		 */
		protected function onRenderT(objEvent:TimerEvent):void
		{
			// Render the timer buffer's animations.
			m_objBufferT.render();
			
			// Manually update the display.
			objEvent.updateAfterEvent();
			
			// Stop the timer renderer if the buffer is now empty.
			checkBufferLengthT();
		}
		
		// ANIMATION EVENTS ////////////////////////////////////////////////////////////////
		
		/**
		 * Called when an animation starts.
		 * 
		 * @param	objEvent	An object containing information about the animation event.
		 */
		protected function onAnimationStart(objEvent:AnimationEvent):void
		{
			// Allow the event to bubble.
			dispatchEvent(new AnimationEvent(AnimationEvent.START, objEvent.animTarget, objEvent.animProperty));
		}
		
		/**
		 * Called when an animation changes.
		 * 
		 * @param	objEvent	An object containing information about the animation event.
		 */
		protected function onAnimationChange(objEvent:AnimationEvent):void
		{
			// Allow the event to bubble.
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE, objEvent.animTarget, objEvent.animProperty));
		}
		
		/**
		 * Called when an animation stops.
		 * 
		 * @param	objEvent	An object containing information about the animation event.
		 */
		protected function onAnimationStop(objEvent:AnimationEvent):void
		{
			// Allow the event to bubble.
			dispatchEvent(new AnimationEvent(AnimationEvent.STOP, objEvent.animTarget, objEvent.animProperty));
		}
		
		/**
		 * Called when an animation finishes.
		 * 
		 * @param	objEvent	An object containing information about the animation event.
		 */
		protected function onAnimationFinish(objEvent:AnimationEvent):void
		{
			// Allow the event to bubble.
			dispatchEvent(new AnimationEvent(AnimationEvent.FINISH, objEvent.animTarget, objEvent.animProperty));
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Adds a new animation to the framebuffer.
		 * 
		 * @param	objAnimation	The aniamtion to be added to the framebuffer.
		 */
		public function addBufferObject(objAnimation:IAnimation):void
		{
			// Remove any animation from the buffer involving the new
			// animations target object with the same property.
			removeAnimationByProperty(objAnimation.target, objAnimation.property);
			
			// Dispatch the animation 'start' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.START, objAnimation.target, objAnimation.property));
			
			// Check to see if the animation is to be rendered using enter frame.
			if(objAnimation.method == RenderMethod.ENTER_FRAME)
			{
				// Add the animation to the enter frame buffer.
				m_objBufferEF.add(objAnimation);
				
				// Start rendering for enter frame.
				m_objRenderer.start(RenderMethod.ENTER_FRAME);
			}
			// Check to see if the animation is to be rendered using timer.
			else if(objAnimation.method == RenderMethod.TIMER)
			{
				// Add the animation to the timer buffer.
				m_objBufferT.add(objAnimation);
				
				// Start rendering for timer.
				m_objRenderer.start(RenderMethod.TIMER);
			}
		}
		
		/**
		 * Removes all animations involving the target object from the framebuffer.
		 * 
		 * @param	objTarget	The object whose animations are to be removed.
		 */
		public function removeBufferObject(objTarget:Object):void
		{
			// Remove the animations.
			removeAnimationByObject(objTarget);
		}
		
		/**
		 * Clears all animations from the buffers.
		 */
		public function clearBuffer():void
		{
			// Stop all rendering.
			m_objRenderer.stopAll();
			
			// Clear the enter frame buffer.
			m_objBufferEF.clear();
			
			// Clear the timer buffer.
			m_objBufferT.clear();
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Remove event listeners from the enter frame buffer.
			m_objBufferEF.removeEventListener(AnimationEvent.START,  onAnimationStart);
			m_objBufferEF.removeEventListener(AnimationEvent.CHANGE, onAnimationChange);
			m_objBufferEF.removeEventListener(AnimationEvent.STOP,   onAnimationStop);
			m_objBufferEF.removeEventListener(AnimationEvent.FINISH, onAnimationFinish);
			
			// Remove event listeners from the timer buffer.
			m_objBufferT.removeEventListener(AnimationEvent.START,  onAnimationStart);
			m_objBufferT.removeEventListener(AnimationEvent.CHANGE, onAnimationChange);
			m_objBufferT.removeEventListener(AnimationEvent.STOP,   onAnimationStop);
			m_objBufferT.removeEventListener(AnimationEvent.FINISH, onAnimationFinish);
			
			// Garbage collect for the buffers and renderer.
			m_objBufferEF.dispose();
			m_objBufferT.dispose();
			m_objRenderer.dispose();
			
			// Null out the object references.
			m_objBufferEF = null;
			m_objBufferT  = null;
			m_objRenderer = null;
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 * 
		 * @param	nRefreshRate	This rate in which animations being rendered using the 'RenderMethod.TIMER' method will be refreshed. The value is in milliseconds.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function init(nRefreshRate:Number):void
		{
			// Create an initial log for the animation system.
			BoostworthyAnimation.log();
			
			// Create a new buffer for the enter frame buffer.
			m_objBufferEF = new Buffer();
			
			// Create a new buffer for the timer buffer.
			m_objBufferT  = new Buffer();
			
			// Create a renderer instance and configure it.
			m_objRenderer = new Renderer(onRenderEF, onRenderT, nRefreshRate);
			
			// Add event listeners to the enter frame buffer.
			m_objBufferEF.addEventListener(AnimationEvent.START,  onAnimationStart);
			m_objBufferEF.addEventListener(AnimationEvent.CHANGE, onAnimationChange);
			m_objBufferEF.addEventListener(AnimationEvent.STOP,   onAnimationStop);
			m_objBufferEF.addEventListener(AnimationEvent.FINISH, onAnimationFinish);
			
			// Add event listeners to the timer buffer.
			m_objBufferT.addEventListener(AnimationEvent.START,  onAnimationStart);
			m_objBufferT.addEventListener(AnimationEvent.CHANGE, onAnimationChange);
			m_objBufferT.addEventListener(AnimationEvent.STOP,   onAnimationStop);
			m_objBufferT.addEventListener(AnimationEvent.FINISH, onAnimationFinish);
		}
		
		// BUFFER //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Removes the specified animation from the buffer.
		 * 
		 * @param	objAnimation	The animation to be removed from the buffer.
		 */
		protected function removeAnimation(objAnimation:IAnimation):void
		{
			// Check the animations render method to see if it is 'enter frame'.
			if(objAnimation.method == RenderMethod.ENTER_FRAME)
			{
				// Remove the animation from the buffer.
				m_objBufferEF.remove(objAnimation);
				
				// Stop the enter frame renderer if the buffer is now empty.
				checkBufferLengthEF();
			}
			// Check the animations render method to see if it is 'timer'.
			else if(objAnimation.method == RenderMethod.TIMER)
			{
				// Remove the animation from the buffer.
				m_objBufferT.remove(objAnimation);
				
				// Stop the timer renderer if the buffer is now empty.
				checkBufferLengthT();
			}
		}
		
		/**
		 * Removes all animations involving the target object from the framebuffer.
		 * 
		 * @param	objTarget	The object whose animations are to be removed.
		 */
		protected function removeAnimationByObject(objTarget:Object):void
		{
			// Remove the object from the enter frame buffer.
			m_objBufferEF.removeByTarget(objTarget);
			
			// Stop the enter frame renderer if the buffer is now empty.
			checkBufferLengthEF();
			
			// Remove the object from the timer buffer.
			m_objBufferT.removeByTarget(objTarget);
			
			// Stop the timer renderer if the buffer is now empty.
			checkBufferLengthT();
		}
		
		/**
		 * Removes all animations involving the target object's property from the framebuffer.
		 * 
		 * @param	objTarget		The object whose animations are to be removed.
		 * @param	strProperty		The target object's property being searched for.
		 */
		protected function removeAnimationByProperty(objTarget:Object, strProperty:String):void
		{
			// Remove the object from the enter frame buffer.
			m_objBufferEF.removeByProperty(objTarget, strProperty);
			
			// Stop the enter frame renderer if the buffer is now empty.
			checkBufferLengthEF();
			
			// Remove the object from the timer buffer.
			m_objBufferT.removeByProperty(objTarget, strProperty);
			
			// Stop the timer renderer if the buffer is now empty.
			checkBufferLengthT();
		}
		
		/**
		 * Checks the enter frame buffer to see if it is empty. If it is, enter frame rendering is stopped.
		 */
		protected function checkBufferLengthEF():void
		{
			// Check to see if the buffer is now empty.
			if(!m_objBufferEF.length)
			{
				// Stop rendering for enter frame.
				m_objRenderer.stop(RenderMethod.ENTER_FRAME);
			}
		}
		
		/**
		 * Checks the timer buffer to see if it is empty. If it is, timer rendering is stopped.
		 */
		protected function checkBufferLengthT():void
		{
			// Check to see if the buffer is now empty.
			if(!m_objBufferT.length)
			{
				// Stop rendering for enter frame.
				m_objRenderer.stop(RenderMethod.TIMER);
			}
		}
	}
}