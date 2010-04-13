// *****************************************************************************************
// LogFactory.as
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

package com.boostworthy.utils.logger
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.collections.HashMap;
	import com.boostworthy.collections.iterators.IIterator;
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.utils.logger.ILog;
	import com.boostworthy.utils.logger.Log;
	import com.boostworthy.utils.logger.LogSettings;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'LogFactory' class is intended to be used as a singleton and provides a factory 
	 * for creating, distributing, and managing logs throughout an application.
	 */
	public class LogFactory implements IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CLASS MEMBERS ///////////////////////////////////////////////////////////////////
		
		/**
		 * Stores the singleton instance of this class.
		 */
		private static var c_objInstance:LogFactory;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A hash map for storing log instances created by this factory.
		 */
		private var m_objLogHash:HashMap;
		
		/**
		 * The logging level to apply to all logs.
		 */
		private var m_uLevel:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * <p>
		 * NOTE: The 'LogFactory' class is intended to be used as a singleton.
		 * 
		 * @param	objEnforcer		The singleton enforcer.
		 * 
		 * @see		#GetInstance
		 */
		public function LogFactory(objEnforcer:SingletonEnforcer)
		{
			// Initialize this object.
			init();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// SINGLETON ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the singleton instance of the log factory.
		 * 
		 * @return	The singleton instance of the log factory.
		 */
		public static function getInstance():LogFactory
		{
			// Check to see if an instance has been created yet.
			if(c_objInstance == null)
			{
				// Create the singleton instance.
				c_objInstance = new LogFactory(new SingletonEnforcer());
			}
			
			// Return a reference to the singleton instance.
			return c_objInstance;
		}
		
		// SETTINGS ////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the currently set logging level.
		 * 
		 * @return	The currently set logging level.
		 */
		public function getLevel():uint
		{
			// Return the logging level.
			return m_uLevel;
		}
		
		/**
		 * Sets the logging level to apply to all new and existing logs created by this factory.
		 * 
		 * @param	uLevel	The logging level to apply to all new and existing logs created by this factory.
		 */
		public function setLevel(uLevel:uint):void
		{
			// Store the new logging level.
			m_uLevel = uLevel;
			
			// Get an interator instance from the log hash to iterate through 
			// all the logs created by this factory.
			var objIterator:IIterator = m_objLogHash.getValueIterator();
			
			// Iterate through the logs.
			while(objIterator.hasNext())
			{
				// Apply the new logging level to each log.
				objIterator.next().setLevel(m_uLevel);
			}
		}
		
		// FACTORY /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the specified log. If the log does not already exist, it will be created.
		 * 
		 * @param	strLogName	The name of the log to get (and create if non-existent).
		 * 
		 * @see		com.boostworthy.utils.logger.ILog
		 */
		public function getLog(strLogName:String):ILog
		{
			// Check to see if the log already exists.
			if(m_objLogHash.containsKey(strLogName))
			{
				// Get and return the log.
				return m_objLogHash.get(strLogName) as ILog;
			}
			
			// Create a new log and store it in the log hash.
			m_objLogHash.put(strLogName, new Log(strLogName, m_uLevel));
			
			// Return the new log.
			return m_objLogHash.get(strLogName) as ILog;
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Dispose of all log references being stored in the log hash.
			m_objLogHash.dispose();
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
			// Apply the default logging level.
			m_uLevel = LogSettings.DEFAULT_LOG_LEVEL;
			
			// Create a new hash map for storing log instances.
			m_objLogHash = new HashMap();
		}
	}
}

/**
 * Simple class for enforcing the fact that the 'LogFactory' class is 
 * to be used as a singleton.
 */
class SingletonEnforcer {}