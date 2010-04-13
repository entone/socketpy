// *****************************************************************************************
// IteratorType.as
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
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'IteratorType' class houses public constants which represent iterator types.
	 */
	public final class IteratorType
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Defined constant for representing the 'NullIterator' type.
		 * 
		 * @see	com.boostworthy.collections.iterators.NullIterator
		 */
		public static const NULL:uint          = 1;
		
		/**
		 * Defined constant for representing the 'ForwardArrayIterator' type.
		 * 
		 * @see	com.boostworthy.collections.iterators.ForwardArrayIterator
		 */
		public static const ARRAY_FORWARD:uint = 2;
		
		/**
		 * Defined constant for representing the 'ReverseArrayIterator' type.
		 * 
		 * @see	com.boostworthy.collections.iterators.ReverseArrayIterator
		 */
		public static const ARRAY_REVERSE:uint = 4;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public final function IteratorType()
		{
		}
	}
}