// *****************************************************************************************
// BoostworthyAnimation.as
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

package com.boostworthy.animation
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.utils.logger.LogFactory;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Contains meta data for retrieval at runtime or when viewing a decompiled SWF.
	 */
	public final class BoostworthyAnimation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * The name of this software library.
		 */ 
		public static const NAME:String    = "Boostworthy Animation System";
		
		/**
		 * The version of this software library.
		 */
		public static const VERSION:String = "2.1";
		
		/**
		 * The version date of this software library.
		 */
		public static const DATE:String    = "06.07.2007";
		
		/**
		 * Author/copyright of this software library.
		 */
		public static const AUTHOR:String  = "Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com";
		
		// CLASS MEMBERS ///////////////////////////////////////////////////////////////////
		
		/**
		 * Flag for storing the log status of the animation system information.
		 */
		private static var c_bIsLogged:Boolean;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public final function BoostworthyAnimation()
		{
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Logs information about the animation system.
		 */
		public static function log():void
		{
			// Check to see if the information has been logged yet.
			if(!c_bIsLogged)
			{
				// Log the animation system information.
				LogFactory.getInstance().getLog(NAME).info("Version " + VERSION + " :: " + AUTHOR);
				
				// Mark that the information has been logged.
				c_bIsLogged = true;
			}
		}
	}
}