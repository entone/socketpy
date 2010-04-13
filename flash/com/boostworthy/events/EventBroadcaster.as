// *****************************************************************************************
// EventBroadcaster.as
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

package com.boostworthy.events
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.events.EventDispatcher;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'EventBroadcaster' class is a singleton event dispatcher. It can be used to 
	 * easily broadcast events across an application.
	 */
	public class EventBroadcaster extends EventDispatcher
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CLASS MEMBERS ///////////////////////////////////////////////////////////////////
		
		/**
		 * Stores the singleton instance of this class.
		 */
		private static var c_objInstance:EventBroadcaster;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * <p>
		 * NOTE: The 'EventBroadcaster' class is intended to be used as a singleton.
		 * 
		 * @param	objEnforcer		The singleton enforcer.
		 * 
		 * @see		#GetInstance
		 */
		public function EventBroadcaster(objEnforcer:SingletonEnforcer)
		{
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Gets the singleton instance of the event broadcaster.
		 * 
		 * @return	The singleton instance of the event broadcaster.
		 */
		public static function getInstance():EventBroadcaster
		{
			// Check to see if an instance has been created yet.
			if(c_objInstance == null)
			{
				// Create the singleton instance.
				c_objInstance = new EventBroadcaster(new SingletonEnforcer());
			}
			
			// Return a reference to the singleton instance.
			return c_objInstance;
		}
	}
}

/**
 * Simple class for enforcing the fact that the 'EventBroadcaster' class is 
 * to be used as a singleton.
 */
class SingletonEnforcer {}