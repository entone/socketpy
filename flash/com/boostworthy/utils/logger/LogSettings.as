// *****************************************************************************************
// LogSettings.as
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
	
	import com.boostworthy.utils.logger.LogLevel;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'LogSettings' class houses public constants which represent logging settings.
	 */
	public final class LogSettings
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Defined constant for representing the default log level.
		 */
		public static const DEFAULT_LOG_LEVEL:uint = LogLevel.DEBUG;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public final function LogSettings()
		{
		}
	}
}