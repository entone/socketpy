// *****************************************************************************************
// FilterTween.as
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
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.sequence.tweens.ITween;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'FilterTween' class tweens the property of any object's filter to a specified target value.
	 * 
	 * @see	com.boostworthy.animation.sequence.tweens.ITween
	 */
	public class FilterTween implements ITween
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
		 * A reference to the display object to be tweened.
		 */
		protected var m_objToTween:DisplayObject;
		
		/**
		 * The property of the display object's filter that is being animated.
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
		 * @param	objToTween		The display object to be tweened.
		 * @param	objFilter		The filter class whose property is being animated. The filter must already be applied to the display object prior to being animated.
		 * @param	strProperty		The property of the display object's filter that is being animated.
		 * @param	nTargetValue	The value the property is getting tweened to.
		 * @param	uFirstFrame		The first frame of the tween.
		 * @param	uLastFrame		The last frame of the tween.
		 * @param	strTransition	The name of the transition to be used for the tween.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 */
		public function FilterTween(objToTween:DisplayObject, objFilter:Class, strProperty:String, nTargetValue:Number, uFirstFrame:uint, uLastFrame:uint, strTransition:String = DEFAULT_TRANSITION)
		{
			// Store the necessary information for this tween.
			m_objToTween    = objToTween;
			m_objFilter     = objFilter;
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
		
		// TWEEN ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new filter tween object that is a clone of this object.
		 * 
		 * @return	A new filter tween object.
		 */
		public function clone():ITween
		{
			// Return a new tween object.
			return new FilterTween(m_objToTween, m_objFilter, m_strProperty, m_nTargetValue, m_uFirstFrame, m_uLastFrame, m_strTransition);
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
				// Set the filter's target property to the starting value.
				updateTargetFilter(m_nStartValue);
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the frame is within the frames of this tween.
			else if(uFrame >= m_uFirstFrame && uFrame <= m_uLastFrame)
			{
				// Check to see if a starting value has been set yet.
				if(isNaN(m_nStartValue) && uFrame == m_uFirstFrame)
				{
					// Get the length of the filters array.
					var iLength:int = m_objToTween.filters.length;
						
					// Loop through the filters array.
					for(var i:int = 0; i < iLength; i++)
					{
						// Check for the specified filter type.
						if(m_objToTween.filters[i] is m_objFilter)
						{
							// Store the properties starting value.
							m_nStartValue = m_objToTween.filters[i][m_strProperty];
						}
					}
					
					// Check to see if a starting value was set.
					if(isNaN(m_nStartValue))
					{
						// Throw a new error.
						throw new Error("ERROR -> RenderFrame :: Constructor :: An invalid filter and/or filter property was specified.");
					}
					
					// Calculate the change in value.
					m_nChangeValue = m_nTargetValue - m_nStartValue;
				}
				
				// Calculate the amount of time passed during this tween based on the frames.
				var nTime:Number = (uFrame - m_uFirstFrame) / (m_uLastFrame - m_uFirstFrame);
				
				// Animate the filter's target property.
				updateTargetFilter(m_fncTransition(nTime, m_nStartValue, m_nChangeValue, 1));
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the current frame is beyond the last from on this tween.
			else if(uFrame > m_uLastFrame && m_bIsDirty)
			{
				// Set the filter's property to the exact target value.
				updateTargetFilter(m_nTargetValue);
				
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
			var iLength:int = m_objToTween.filters.length;
				
			// Loop through the filters array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Avoid the target filter.
				if(!(m_objToTween.filters[i] is m_objFilter))
				{
					// Add all other existing filters to the filters array.
					aFilters.push(m_objToTween.filters[i]);
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
			var iLength:int = m_objToTween.filters.length;
			
			// Loop through the filters array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Check each filter to see if it is the specified type.
				if(m_objToTween.filters[i] is m_objFilter)
				{
					// Return a reference to the filter.
					return m_objToTween.filters[i];
				}
			}
			
			// Return 'null' if the target filter was not found.
			return null;
		}
		
		/**
		 * Updates the target filter by applying the specified value to it's property, then 
		 * reapplies itself to the target object.
		 * 
		 * @param	nValue	The value to apply to the filter's target property.
		 */
		protected function updateTargetFilter(nValue:Number):void
		{
			// Get a copy of the filters array.
			var aFilters:Array = getFilters();
			
			// Get a reference to the filter.
			var objFilter:BitmapFilter = getTargetFilter();
				
			// Apply the value to the filter's target property.
			objFilter[m_strProperty] = nValue;
				
			// Add the filter to the filters array.
			aFilters.push(objFilter);
				
			// Apply the filters array to the target object.
			m_objToTween.filters = aFilters;
		}
	}
}