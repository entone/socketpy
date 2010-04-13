// *****************************************************************************************
// NullIterator.as
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
	 * In certain cases, such as a leaf object in a composite pattern, a null iterator 
	 * is needed to maintain elegant code. Instead of making special checks using if 
	 * statements, a null iterator will plug right into a loop and return 'false' when 
	 * 'HasNext' is checked.
	 * 
	 * @see	#hasNext
	 * @see	com.boostworthy.collections.iterators.IIterator
	 */
	public class NullIterator implements IIterator
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function NullIterator()
		{
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
			// Return 'false' to instantly end any iteration.
			return false;
		}
		
		/**
		 * Returns the element at the current index and then moves on to the next.
		 * 
		 * @return	The element at the current index.
		 */
		public function next():Object
		{
			// Return 'null' since no data is actually being iterated through.
			return null;
		}
		
		/**
		 * Resets this iterator back to it's starting index.
		 * <p>
		 * NOTE: This method is only present to meet the criteria of the 'IIterator' interface.
		 * 
		 * @see	com.boostworthy.collections.iterators.IIterator
		 */
		public function reset():void
		{
		}
	}
}