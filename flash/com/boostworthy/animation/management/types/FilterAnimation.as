// *****************************************************************************************
// FilterAnimation.as
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
	import flash.filters.BitmapFilter;
	import flash.utils.getTimer;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.types.abstract.Animation;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'FilterAnimation' class animates the property of any object's filter to a 
	 * specified target value. The filter must already be applied to the display object; 
	 * one will not be added for you if it is not present.
	 * 
	 * @see	com.boostworthy.animation.management.types.abstract.Animation
	 * @see	com.boostworthy.animation.management.types.abstract.IAnimation
	 */
	public class FilterAnimation extends Animation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the starting value for the filter's property.
		 */
		protected var m_nStartValue:Number;
		
		/**
		 * Holds the target value for the filter's property.
		 */
		protected var m_nTargetValue:Number;
		
		/**
		 * Holds the change in value for the filter's property.
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
		 * Holds the filter whose property is being animated.
		 */
		protected var m_objFilter:Class;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	objFilter		The filter class whose property is being animated. The filter must already be applied to the display object prior to being animated.
		 * @param	strProperty		The property of the target object's filter that is being animated.
		 * @param	nTargetValue	The value the property is being animated to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 */
		public function FilterAnimation(objTarget:DisplayObject, objFilter:Class, strProperty:String, nTargetValue:Number, nDuration:Number, strTransition:String, uRenderMethod:uint)
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(objTarget, strProperty, uRenderMethod);
			
			// Store the parameters.
			m_nTargetValue = nTargetValue;
			m_nDuration    = nDuration;
			m_objFilter    = objFilter;
			
			// Get the length of the filters array.
			var iLength:int = m_objTarget.filters.length;
				
			// Loop through the filters array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Check for the specified filter type.
				if(m_objTarget.filters[i] is m_objFilter)
				{
					// Store the filter's starting value.
					m_nStartValue = m_objTarget.filters[i][m_strProperty];
				}
			}
			
			// Check to see if a starting value was set.
			if(isNaN(m_nStartValue))
			{
				// Throw a new error.
				throw new Error("ERROR -> FilterAnimation :: Constructor :: An invalid filter and/or filter property was specified.");
			}
			
			// Find and store the remaing necessary data.
			m_fncTransition  = Transitions[strTransition];
			m_nChangeValue   = m_nTargetValue - m_nStartValue;
			m_nStartTime     = getTimer();
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
				// Animate the filter's property.
				updateTargetFliter(m_fncTransition(nTime, m_nStartValue, m_nChangeValue, m_nDuration));
				
				// Return 'true' indicating that the object was updated.
				return true;
			}
			else
			{
				// Set the filter's property to the exact target value.
				updateTargetFliter(m_nTargetValue);
				
				// Return 'false' indicating that the object was not updated.
				return false;
			}
		}
		
		// FILTERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets an array containing all the target object's filters, except for the target filter.
		 * 
		 * @return	An array containing filters.
		 */
		protected function getFilters():Array
		{
			// Create a new array to hold all filters except for the target filter.
			var aFilters:Array = new Array();
			
			// Get the length of the filters array.
			var iLength:int = m_objTarget.filters.length;
				
			// Loop through the filters array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Avoid the target filter.
				if(!(m_objTarget.filters[i] is m_objFilter))
				{
					// Add all other existing filters to the filters array.
					aFilters.push(m_objTarget.filters[i]);
				}
			}
			
			// Return the filters array.
			return aFilters;
		}
		
		/**
		 * Gets a reference to the target filter.
		 * 
	 	 * @return	A reference to the target filter.
		 */
		protected function getTargetFilter():BitmapFilter
		{
			// Get the length of the filters array.
			var iLength:int = m_objTarget.filters.length;
			
			// Loop through the filters array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Check each filter to see if it is the specified type.
				if(m_objTarget.filters[i] is m_objFilter)
				{
					// Return a reference to the filter.
					return m_objTarget.filters[i];
				}
			}
			
			// Return 'null' if the target filter was not found.
			return null;
		}
		
		/**
		 * Updates the target filter by applying the specified value to it's property, then 
		 * reapplies itself to the target object.
		 * 
		 * @param	nValue	The value to apply to the target filter's property.
		 */
		protected function updateTargetFliter(nValue:Number):void
		{
			// Get a copy of the filters array.
			var aFilters:Array = getFilters();
				
			// Get a reference to the target filter.
			var objFilter:BitmapFilter = getTargetFilter();
				
			// Apply the value to the filter's target property.
			objFilter[m_strProperty] = nValue;
				
			// Add the filter to the filters array.
			aFilters.push(objFilter);
				
			// Apply the filters to the target object.
			m_objTarget.filters = aFilters;
		}
	}
}