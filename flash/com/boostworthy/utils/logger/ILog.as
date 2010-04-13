// *****************************************************************************************
// ILog.as
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
	// INTERFACE ///////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'ILog' interface defines a common interface for all log objects.
	 */
	public interface ILog
	{
		// *********************************************************************************
		// INTERFACE DECLERATIONS
		// *********************************************************************************
		
		/**
		 * Gets the name of the log.
		 * 
		 * @return	The name of the log.
		 */
		function getName():String
		
		/**
		 * Gets the currently set log level.
		 * 
		 * @return	The currently set log level.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		function getLevel():uint
		
		/**
		 * Sets the log level for the log.
		 * 
		 * @param	uLevel	The log level in which to allow output from.
		 * 
		 * @see		com.boostworthy.utils.logger.LogLevel
		 */
		function setLevel(uLevel:uint):void
		
		/**
		 * Logs a severe message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		function severe(strMessage:String):void
		
		/**
		 * Logs a warning message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		function warning(strMessage:String):void
		
		/**
		 * Logs an info message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		function info(strMessage:String):void
		
		/**
		 * Logs a debug message.
		 * 
		 * @param	strMessage	The message to log.
		 */
		function debug(strMessage:String):void
	}
}