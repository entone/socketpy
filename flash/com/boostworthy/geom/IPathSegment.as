// *****************************************************************************************
// IPathSegment.as
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

package com.boostworthy.geom
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import com.boostworthy.core.IDisposable;
	
	// INTERFACE ///////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'IPathSegment' interface defines a common interface for all path segment objects.
	 */
	public interface IPathSegment extends IDisposable
	{
		// *********************************************************************************
		// INTERFACE DECLERATIONS
		// *********************************************************************************
		
		/**
		 * Gets the starting point of the path segment.
		 * 
		 * @return	A point object containing information about the point.
		 */
		function get start():Point
		
		/**
		 * Gets the end point of the path segment.
		 * 
		 * @return	A point object containing information about the point.
		 */
		function get end():Point
		
		/**
		 * Gets the control point of the path segment.
		 * 
		 * @return	A point object containing information about the point.
		 */
		function get control():Point
		
		/**
		 * Uses the data stored by this object to draw it into the specified graphics object.
		 * 
		 * @param	objGraphics		The graphics object to draw the path segment into.
		 */
		function draw(objGraphics:Graphics):void
		
		/**
		 * Clones this object.
		 * 
		 * @return	A new path segment that is a clone of this object.
		 */
		function clone():IPathSegment
	}
}