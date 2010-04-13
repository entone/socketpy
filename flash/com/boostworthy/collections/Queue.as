// *****************************************************************************************
// Queue.as
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

package com.boostworthy.collections
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.collections.ICollection;
	import com.boostworthy.collections.iterators.ForwardArrayIterator;
	import com.boostworthy.collections.iterators.IIterator;
	import com.boostworthy.collections.iterators.IteratorType;
	import com.boostworthy.collections.iterators.ReverseArrayIterator;
	import com.boostworthy.core.Global;
	import com.boostworthy.core.IDisposable;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Stores data in a 'first on, first off' fashion. Each element placed in this 
	 * collection can be of any data type.
	 * 
	 * @see	com.boostworthy.collections.ICollection
	 */
	public class Queue implements ICollection, IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Array for storing all data in this collection.
		 */
		protected var m_aData:Array;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function Queue()
		{
			// Clear this collection.
			dispose();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// COLLECTION //////////////////////////////////////////////////////////////////////
		
		/**
		 * Adds a new element to this object's collection.
		 * 
		 * @param	objElement	The element to add to this object.
		 */
		public function addElement(objElement:Object):void
		{
			// Add the new element to the next available index in the array.
			m_aData.push(objElement);
		}
		
		/**
		 * Removes an element from this object's collection.
		 * 
		 * @param	objElement	The element to remove from this object.
		 */
		public function removeElement(objElement:Object):void
		{
			// Get the element's index.
			var iIndex:int = getElementIndex(objElement);
			
			// Only take action if the element was found in the data array.
			if(iIndex != Global.NULL_INDEX)
			{
				// Remove the element from the data array.
				m_aData.splice(iIndex, 1);
			}
		}
		
		/**
		 * Gets the length of this collection.
		 * 
		 * @return	The length of this collection.
		 */
		public function get length():uint
		{
			// Return the data array length.
			return m_aData.length;
		}
		
		// ITERATION ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns an iterator of the specified type.
		 * 
		 * @param	uIterator	The iterator type to use for iterating through the data being stored by this collection. Default is '2' (IteratorType.ARRAY_FORWARD).
		 * 
		 * @return	An iterator instance of the specified type.
		 * 
		 * @see		com.boostworthy.collections.iterators.IteratorType
		 */
		public function getIterator(uIterator:uint = 2):IIterator
		{
			// Check to see if the specified iterator is a forward array iterator.
			if(uIterator == IteratorType.ARRAY_FORWARD)
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aData.concat());
			}
			// Check to see if the specified iterator is a reverse array iterator.
			else if(uIterator == IteratorType.ARRAY_REVERSE)
			{
				// Return a reverse array iterator.
				return new ReverseArrayIterator(m_aData.concat());
			}
			else
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aData.concat());
			}
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Create a new array, thus clearing the stored data in a
			// previous array if applicable.
			m_aData = new Array();
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		/**
		 * Loops through the data array and checks each element against the passed element. 
		 * If the element is found in the data array, it's index is returned, otherwise 
		 * 'null' is returned indicating that it was not found in the data array.
		 * 
		 * @param	objElement	The element being searched for in the collection.
		 * 
		 * @return	The element's index in the data array.
		 */
		private function getElementIndex(objElement:Object):int
		{
			// Loop through the data array.
			for(var i:int = 0; i < m_aData.length; i++)
			{
				// Compare the two elements.
				if(m_aData[i] === objElement)
				{
					// Return the element's index.
					return i;
				}
			}
			
			// Return a null index since no match was made.
			return Global.NULL_INDEX;
		}
	}
}