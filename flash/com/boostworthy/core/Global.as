// *****************************************************************************************
// Global.as
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

package com.boostworthy.core
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.Stage;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Global' class houses commonly used data globally throughout an application. 
	 * The AS2 equivalent was '_global', however this class is not dynamic. The 'Global' 
	 * class is not meant to be instantiated.
	 */
	public final class Global
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * A value for representing a null index.
		 */
		public static var NULL_INDEX:int = -1;
		
		// CLASS MEMBERS ///////////////////////////////////////////////////////////////////
		
		/**
		 * Holds a reference to the stage.
		 */
		private static var c_objStage:Stage;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * <p>
		 * NOTE: This class is not meant to be instantiated.
		 */
		public final function Global()
		{
			// Throw an error informing the developer that this class is not meant
			// to be instantiated.
			throw new Error("ERROR -> Global :: Constructor :: The 'Global' class is not meant to be instantiated.");
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// STAGE ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets a reference to the stage.
		 * 
		 * @return	A reference to the stage.
		 */
		public static function get stage():Stage
		{
			// Return a reference to the stage.
			return c_objStage;
		}
		
		/**
		 * Sets a global reference to the stage.
		 * 
		 * @param	objStage	A reference to the stage.
		 */
		public static function set stage(objStage:Stage):void
		{
			// Store a reference to the stage.
			c_objStage = objStage;
		}
	}
}