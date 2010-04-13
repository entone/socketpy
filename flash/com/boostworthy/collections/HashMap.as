// *****************************************************************************************
// HashMap.as
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
	 * The 'HashMap' class stores data in key/value pairs.
	 * 
	 * @see	com.boostworthy.collections.ICollection
	 */
	public class HashMap implements ICollection, IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * An array for storing map keys.
		 */
		protected var m_aKeys:Array;
		
		/**
		 * An array for storing map values.
		 */
		protected var m_aValues:Array;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function HashMap(objMap:Object = null)
		{
			// Initialize this object.
			init(objMap);
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// COLLECTION //////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new hash map that is a clone of this collection.
		 * 
		 * @return	A new hash map that is a clone of this collection.
		 */
		public function clone():HashMap
		{
			// Create a new hash map.
			var objHashMap:HashMap = new HashMap();
			
			// Get the length of the keys array.
			var nLength:int = m_aKeys.length;
			
			// Loop through the keys array.
			for(var i:int = 0; i < nLength; i++)
			{
				// Put each key/value pair into the new hash map.
				objHashMap.put(m_aKeys[i], m_aValues[i]);
			}
			
			// Return the cloned hash map.
			return objHashMap;
		}
		
		/**
		 * Adds a new key and value pair to this collection.
		 * 
		 * @param	objKey		The key to use to retrieve the value.
		 * @param	objValue	The value to store.
		 */
		public function put(objKey:Object, objValue:Object):void
		{
			// Remove the key, if it already exists.
			remove(objKey);
			
			// Add the key and value to their corresponding arrays.
			m_aKeys.push(objKey);
			m_aValues.push(objValue);
		}
		
		/**
		 * Iterates through all accessible properties/elements of the specified 
		 * object and adds each one as a key/value pair to this collection.
		 * 
		 * @param	objMap	The object to extract key/value pairs from.
		 */
		public function putMap(objMap:Object):void
		{
			// Loop through each key in the supplied map.
			for(var strKey:String in objMap)
			{
				// Put each key and value into this collection.
				put(strKey, objMap[strKey]);
			}
		}
		
		/**
		 * Gets the value that is paired with the specified key. If not such key 
		 * exists, 'null' is returned.
		 * 
		 * @param	objKey	They key to use to retrieve a value.
		 * 
		 * @return	The value that was paired with the specified key.
		 */
		public function get(objKey:Object):Object
		{
			// Search for the key and store it's index if it exists.
			var iKeyIndex:int = searchForKey(objKey);
			
			// Check for a valid key index.
			if(iKeyIndex != Global.NULL_INDEX)
			{
				// Return the value.
				return m_aValues[iKeyIndex];
			}
			
			// Return 'null' indicating that the supplied key does not exist.
			return null;
		}
		
		/**
		 * Removes the specified key and it's corresponding value from this collection.
		 * 
		 * @param	objKey	The key to be removed.
		 */
		public function remove(objKey:Object):void
		{
			// Search for the key and store it's index if it exists.
			var iKeyIndex:int = searchForKey(objKey);
			
			// Check for a valid key index.
			if(iKeyIndex != Global.NULL_INDEX)
			{
				// Remove the key and value from their corresponding arrays.
				m_aKeys.splice(iKeyIndex, 1);
				m_aValues.splice(iKeyIndex, 1);
			}
		}
		
		/**
		 * Checks to see if this collection contains the specified key.
		 * 
		 * @param	objKey	The key being searched for.
		 * 
		 * @return	A boolean value of 'true' if the key exists, 'false' if it does not.
		 */
		public function containsKey(objKey:Object):Boolean
		{
			// Return 'true' if the key exists, 'false' if it does not.
			return (searchForKey(objKey) != Global.NULL_INDEX);
		}
		
		/**
		 * Gets the length of this collection.
		 * 
		 * @return	The length of this collection.
		 */
		public function get length():uint
		{
			// Return the keys array length.
			return m_aKeys.length;
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
			// Return an iterator instance for iterating through values by default.
			return getValueIterator(uIterator);
		}
		
		/**
		 * Returns an iterator of the specified type for iterating through keys.
		 * 
		 * @param	uIterator	The iterator type to use for iterating through the keys being stored by this collection. Default is '2' (IteratorType.ARRAY_FORWARD).
		 * 
		 * @return	An iterator instance of the specified type.
		 * 
		 * @see		com.boostworthy.collections.iterators.IteratorType
		 */
		public function getKeyIterator(uIterator:uint = 2):IIterator
		{
			// Check to see if the specified iterator is a forward array iterator.
			if(uIterator == IteratorType.ARRAY_FORWARD)
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aKeys.concat());
			}
			// Check to see if the specified iterator is a reverse array iterator.
			else if(uIterator == IteratorType.ARRAY_REVERSE)
			{
				// Return a reverse array iterator.
				return new ReverseArrayIterator(m_aKeys.concat());
			}
			else
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aKeys.concat());
			}
		}
		
		/**
		 * Returns an iterator of the specified type for iterating through values.
		 * 
		 * @param	uIterator	The iterator type to use for iterating through the values being stored by this collection. Default is '2' (IteratorType.ARRAY_FORWARD).
		 * 
		 * @return	An iterator instance of the specified type.
		 * 
		 * @see		com.boostworthy.collections.iterators.IteratorType
		 */
		public function getValueIterator(uIterator:uint = 2):IIterator
		{
			// Check to see if the specified iterator is a forward array iterator.
			if(uIterator == IteratorType.ARRAY_FORWARD)
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aValues.concat());
			}
			// Check to see if the specified iterator is a reverse array iterator.
			else if(uIterator == IteratorType.ARRAY_REVERSE)
			{
				// Return a reverse array iterator.
				return new ReverseArrayIterator(m_aValues.concat());
			}
			else
			{
				// Return a forward array iterator.
				return new ForwardArrayIterator(m_aValues.concat());
			}
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Create new key and value arrays.
			m_aKeys   = new Array();
			m_aValues = new Array();
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 */
		protected function init(objMap:Object):void
		{
			// Create new key and value arrays by clearing this object.
			dispose();
			
			// Check the map parameter to see if a map was supplied.
			if(objMap != null)
			{
				// Put the map into this collection.
				putMap(objMap);
			}
		}
		
		// SEARCH //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Searches through the keys array to see if the key is being stored by this object. 
		 * If the key is found, it's index in the keys array is returned. If the key is not 
		 * found, the null index value is returned.
		 * 
		 * @param	objKey	The key being searched for.
		 * 
		 * @return	The index that the key is being stored at in the keys array.
		 * 
		 * @see		com.boostworthy.core.Global#NULL_INDEX
		 */
		protected function searchForKey(objKey:Object):int
		{
			// Get the length of the keys array.
			var nLength:int = m_aKeys.length;
			
			// Loop through the keys array.
			for(var i:int = 0; i < nLength; i++)
			{
				// Compare each key to the specified key.
				if(m_aKeys[i] === objKey)
				{
					// Return the matching key's index.
					return i;
				}
			}
			
			// Return a null index value indicating that the 
			// key was not found.
			return Global.NULL_INDEX;
		}
	}
}