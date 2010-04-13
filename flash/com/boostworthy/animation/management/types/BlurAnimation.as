// *****************************************************************************************
// BlurAnimation.as
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
	import flash.filters.BlurFilter;
	import flash.utils.getTimer;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'BlurAnimation' class animates the blur filter of the target object. If a blur
	 * filter does not currently exist for the target object, one is created and applied
	 * to it.
	 * 
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class BlurAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Meta data for representing the property being animated.
		 */
		public static const PROPERTY:String           = "filters.BlurFilter.blurX, filters.BlurFilter.blurY";
		
		/**
		 * Default value for the 'blurX' property of the blur filter.
		 */
		protected static const DEFAULT_BLUR_X:Number  = 0;
		
		/**
		 * Default value for the 'blurY' property of the blur filter.
		 */
		protected static const DEFAULT_BLUR_Y:Number  = 0;
		
		/**
		 * Default value for the quality setting of the blur filter.
		 */
		protected static const DEFAULT_QUALITY:Number = 3;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the starting value for the 'blurX' property.
		 */
		protected var m_nStartValueX:Number;
		
		/**
		 * Holds the target value for the 'blurX' property.
		 */
		protected var m_nTargetValueX:Number;
		
		/**
		 * Holds the change in value for the 'blurX' property.
		 */
		protected var m_nChangeValueX:Number;
		
		/**
		 * Holds the starting value for the 'blurY' property.
		 */
		protected var m_nStartValueY:Number;
		
		/**
		 * Holds the target value for the 'blurY' property.
		 */
		protected var m_nTargetValueY:Number;
		
		/**
		 * Holds the change in value for the 'blurY' property.
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
		
		/**
		 * Holds the blur filter to be applied to the target object.
		 */
		protected var m_objBlur:BlurFilter;
		
		/**
		 * Holds a copy of all filters currently applied to the target object.
		 */
		protected var m_aFilters:Array;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	nTargetValueX	The target value for the 'blurX' property of the target object's blur filter. A value that is a power of two is recommended for maximum performance.
		 * @param	nTargetValueY	The target value for the 'blurX' property of the target object's blur filter. A value that is a power of two is recommended for maximum performance.
		 * @param	nQuality		The quality of the blur being applied.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function BlurAnimation(objTarget:DisplayObject, nTargetValueX:Number, nTargetValueY:Number, nQuality:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, PROPERTY, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValueX = nTargetValueX;
			m_nTargetValueY = nTargetValueY;
			m_nDuration     = nDuration;
			
			// Create a new array to hold the target object's filters.
			m_aFilters = new Array();
			
			// Check to see if the target object has any filters applied to it already.
			if(m_objTarget.filters.length)
			{
				// Loop through the filters and check for a blur filter.
				for(var i:Number = 0; i < m_objTarget.filters.length; i++)
				{
					// Check the filter to see if it is a blur filter.
					if(m_objTarget.filters[i] is BlurFilter)
					{
						// Create a new blur filter that is a clone of the existing one.
						m_objBlur = m_objTarget.filters[i].clone();
					}
					else
					{
						// Add all other existing filters to the filters array.
						m_aFilters.push(m_objTarget.filters[i]);
					}
				}
			}
			else
			{
				// Create a new blur filter using the default and specified values.
				m_objBlur = new BlurFilter(DEFAULT_BLUR_X, DEFAULT_BLUR_Y, nQuality);
			}
			
			// Find and store the remaing necessary data.
			m_fncTransition = Transitions[strTransition];
			m_nStartValueX  = m_objBlur.blurX;
			m_nStartValueY  = m_objBlur.blurY;
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
				// Temporarily make a copy of the filters array.
				var aFilters:Array = m_aFilters.concat();
			
				// Animate the blur properties.
				m_objBlur.blurX = m_fncTransition(nTime, m_nStartValueX, m_nChangeValueX, m_nDuration);
				m_objBlur.blurY = m_fncTransition(nTime, m_nStartValueY, m_nChangeValueY, m_nDuration);
				
				// Add the blur to the temporary filters array.
				aFilters.push(m_objBlur);
				
				// Apply the filters array to the target object.
				m_objTarget.filters = aFilters;
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the blur properties to the exact target values.
				m_objBlur.blurX = m_nTargetValueX;
				m_objBlur.blurY = m_nTargetValueY;
				
				// Add the blur to the filters array.
				m_aFilters.push(m_objBlur);
				
				// Apply the filters to the target object.
				m_objTarget.filters = m_aFilters;
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
	}
}