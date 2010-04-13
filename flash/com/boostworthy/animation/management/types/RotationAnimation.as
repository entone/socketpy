// *****************************************************************************************
// RotationAnimation.as
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

package com.boostworthy.animation.management.types
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Animates the 'rotation' property of a display object to the desired target value.
	 * <p>
	 * The advantage of using this method over the generic 'Property' method is that you can 
	 * specify the amount of times the animation occurs using the 'number of repeats' parameter. 
	 * If the number of repeats is set to '1', the animation will occur one time and animate the 
	 * rotation property to the specified target value. If a value other than '1' is used, the 
	 * animation will occur the set number of times, but instead of animating the rotation property 
	 * to the target value, the target value will be added to the current rotation value each time 
	 * the animation occurs. A value of '0' for the number of repeats will cause the animation to 
	 * continue until it is manually removed.
	 * 
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class RotationAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String = "rotation";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds the starting value for the 'rotation' property.
		 */
		protected var m_nStartValue:Number;
		
		/**
		 * Holds the target value for the 'rotation' property.
		 */
		protected var m_nTargetValue:Number;
		
		/**
		 * Holds the change in value for the 'rotation' property.
		 */
		protected var m_nChangeValue:Number;
		
		/**
		 * Holds the duration of the animation in milliseconds.
		 */
		protected var m_nDuration:Number;
		
		/**
		 * Holds the starting time of the animation in milliseconds.
		 */
		protected var m_nStartTime:Number;
		
		/**
		 * Holds a reference to the transition function being used for this animation.
		 */
		protected var m_fncTransition:Function;
		
		/**
		 * Holds the number of times this animation should repeat itself.
		 */
		protected var m_uNumRepeats:uint;
		
		/**
		 * Holds the current number of repeats that have taken place for this animation.
		 */
		protected var m_uRepeatCount:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	nTargetValue	The value to animate the target object's rotation property to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	uNumRepeats		The number of times the animation should repeat itself. A value of '0' will cause the animation to go on until manually stopped.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function RotationAnimation(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, uNumRepeats:uint, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValue  = nTargetValue;
			m_nDuration     = nDuration;
			m_uNumRepeats   = uNumRepeats;
			m_uRepeatCount  = 0;
			
			// Find and store the remaing necessary data.
			m_fncTransition = Transitions[strTransition];
			m_nStartValue   = m_objTarget.rotation;
			m_nChangeValue  = (m_uNumRepeats == 1) ? m_nTargetValue - m_nStartValue : m_nTargetValue;
			m_nStartTime    = getTimer();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// RENDERING ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Renders the animation.
		 * 
		 * @return	A boolean value that is 'true' if the animation was updated successfully, 'false' if it was not.
		 */
		public override function render():Boolean
		{
			// Find out how long the animation has been going.
			var nTime:Number = getTimer() - m_nStartTime;
			
			// Check to see if the animation duration has been reached.
			if(nTime < m_nDuration)
			{
				// Animate the object's rotation.
				m_objTarget.rotation = m_fncTransition(nTime, m_nStartValue, m_nChangeValue, m_nDuration);
			}
			else
			{
				// Check to see if the animation should continue or not.
				if(m_uNumRepeats != 0 && ++m_uRepeatCount == m_uNumRepeats)
				{
					// Set the object's rotation to the exact target values.
					m_objTarget.rotation = m_nTargetValue;
					
					// Return 'false' indicating that the object was not updated.
					return false;
				}
				
				// Reset the animation by reseting the starting value and time.
				m_nStartValue = m_objTarget.rotation;
				m_nStartTime  = getTimer();
			}
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
	}
}