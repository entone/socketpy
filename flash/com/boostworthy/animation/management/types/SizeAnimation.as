// *****************************************************************************************
// SizeAnimation.as
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
	 * The 'SizeAnimation' class animates the 'width' and 'height' properties of a
	 * display object. The advantage to using this animation type over the generic 
	 * 'PropertyAnimation' is that it results in a smoother animation since the properties 
	 * are updated very close to the same time. It also generates a single event for the 
	 * animation rather than one for each property seperately.
	 * 
	 * @see	com.boostworthy.animation.management.types.PropertyAnimation
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class SizeAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String = "width, height";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds the starting value for the 'width' property.
		 */
		protected var m_nStartValueW:Number;
		
		/**
		 * Holds the target value for the 'width' property.
		 */
		protected var m_nTargetValueW:Number;
		
		/**
		 * Holds the change in value for the 'width' property.
		 */
		protected var m_nChangeValueW:Number;
		
		/**
		 * Holds the starting value for the 'height' property.
		 */
		protected var m_nStartValueH:Number;
		
		/**
		 * Holds the target value for the 'height' property.
		 */
		protected var m_nTargetValueH:Number;
		
		/**
		 * Holds the change in value for the 'height' property.
		 */
		protected var m_nChangeValueH:Number;
		
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
		 * @param	nTargetValueW	The target value for the 'width' property of the target object.
		 * @param	nTargetValueH	The target value for the 'height' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function SizeAnimation(objTarget:DisplayObject, nTargetValueW:Number, nTargetValueH:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValueW = nTargetValueW;
			m_nTargetValueH = nTargetValueH;
			m_nDuration     = nDuration;
			
			// Find and store the remaing necessary data.
			m_fncTransition = Transitions[strTransition];
			m_nStartValueW  = m_objTarget.width;
			m_nStartValueH  = m_objTarget.height;
			m_nChangeValueW = m_nTargetValueW - m_nStartValueW;
			m_nChangeValueH = m_nTargetValueH - m_nStartValueH;
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
				m_objTarget.width  = m_fncTransition(nTime, m_nStartValueW, m_nChangeValueW, m_nDuration);
				m_objTarget.height = m_fncTransition(nTime, m_nStartValueH, m_nChangeValueH, m_nDuration);
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the object's properties to the exact target values.
				m_objTarget.width  = m_nTargetValueW;
				m_objTarget.height = m_nTargetValueH;
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
	}
}