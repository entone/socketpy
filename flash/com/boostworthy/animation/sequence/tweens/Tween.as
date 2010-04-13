// *****************************************************************************************
// Tween.as
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
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.sequence.tweens.ITween;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Tween' class tweens any property of any object.
	 * 
	 * @see	com.boostworthy.animation.sequence.tweens.ITween
	 */
	public class Tween implements ITween
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
	
		/**
		 * The default transition to use for the tween.
		 */
		protected const DEFAULT_TRANSITION:String = Transitions.LINEAR;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A reference to the object to be tweened.
		 */
		protected var m_objToTween:Object;
		
		/**
		 * The object's property that is getting tweened.
		 */
		protected var m_strProperty:String;
		
		/**
		 * The first frame of the tween.
		 */
		protected var m_uFirstFrame:uint;
		
		/**
		 * The last frame of the tween.
		 */
		protected var m_uLastFrame:uint;
		
		/**
		 * Holds the starting value for the property being tweened.
		 */
		protected var m_nStartValue:Number;
		
		/**
		 * Holds the target value for the property being tweened.
		 */
		protected var m_nTargetValue:Number;
		
		/**
		 * Holds the change in value for the property being tweened.
		 */
		protected var m_nChangeValue:Number;
		
		/**
		 * The name of the transition to be used for the tween.
		 */
		protected var m_strTransition:String;
		
		/**
		 * A reference to the transition being used for the tween.
		 */
		protected var m_fncTransition:Function;
		
		/**
		 * Determines whether or not this tween has changed and needs compared 
		 * towards it's target value again.
		 */
		protected var m_bIsDirty:Boolean;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objToTween		The object to be tweened.
		 * @param	strProperty		The object's property that is getting tweened.
		 * @param	nTargetValue	The value the property is getting tweened to.
		 * @param	uFirstFrame		The first frame of the tween.
		 * @param	uLastFrame		The last frame of the tween.
		 * @param	strTransition	The name of the transition to be used for the tween.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 */
		public function Tween(objToTween:Object, strProperty:String, nTargetValue:Number, uFirstFrame:uint, uLastFrame:uint, strTransition:String = DEFAULT_TRANSITION)
		{
			// Store the necessary information for this tween.
			m_objToTween    = objToTween;
			m_strProperty   = strProperty;
			m_nTargetValue  = nTargetValue;
			m_uFirstFrame   = uFirstFrame;
			m_uLastFrame    = uLastFrame;
			m_strTransition = strTransition;
			m_fncTransition = Transitions[m_strTransition];
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Creates a new tween object that is a clone of this object.
		 * 
		 * @return	A new tween object.
		 */
		public function clone():ITween
		{
			// Return a new tween object.
			return new Tween(m_objToTween, m_strProperty, m_nTargetValue, m_uFirstFrame, m_uLastFrame, m_strTransition);
		}
		
		/**
		 * Renders the specified frame.
		 * 
		 * @param	uFrame	The frame to render.
		 */
		public function renderFrame(uFrame:uint):void
		{
			// Check to see if the frame is before the first frame of this tween and
			// whether or not a starting value has been stored.
			if(uFrame < m_uFirstFrame && !isNaN(m_nStartValue))
			{
				// Set the object's property back to it's starting value.
				m_objToTween[m_strProperty] = m_nStartValue;
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the frame is within the frames of this tween.
			else if(uFrame >= m_uFirstFrame && uFrame <= m_uLastFrame)
			{
				// Calculate the amount of time passed during this tween based on the frames.
				var nTime:Number = (uFrame - m_uFirstFrame) / (m_uLastFrame - m_uFirstFrame);
				
				// Check to see if a starting value has been set yet.
				if(isNaN(m_nStartValue) && uFrame == m_uFirstFrame)
				{
					// Store the starting value.
					m_nStartValue = m_objToTween[m_strProperty];
					
					// Calculate the change in value.
					m_nChangeValue = m_nTargetValue - m_nStartValue;
				}
					
				// Tween the object's property based on the time.
				m_objToTween[m_strProperty] = m_fncTransition(nTime, m_nStartValue, m_nChangeValue, 1);
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the current frame is beyond the last from on this tween.
			else if(uFrame > m_uLastFrame && m_bIsDirty)
			{
				// Set the object's property to it's target value.
				m_objToTween[m_strProperty] = m_nTargetValue;
				
				// Mark this tween as being not dirty.
				m_bIsDirty = false;
			}
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
			return m_objToTween;
		}
		
		/**
		 * Gets a string of the target property.
		 * 
		 * @return	A string of the target property.
		 */
		public function get property():String
		{
			// Return the property string.
			return m_strProperty;
		}
	}
}