// *****************************************************************************************
// AlphaAnimation.as
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
	 * The 'AlphaAnimation' class animates the 'alpha' property of a display object. The
	 * benefit of using this animation type over the generic 'PropertyAnimation' is that
	 * the display object's 'visible' property will be set to 'false' if it's alpha is
	 * animated to '0'. This is much more efficient than simply letting the display object
	 * be rendered with no alpha because the Flash Player will actually stop rendering
	 * the display object.
	 * 
	 * @see	com.boostworthy.animation.management.types.PropertyAnimation
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class AlphaAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String = "alpha";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the starting value for the property being animated.
		 */
		protected var m_nStartValue:Number;
		
		/**
		 * Holds the target value for the property being animated.
		 */
		protected var m_nTargetValue:Number;
		
		/**
		 * Holds the change in value for the property being animated.
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
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	nTargetValue	The value the property is getting animated to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.Transitions
		 * @see		com.boostworthy.animation.RenderMethod
		 */
		public function AlphaAnimation(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValue      = nTargetValue;
			m_nDuration         = nDuration;
			
			// Find and store the remaing necessary data.
			m_fncTransition     = Transitions[strTransition];
			m_nStartValue       = m_objTarget.alpha;
			m_nChangeValue      = m_nTargetValue - m_nStartValue;
			
			// Set the animation target's visibility to 'true'.
			m_objTarget.visible = true;
			
			// Store the starting time.
			m_nStartTime        = getTimer();
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
				// Animate the object's property
				m_objTarget.alpha = m_fncTransition(nTime, m_nStartValue, m_nChangeValue, m_nDuration);
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the object's property to the exact target values.
				m_objTarget.alpha = m_nTargetValue;
				
				// Check to see if the target value is '0'.
				if(!m_nTargetValue)
				{
					// Since the target object's alpha is now '0', it is no longer
					// visible, however it is still rendered in the display unless
					// it's visibility is set to 'false'.
					m_objTarget.visible = false;
				}
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
	}
}