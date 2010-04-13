// *****************************************************************************************
// EnhancedMovieClip.as
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

package com.boostworthy.core
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	import com.boostworthy.core.IColorable;
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.geom.ColorMatrix;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'EnhancedMovieClip' class extends upon the 'MovieClip' class by providing an 
	 * enhanced foundation for additional garbage collection and color support.
	 * 
	 * @see	com.boostworthy.core.IColorable
	 * @see	com.boostworthy.core.IDisposable
	 * @see	com.boostworthy.geom.ColorMatrix
	 */
	public class EnhancedMovieClip extends MovieClip implements IColorable, IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds an instance of the color matrix object for manipulating this 
		 * object's color.
		 */
		protected var m_objColorMatrix:ColorMatrix;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function EnhancedMovieClip()
		{
			// Initialize this object.
			init();
		}
		
		/**
		 * Called whenever this object's color matrix changes.
		 * 
		 * @param	objEvent	An object containing information about the event.
		 * 
		 * @see		com.boostworthy.geom.ColorMatrix
		 */
		protected function onColorMatrixChange(objEvent:Event):void
		{
			// Apply the color matrix changes to this object.
			applyColorMatrix();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// FILTERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets a reference to this object's color matrix.
		 * 
		 * @return	A reference to this object's color matrix.
		 * 
		 * @see		com.boostworthy.geom.ColorMatrix
		 */
		public function get colorMatrix():ColorMatrix
		{
			// Return a reference to the color matrix.
			return m_objColorMatrix;
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Clean up this object for garbage collection.
		 */
		public function dispose():void
		{
			// Remove the color matrix listener.
			m_objColorMatrix.removeEventListener(Event.CHANGE, onColorMatrixChange);
			
			// Remove the color matrix.
			m_objColorMatrix = null;
			
			// Remove all filters.
			filters = new Array();
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 */
		protected function init():void
		{
			// Create this object's color matrix.
			m_objColorMatrix = new ColorMatrix();
			
			// Add a listener to the color matrix to be notified of any changes.
			m_objColorMatrix.addEventListener(Event.CHANGE, onColorMatrixChange);
		}
		
		// FILTERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Applies the current value of the color matrix to this object by creating 
		 * a new color matrix filter and applying the color matrix to it. The filter 
		 * is then added to the existing filter collection for this object.
		 * 
		 * @see	com.boostworthy.geom.ColorMatrix
		 */
		protected function applyColorMatrix():void
		{
			// Create a new temporary array for storing this object's 
			// filters, except for any color matrix filters.
			var aFilters:Array = new Array();
			
			// Get the length of the filters array.
			var iLength:int = filters.length;
			
			// Check to see if any filters are currently applied to this object.
			if(iLength)
			{
				// Loop through the filters array.
				for(var i:int = 0; i < iLength; i++)
				{
					// Only pay attention to filters that are not color matrix filters.
					if(!(filters[i] is ColorMatrixFilter))
					{
						// Add each filter to the temporary array.
						aFilters.push(filters[i]);
					}
				}
			}
			
			// Add a new color matrix filter with the value of the color matrix applied to 
			// it to the temporary array.
			aFilters.push(new ColorMatrixFilter(m_objColorMatrix.valueOf()));
			
			// Replace the current filters array with the temporary filters array.
			filters = aFilters;
		}
	}
}