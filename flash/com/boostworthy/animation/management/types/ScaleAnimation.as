// *****************************************************************************************
// ScaleAnimation.as
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
	 * The 'ScaleAnimation' class animates the 'scaleX' and 'scaleY' properties of a
	 * display object. The advantage to using this animation type over the generic 
	 * 'PropertyAnimation' is that it results in a smoother animation since the properties 
	 * are updated very close to the same time. It also generates a single event for the 
	 * animation rather than one for each property seperately.
	 * 
	 * @see	com.boostworthy.animation.management.types.PropertyAnimation
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
 	 */
	public class ScaleAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String = "scaleX, scaleY";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the starting value for the 'scaleX' property.
		 */
		protected var m_nStartValueX:Number;
		
		/**
		 * Holds the target value for the 'scaleX' property.
		 */
		protected var m_nTargetValueX:Number;
		
		/**
		 * Holds the change in value for the 'scaleX' property.
		 */
		protected var m_nChangeValueX:Number;
		
		/**
		 * Holds the starting value for the 'scaleY' property.
		 */
		protected var m_nStartValueY:Number;
		
		/**
		 * Holds the target value for the 'scaleY' property.
		 */
		protected var m_nTargetValueY:Number;
		
		/**
		 * Holds the change in value for the 'scaleY' property.
		 */
		protected var m_nChangeValueY:Number;
		
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
		 * @param	nTargetValueX	The target value for the 'scaleX' property of the target object.
		 * @param	nTargetValueY	The target value for the 'scaleY' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function ScaleAnimation(objTarget:DisplayObject, nTargetValueX:Number, nTargetValueY:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValueX = nTargetValueX;
			m_nTargetValueY = nTargetValueY;
			m_nDuration     = nDuration;
			
			// Find and store the remaing necessary data.
			m_fncTransition = Transitions[strTransition];
			m_nStartValueX  = m_objTarget.scaleX;
			m_nStartValueY  = m_objTarget.scaleY;
			m_nChangeValueX = m_nTargetValueX - m_nStartValueX;
			m_nChangeValueY = m_nTargetValueY - m_nStartValueY;
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
				// Animate the object's properties.
				m_objTarget.scaleX = m_fncTransition(nTime, m_nStartValueX, m_nChangeValueX, m_nDuration);
				m_objTarget.scaleY = m_fncTransition(nTime, m_nStartValueY, m_nChangeValueY, m_nDuration);
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the object's properties to the exact target values.
				m_objTarget.scaleX = m_nTargetValueX;
				m_objTarget.scaleY = m_nTargetValueY;
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
	}
}