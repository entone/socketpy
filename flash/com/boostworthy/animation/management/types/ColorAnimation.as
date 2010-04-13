// *****************************************************************************************
// ColorAnimation.as
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
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'ColorAnimation' class animates the color of a display object.
	 * 
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class ColorAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String = "transform.colorTransform.redOffset, transform.colorTransform.greenOffset, transform.colorTransform.blueOffset";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the starting value for the 'red' portion of the color.
		 */
		protected var m_nStartValueR:Number;
		
		/**
		 * Holds the target value for the 'red' portion of the color.
		 */
		protected var m_nTargetValueR:Number;
		
		/**
		 * Holds the change in value for the 'red' portion of the color.
		 */
		protected var m_nChangeValueR:Number;
		
		/**
		 * Holds the starting value for the 'green' portion of the color.
		 */
		protected var m_nStartValueG:Number;
		
		/**
		 * Holds the target value for the 'green' portion of the color.
		 */
		protected var m_nTargetValueG:Number;
		
		/**
		 * Holds the change in value for the 'green' portion of the color.
		 */
		protected var m_nChangeValueG:Number;
		
		/**
		 * Holds the starting value for the 'blue' portion of the color.
		 */
		protected var m_nStartValueB:Number;
		
		/**
		 * Holds the target value for the 'blue' portion of the color.
		 */
		protected var m_nTargetValueB:Number;
		
		/**
		 * Holds the change in value for the 'blue' portion of the color.
		 */
		protected var m_nChangeValueB:Number;
		
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
		 * @param	nTargetValue	The target color value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function ColorAnimation(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// A temporary color transform object is created to apply the target color value
			// to and then extract the RGB offsets.
			var objColor:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, NaN);
			objColor.color = nTargetValue;
			
			// Store the parameters.
			m_nTargetValueR = objColor.redOffset;
			m_nTargetValueG = objColor.greenOffset;
			m_nTargetValueB = objColor.blueOffset;
			m_nDuration     = nDuration;
			
			// Find and store the remaing necessary data.
			m_fncTransition = Transitions[strTransition];
			m_nStartValueR  = m_objTarget.transform.colorTransform.redOffset;
			m_nStartValueG  = m_objTarget.transform.colorTransform.greenOffset;
			m_nStartValueB  = m_objTarget.transform.colorTransform.blueOffset;
			m_nChangeValueR = m_nTargetValueR - m_nStartValueR;
			m_nChangeValueG = m_nTargetValueG - m_nStartValueG;
			m_nChangeValueB = m_nTargetValueB - m_nStartValueB;
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
			// A temporary color transform object is needed to recieve the tweened RGB values.
			var objColor:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, NaN);
			
			// Find out how long the animation has been going.
			var nTime:Number = getTimer() - m_nStartTime;
			
			// Check to see if the animation duration has been reached.
			if(nTime < m_nDuration)
			{
				// Animate the R, G, and B properties.
				objColor.redOffset   = m_fncTransition(nTime, m_nStartValueR, m_nChangeValueR, m_nDuration);
				objColor.greenOffset = m_fncTransition(nTime, m_nStartValueG, m_nChangeValueG, m_nDuration);
				objColor.blueOffset  = m_fncTransition(nTime, m_nStartValueB, m_nChangeValueB, m_nDuration);
				
				// Apply the color transform to the target object.
				m_objTarget.transform.colorTransform = objColor;
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the R, G, and B offsets to the target RGB values.
				objColor.redOffset   = m_nTargetValueR;
				objColor.greenOffset = m_nTargetValueG;
				objColor.blueOffset  = m_nTargetValueB;
				
				// Apply the color transform to the target object.
				m_objTarget.transform.colorTransform = objColor;
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
	}
}