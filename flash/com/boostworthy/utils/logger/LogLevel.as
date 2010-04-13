// *****************************************************************************************
// LogLevel.as
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
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'LogLevel' class houses public constants which represent logging output levels.
	 */
	public final class LogLevel
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Defined constant for representing the 'off' output level.
		 */
		public static const OFF:uint     = 1;
		
		/**
		 * Defined constant for representing the 'severe' output level.
		 */
		public static const SEVERE:uint  = 2;
		
		/**
		 * Defined constant for representing the 'warning' output level.
		 */
		public static const WARNING:uint = 4;
		
		/**
		 * Defined constant for representing the 'info' output level.
		 */
		public static const INFO:uint    = 8;
		
		/**
		 * Defined constant for representing the 'debug' output level.
		 */
		public static const DEBUG:uint   = 16;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public final function LogLevel()
		{
		}
	}
}