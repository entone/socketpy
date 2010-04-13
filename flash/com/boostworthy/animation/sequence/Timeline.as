// *****************************************************************************************
// Timeline.as
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

package com.boostworthy.animation.sequence
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.boostworthy.animation.BoostworthyAnimation;
	import com.boostworthy.animation.rendering.Renderer;
	import com.boostworthy.animation.sequence.TweenStack;
	import com.boostworthy.animation.sequence.tweens.Action;
	import com.boostworthy.animation.sequence.tweens.ITween;
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
	 * The 'Timeline' class simulates the timeline paradox by presenting a similar API
	 * to create and control tweens.
	 */
	public class Timeline extends EventDispatcher implements IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Configures the default render method to use for rendering tweens.
		 * <p>
		 * The default value '2' is RenderMethod.TIMER. This is done because
		 * the 'RenderMethod' class is not available at the time this is compiled.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		protected const DEFAULT_RENDER_METHOD:uint = 2;
		
		/**
		 * Configures the default frame rate for timelines. This is only used if
		 * the render method is 'RenderMethod.TIMER'. 'RenderMethod.ENTER_FRAME' 
		 * uses the SWF file's frame rate.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		protected const DEFAULT_FRAME_RATE:Number  = 60;
		
		/**
		 * Configures the default loop setting.
		 */
		protected const DEFAULT_LOOP:Boolean       = false;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds an instance of the renderer object for rendering playback in reverse.
		 */
		protected var m_objRendererPrev:Renderer;
		
		/**
		 * Holds an instance of the renderer object for rendering playback forwards.
		 */
		protected var m_objRendererNext:Renderer;
		
		/**
		 * Stores the render method being used to render this object's tweens.
		 */
		protected var m_uRenderMethod:uint;
		
		/**
		 * The frame rate for this timeline to play at.
		 */
		protected var m_uFrameRate:uint;
		
		/**
		 * The necessary refresh rate to achieve the desired frame rate.
		 */
		protected var m_nRefreshRate:Number;
		
		/**
		 * A stack for storing all tweens in this timeline.
		 */
		protected var m_objTweenStack:TweenStack;
		
		/**
		 * The current frame the playhead of this timeline is at.
		 */
		protected var m_uFrame:uint;
		
		/**
		 * The length (in frames) of this timeline.
		 */
		protected var m_uLength:uint;
		
		/**
		 * Determines whether or not this timeline loops when the last frame is finished.
		 */
		protected var m_bLoop:Boolean; 
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	uRenderMethod	The render method to use for rendering tweens.
		 * @param	nFrameRate		The frame rate for the timeline to play at. This is only used if 'RenderMethod.TIMER' is used as the render method.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_RENDER_METHOD
		 * @see		#DEFAULT_FRAME_RATE
		 */
		public function Timeline(uRenderMethod:uint = DEFAULT_RENDER_METHOD, nFrameRate:Number = DEFAULT_FRAME_RATE)
		{
			// Initialize this object.
			init(uRenderMethod, nFrameRate);
		}
		
		/**
		 * Called by the renderer when playing in reverse using the 'RenderMethod.ENTER_FRAME' render method.
		 * 
		 * @param	objEvent	An object containing information about the enter frame event.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function onPrevFrameEF(objEvent:Event):void
		{
			// Move to the previous frame.
			prevFrame();
		}
		
		/**
		 * Called by the renderer when playing forwards using the 'RenderMethod.ENTER_FRAME' render method.
		 * 
		 * @param	objEvent	An object containing information about the enter frame event.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function onNextFrameEF(objEvent:Event):void
		{
			// Move to the next frame.
			nextFrame();
		}
		
		/**
		 * Called by the renderer when playing in reverse using the 'RenderMethod.TIMER' render method.
		 * 
		 * @param	objEvent	An object containing information about the timer event.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function onPrevFrameT(objEvent:TimerEvent):void
		{
			// Move to the previous frame.
			prevFrame();
			
			// Manually refresh the display.
			objEvent.updateAfterEvent();
		}
		
		/**
		 * Called by the renderer when playing forwards using the 'RenderMethod.TIMER' render method.
		 * 
		 * @param	objEvent	An object containing information about the timer event.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function onNextFrameT(objEvent:TimerEvent):void
		{
			// Move to the next frame.
			nextFrame();
			
			// Manually refresh the display.
			objEvent.updateAfterEvent();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Sets the frame rate this timeline plays at.
		 * 
		 * @param	nFrameRate	The frame rate for the timeline to play at.
		 */
		public function setFrameRate(nFrameRate:Number):void
		{
			// Set the new frame rate or default frame rate if the passed
			// value is not valid.
			m_uFrameRate = (nFrameRate > 0) ? nFrameRate : DEFAULT_FRAME_RATE;
			
			// Calculate the refresh rate based on the new frame rate.
			m_nRefreshRate = Math.floor(1000 / m_uFrameRate);
		}
		
		/**
		 * Adds a new tween to this timeline.
		 * 
		 * @param	objTween	The tween to add to this timeline.
		 */
		public function addTween(objTween:ITween):void
		{
			// Get a clone of the tween.
			var objNewTween:ITween = objTween.clone();
			
			// Determine the length of this timeline based on the last frame
			// of the new tween.
			m_uLength = (objNewTween.lastFrame > m_uLength) ? objNewTween.lastFrame : m_uLength;
			
			// Add the new tween to the stack.
			m_objTweenStack.addElement(objNewTween);
			
			// Compute frame data for each tween.
			computeFrameData(objNewTween.firstFrame, objNewTween.lastFrame);
		}
		
		/**
		 * Plays this timeline from the current frame.
		 */
		public function play():void
		{
			// Stop the playhead.
			stop();
			
			// Dispatch the animation 'start' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.START));
			
			// Start rendering the next frames.
			m_objRendererNext.start(m_uRenderMethod);
		}
		
		/**
		 * Plays this timeline in reverse from the current frame.
		 */
		public function playReverse():void
		{
			// Stop the playhead.
			stop();
			
			// Dispatch the animation 'start' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.START));
			
			// Start rendering the previous frames.
			m_objRendererPrev.start(m_uRenderMethod);
		}
		
		/**
		 * Stops this timeline at the current frame.
		 */
		public function stop():void
		{
			// Stop all rendering.
			m_objRendererPrev.stop(m_uRenderMethod);
			m_objRendererNext.stop(m_uRenderMethod);
			
			// Dispatch the animation 'stop' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.STOP));
		}
		
		/**
		 * Moves the playhead to the desired frame and then plays from there.
		 * 
		 * @param	uFrame	The frame to move the playhead to.
		 */
		public function gotoAndPlay(uFrame:uint):void
		{
			// Stop the playhead.
			stop();
			
			// Move to the desired frame.
			setFrame(uFrame);
			
			// Begin playing from the current frame.
			play();
		}
		
		/**
		 * Moves the playhead to the desired frame and then plays in reverse from there.
		 * 
		 * @param	uFrame	The frame to move the playhead to.
		 */
		public function gotoAndPlayReverse(uFrame:uint):void
		{
			// Stop the playhead.
			stop();
			
			// Move to the desired frame.
			setFrame(uFrame);
			
			// Begin playing from the current frame.
			playReverse();
		}
		
		/**
		 * Moves the playhead to the desired frame and then stops.
		 * 
		 * @param	uFrame	The frame to move the playhead to.
		 */
		public function gotoAndStop(uFrame:uint):void
		{
			// Stop the playhead.
			stop();
			
			// Move to the desired frame.
			setFrame(uFrame);
		}
		
		/**
		 * Move the playhead backwards one frame.
		 */
		public function prevFrame():void
		{
			// Move backwards one frame.
			setFrame(m_uFrame - 1);
		}
		
		/**
		 * Move the playhead forwards one frame.
		 */
		public function nextFrame():void
		{
			// Move forwards one frame.
			setFrame(m_uFrame + 1);
		}
		
		/**
		 * Returns the length (in frames) of this timeline.
		 * 
		 * @return	The length (in frames) of this timeline.
		 */
		public function get length():Number
		{
			// Return the length.
			return m_uLength;
		}
		
		/**
		 * Gets the current loop setting.
		 * 
		 * @return	The current loop setting.
		 */
		public function get loop():Boolean
		{
			// Return the current loop setting.
			return m_bLoop;
		}
		
		/**
		 * Sets whether the playhead loops back to the first frame 
		 * and continues playing when the last frame is reached or not.
		 * 
		 * @param	bLoop	The new loop setting.
		 */
		public function set loop(bLoop:Boolean):void
		{
			// Set the new loop setting.
			m_bLoop = bLoop;
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Stop playback.
			stop();
			
			// Garbage collect for the renderers and tween stack.
			m_objRendererPrev.dispose();
			m_objRendererNext.dispose();
			m_objTweenStack.dispose();
			
			// Null out object references.
			m_uRenderMethod = NaN;
			m_uFrameRate    = NaN;
			m_nRefreshRate  = NaN;
			m_uFrame        = NaN;
			m_uLength       = NaN;
			m_bLoop         = false;
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 * 
		 * @param	uRenderMethod	The render method to use for rendering tweens.
		 * @param	nFrameRate		The frame rate for the timeline to play at. This is only used if 'RenderMethod.TIMER' is used as the render method.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		protected function init(uRenderMethod:uint, nFrameRate:Number):void
		{
			// Create an initial log for the animation system.
			BoostworthyAnimation.log();
			
			// Set the frame rate.
			setFrameRate(nFrameRate);
			
			// Store the render method.
			m_uRenderMethod = uRenderMethod;
			
			// Create new renderers for reverse and forwards playback.
			m_objRendererPrev = new Renderer(onPrevFrameEF, onPrevFrameT, m_nRefreshRate);
			m_objRendererNext = new Renderer(onNextFrameEF, onNextFrameT, m_nRefreshRate);
			
			// Create a new tween stack.
			m_objTweenStack = new TweenStack();
			
			// Set the starting frame and length.
			m_uFrame = m_uLength = 1;
			
			// Set the default loop value.
			loop = DEFAULT_LOOP;
		}
		
		// PLAYHEAD ////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets the current frame of the playhead.
		 * 
		 * @param	uFrame	The frame to move the playhead to.
		 */
		protected function setFrame(uFrame:Number):void
		{
			// This value will determine the order in which the stack is rendered.
			var bIsReverse:Boolean  = false;
			
			// This value will determine if a 'finish' event needs to be dispatched.
			var bIsFinished:Boolean = false;
			
			// Check to see if the frame is greater than the timeline length.
			if(uFrame > m_uLength)
			{
				// Check to see if looping is enabled.
				if(m_bLoop)
				{
					// Move back to frame '1'.
					uFrame = 1;
				}
				else
				{
					// Mark that a 'finish' event needs to be dispatched.
					bIsFinished = true;
				}
			}
			
			// Check to see if the frame is less than the timeline's first frame.
			if(uFrame < 1)
			{
				// Check to see if looping is enabled.
				if(m_bLoop)
				{
					// Move back to the last frame.
					uFrame = m_uLength;
					
					// Mark that the stack needs to be rendered in reverse.
					bIsReverse = true;
				}
				else
				{
					// Mark that a 'finish' event needs to be dispatched.
					bIsFinished = true;
				}
			}
			
			// Maintain a valid frame number.
			m_uFrame = Math.min(Math.max(1, uFrame), m_uLength);
			
			// Make sure the timeline isn't finished.
			if(!bIsFinished)
			{
				// Render the tweens.
				render(bIsReverse);
			}
			
			// Dispatch the animation 'change' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
			
			// Check to see if a 'finish' event needs dispatched.
			if(bIsFinished)
			{
				// Stop the playhead.
				stop();
				
				// Dispatch the animation 'finish' event.
				dispatchEvent(new AnimationEvent(AnimationEvent.FINISH));
			}
		}
		
		// RENDERING ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Computes the necessary frame data for each tween.
		 * 
		 * @param	uFirstFrame		The first frame to compute.
		 * @param	uLastFrame		The last frame to compute.
		 */
		protected function computeFrameData(uFirstFrame:uint, uLastFrame:uint):void
		{
			// Get an iterator instance from the tween stack.
			// In this case, we need a reverse iterator in order to correctly
			// calculate the frames in the correct order.
			var objTweenIterator:IIterator = m_objTweenStack.getIterator(IteratorType.ARRAY_REVERSE);
			
			// Loop through each frame of this timeline.
			for(var i:int = uFirstFrame; i <= uLastFrame; i++)
			{
				// Loop through the tweens.
				while(objTweenIterator.hasNext())
				{
					// Get the current tween object and advance to the next.
					var objTween:ITween = objTweenIterator.next() as ITween;
					
					// If the tween is an action, do not render the frame.
					if(!(objTween is Action))
					{
						// Render frame 'i' of each tween.
						objTween.renderFrame(i);
					}
				}
				
				// Reset the iterator.
				objTweenIterator.reset();
			}
			
			// Render the timeline.
			render();
		}
		
		/**
		 * Loops through the tween stack and renders the current frame of each tween.
		 * 
		 * @param	bIsReverse	A parameter which will force the stack to be rendered in reverse if necessary.
		 */
		protected function render(bIsReverse:Boolean = false):void
		{
			// Get an iterator instance from the tween stack.
			// When playing in reverse, once the first frame is rendered and the playhead moves 
			// back to the last frame, the stack must be rendered in reverse for that frame in 
			// order to render the tweens in the correct order.
			var objIterator:IIterator = m_objTweenStack.getIterator((bIsReverse) ? IteratorType.ARRAY_REVERSE : IteratorType.ARRAY_FORWARD);
			
			// Loop through the tweens.
			while(objIterator.hasNext())
			{
				// Render the current frame of each tween.
				objIterator.next().renderFrame(m_uFrame);
			}
		}
	}
}