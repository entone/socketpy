// *****************************************************************************************
// PulseAnimation.as
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
	
	import flash.utils.getTimer;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'PulseAnimation' class animates any object's property back and forth 
	 * between a minimum and maximum value using a sine wave.
	 * 
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class PulseAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the minimum value output by the pulse.
		 */
		protected var m_nMin:Number;
		
		/**
		 * Holds the maximum value output by the pulse.
		 */
		protected var m_nMax:Number;
		
		/**
		 * Holds the duration of the animation in milliseconds.
		 */
		protected var m_nDuration:Number;
		
		/**
		 * Holds the starting time of the animation in milliseconds.
		 */
		protected var m_nStartTime:Number;
		
		/**
		 * Holds the distance between the min/max and the median.
		 */
		protected var m_nValue:Number;
		
		/**
		 * The median value of the min/max.
		 */
		protected var m_nMedian:Number;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	strProperty		The property of the target object that is being animated.
		 * @param	nMin			The minimum value output by the pulse.
		 * @param	nMax			The maximum value output by the pulse.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function PulseAnimation(objTarget:Object, strProperty:String, nMin:Number, nMax:Number, nDuration:Number, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, strProperty, uRenderMethod);
			
			// Store the parameters.
			m_nMin       = nMin;
			m_nMax       = nMax;
			m_nDuration  = nDuration;
			
			// Find and store the remaing necessary data.
			m_nValue     = (m_nMax - m_nMin) / 2;
			m_nMedian    = m_nMin + m_nValue;
			m_nStartTime = getTimer();
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
			
			// Pulse the property.
			m_objTarget[m_strProperty] = m_nMedian + (Math.cos((nTime / m_nDuration) * (Math.PI * 2)) * m_nValue);
				
			// Return 'true' indicating that the object was updated.
			return true;
		}
	}
}