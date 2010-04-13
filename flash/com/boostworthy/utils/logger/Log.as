// *****************************************************************************************
// Log.as
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
	
	import com.boostworthy.utils.logger.ILog;
	import com.boostworthy.utils.logger.LogLevel;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Log' class logs vaarious meesages for output of a specific log level.
	 * 
	 * @see	com.boostworthy.utils.logger.ILog
	 * @see	com.boostworthy.utils.logger.LogLevel
	 */
	public class Log implements ILog
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Stores this logs name.
		 */
		protected var m_strName:String;
		
		/**
		 * Stores this logs level.
		 * 
		 * @see	com.boostworthy.utils.logger.LogLevel
		 */
		protected var m_uLevel:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function Log(strName:String, uLevel:uint)
		{
			// Initialize this object.
			init(strName, uLevel);
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// NAME ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the name of this log.
		 * 
		 * @return	The name of this log.
		 */
		public function getName():String
		{
			// Return the name.
			return m_strName;
		}
		
		// LEVEL ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the currently set log level.
		 * 
		 * @return	The currently set log level.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		public function getLevel():uint
		{
			// Return the log level.
			return m_uLevel;
		}
		
		/**
		 * Sets the log level for this log.
		 * 
		 * @param	uLevel	The log level in which to allow output from.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		public function setLevel(uLevel:uint):void
		{
			// Store the new log level.
			m_uLevel = uLevel;
		}
		
		// OUTPUT //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Logs a severe message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		public function severe(strMessage:String):void
		{
			// Request a severe output message.
			output(strMessage, LogLevel.SEVERE);
		}
		
		/**
		 * Logs a warning message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		public function warning(strMessage:String):void
		{
			// Request a warning output message.
			output(strMessage, LogLevel.WARNING);
		}
		
		/**
		 * Logs an info message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		public function info(strMessage:String):void
		{
			// Request an info output message.
			output(strMessage, LogLevel.INFO);
		}
		
		/**
		 * Logs a debug message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		public function debug(strMessage:String):void
		{
			// Request a debug output message.
			output(strMessage, LogLevel.DEBUG);
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 */
		protected function init(strName:String, uLevel:uint):void
		{
			// Store the parameters.
			m_strName = strName;
			m_uLevel  = uLevel;
		}
		
		// LEVEL ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the name of the specified log level.
		 * 
		 * @param	uLevel	The log level in which to find the name of.
		 * 
		 * @return	The name of the specified log level.
		 */
		protected function getLevelName(uLevel:uint):String
		{
			// Find the name of the specified log level and return it.
			switch(uLevel)
			{
				case LogLevel.OFF:
					return "OFF";
					break;
				case LogLevel.SEVERE:
					return "SEVERE";
					break;
				case LogLevel.WARNING:
					return "WARNING";
					break;
				case LogLevel.INFO:
					return "INFO";
					break;
				case LogLevel.DEBUG:
					return "DEBUG";
					break;
				default:
					return "";
					break;
			}
		}
		
		// OUTPUT //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Outputs a runtime message for the specified log level, assuming the level is allowed.
		 * 
		 * @param	strMessage	The message to output.
		 * @param	uLevel		The log level of the output message.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		protected function output(strMessage:String, uLevel:uint):void
		{
			// Make sure logging is enabled and the requested level is allowed.
			if(!(m_uLevel & LogLevel.OFF) && m_uLevel >= uLevel)
			{
				// Output the message.
				trace(createOutputMessage(strMessage, uLevel));
			}
		}
		
		/**
		 * Creates a message for output based on the specified message and log level.
		 * 
		 * @param	strMessage	The message for output.
		 * @param	uLevel		The log level of the output message.
		 * 
		 * @return	The original message with some additional formatting for output.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		protected function createOutputMessage(strMessage:String, uLevel:uint):String
		{
			// Return the formatted message.
			return m_strName + " (" + getLevelName(uLevel) + ") :: " + strMessage + "\n";
		}
	}
}