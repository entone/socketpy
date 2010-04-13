// *****************************************************************************************
// Action.as
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

package com.boostworthy.animation.sequence.tweens
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.animation.sequence.tweens.ITween;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Action' class represents an action to take place when a specified frame
	 * of the timeline that the action belongs to is rendered. Using an action, functions  
	 * can be called (and passed parameters) seperately for forward and/or reverse playback.
	 * 
	 * @see	com.boostworthy.animation.sequence.tweens.ITween
	 */
	public class Action implements ITween
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		protected const PROPERTY:String = "action";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * The function to be called when the specified frame of this action is 
		 * reached while the timeline playhead is moving forward.
		 */
		protected var m_fncForward:Function;
		
		/**
		 * Holds an array of parameters to pass to the forward function.
		 */
		protected var m_aParamsForward:Array;
		
		/**
		 * The function to be called when the specified frame of this action is 
		 * reached while the timeline playhead is moving in reverse.
		 */
		protected var m_fncReverse:Function;
		
		/**
		 * Holds an array of parameters to pass to the reverse function.
		 */
		protected var m_aParamsReverse:Array;
		
		/**
		 * The first frame of the tween.
		 */
		protected var m_uFirstFrame:uint;
		
		/**
		 * The last frame of the tween.
		 */
		protected var m_uLastFrame:uint;
		
		/**
		 * Stores the previously rendered frame number.
		 */
		protected var m_uPreviousFrame:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	fncForward		The function that will be called whenever the specified frame is hit while the timeline's playhead is moving forward.
		 * @param	aParamsForward	An array of parameters to pass to the forward function.
		 * @param	fncReverse		The function that will be called whenever the specified frame is hit while the timeline's playhead is moving in reverse.
		 * @param	aParamsReverse	An array of parameters to pass to the reverse function.
		 * @param	uFrame			The frame for this action to take place on.
		 */
		public function Action(fncForward:Function, aParamsForward:Array, fncReverse:Function, aParamsReverse:Array, uFrame:uint)
		{
			// Store the necessary information for this tween.
			m_fncForward     = fncForward;
			m_aParamsForward = aParamsForward;
			m_fncReverse     = fncReverse;
			m_aParamsReverse = aParamsReverse;
			m_uFirstFrame    = uFrame;
			m_uLastFrame     = uFrame;
			
			// Default the previous frame '0'.
			m_uPreviousFrame = 1;
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Creates a new action object that is a clone of this object.
		 * 
		 * @return	A new action object.
		 */
		public function clone():ITween
		{
			// Return a new tween object.
			return new Action(m_fncForward, m_aParamsForward, m_fncReverse, m_aParamsReverse, m_uFirstFrame);
		}
		
		/**
		 * Renders the specified frame.
		 * 
		 * @param	uFrame	The frame to render.
		 */
		public function renderFrame(uFrame:uint):void
		{
			// Check to see if this action's frame is the one being rendered.
			if(uFrame == m_uFirstFrame)
			{
				// Check to see if the timeline's playhead is moving forward 
				// or in reverse.
				if(m_uPreviousFrame > uFrame)
				{
					// Call the reverse function.
					m_fncReverse.apply(null, m_aParamsReverse);
				}
				else
				{
					// Call the forward function.
					m_fncForward.apply(null, m_aParamsForward);
				}
			}
			
			// Log the frame as being the previous frame.
			m_uPreviousFrame = uFrame;
		}
		
		/**
		 * Gets the first frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The first frame of the timeline that has a keyframe on it.
		 */
		public function get firstFrame():uint
		{
			// Return the frame number.
			return m_uFirstFrame;
		}
	
		/**
		 * Gets the last frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The last frame of the timeline that has a keyframe on it.
		 */
		public function get lastFrame():uint
		{
			// Return the frame number.
			return m_uLastFrame;
		}
		
		/**
		 * Gets a reference to the target object being tweened.
		 * 
		 * @return	A reference to the target object being tweened.
		 */
		public function get target():Object
		{
			// Return the object reference.
			return null;
		}
		
		/**
		 * Gets a string of the target property.
		 * 
		 * @return	A string of the target property.
		 */
		public function get property():String
		{
			// Return the property string.
			return PROPERTY;
		}
	}
}