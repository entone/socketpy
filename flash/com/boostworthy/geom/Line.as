// *****************************************************************************************
// Line.as
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
	
	import com.boostworthy.geom.Curve;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Line' class presents a data structure for representing a line.
	 */
	public class Line extends Curve
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		 /**
		  * Constructor.
		  * 
		  * @param	objStart	The start point of the line.
		  * @param	objEnd		The end point of the line.
		  */
		public function Line(objStart:Point, objEnd:Point)
		{
			// Initialize this object.
			super(objStart, objEnd, new Point(objStart.x + (objEnd.x - objStart.x) / 2, objStart.y + (objEnd.y - objStart.y) / 2));
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Uses the data stored by this object to draw a line into the specified graphics object.
		 * 
		 * @param	objGraphics		The graphics object to draw the line into.
		 */
		public override function draw(objGraphics:Graphics):void
		{
			// Draw the curve.
			objGraphics.moveTo(m_objStart.x, m_objStart.y);
			objGraphics.lineTo(m_objEnd.x, m_objEnd.y);
		}
		
		/**
		 * Clones this object.
		 * 
		 * @return	A new curve object that is a clone of this object.
		 */
		public override function clone():IPathSegment
		{
			// Return the new curve.
			return new Line(start, end);
		}
	}
}