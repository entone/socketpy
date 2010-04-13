// *****************************************************************************************
// ReverseArrayIterator.as
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

package com.boostworthy.collections.iterators
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.collections.iterators.IIterator;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Iterates through an array by starting with the array length and then decrementing 
	 * the index until '0' is reached.
	 * 
	 * @see	com.boostworthy.collections.iterators.IIterator
	 */
	public class ReverseArrayIterator implements IIterator
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
	
		/**
		 * Holds the array of data to be iterated through.
		 */
		private var m_aData:Array;
		
		/**
		 * Stores the current index for the iteration process.
		 */
		private var m_uIndex:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	aData	An array of data to be iterated through by this object.
		 */
		public function ReverseArrayIterator(aData:Array)
		{
			// Store the supplied data array.
			m_aData = aData;
			
			// Reset this iterator.
			reset();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Returns a boolean value indicating whether or not the collection has another 
		 * element beyond the current index.
		 * 
		 * @return	A boolean value indicating whether or not the collection has another element beyond the current index.
		 */
		public function hasNext():Boolean
		{
			// Determine whether the index is greater than '0' or not.
			return m_uIndex > 0;
		}
		
		/**
		 * Returns the element at the current index and then moves on to the next.
		 * 
		 * @return	The element at the current index.
		 */
		public function next():Object
		{
			// Decrement the index and then return the element at that index.
			return m_aData[--m_uIndex];
		}
		
		/**
		 * Resets this iterator back to the last index of the array.
		 */
		public function reset():void
		{
			// Set the index to the length of the data array.
			m_uIndex = m_aData.length;
		}
	}
}