// *****************************************************************************************
// Curve.as
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
	
	import com.boostworthy.geom.IPathSegment;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Curve' class presents a data structure for representing a curve.
	 */
	public class Curve implements IPathSegment
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A point object for storing information about the start point of this curve.
		 */
		protected var m_objStart:Point;
		
		/**
		 * A point object for storing information about the end point of this curve.
		 */
		protected var m_objEnd:Point;
		
		/**
		 * A point object for storing information about the control point of this curve.
		 */
		protected var m_objControl:Point;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		 /**
		  * Constructor.
		  * 
		  * @param	objStart	The start point of the curve.
		  * @param	objEnd		The end point of the curve.
		  * @param	objControl	The control point of the curve.
		  */
		public function Curve(objStart:Point, objEnd:Point, objControl:Point)
		{
			// Initialize this object.
			init(objStart, objEnd, objControl);
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Gets the starting point of the curve.
		 * 
		 * @return	A point object containing information about the point.
		 */
		public function get start():Point
		{
			// Return a clone of the start point.
			return m_objStart.clone();
		}
		
		/**
		 * Gets the end point of the curve.
		 * 
		 * @return	A point object containing information about the point.
		 */
		public function get end():Point
		{
			// Return a clone of the end point.
			return m_objEnd.clone();
		}
		
		/**
		 * Gets the control point of the curve.
		 * 
		 * @return	A point object containing information about the point.
		 */
		public function get control():Point
		{
			// Return a clone of the control point.
			return m_objControl.clone();
		}
		
		/**
		 * Uses the data stored by this object to draw a curve into the specified graphics object.
		 * 
		 * @param	objGraphics		The graphics object to draw the curve into.
		 */
		public function draw(objGraphics:Graphics):void
		{
			// Draw the curve.
			objGraphics.moveTo(m_objStart.x, m_objStart.y);
			objGraphics.curveTo(m_objControl.x, m_objControl.y, m_objEnd.x, m_objEnd.y);
		}
		
		/**
		 * Clones this object.
		 * 
		 * @return	A new curve object that is a clone of this object.
		 */
		public function clone():IPathSegment
		{
			// Return the new curve.
			return new Curve(start, end, control);
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			m_objStart   = null;
			m_objEnd     = null;
			m_objControl = null;
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 */
		protected function init(objStart:Point, objEnd:Point, objControl:Point):void
		{
			// Store the curve data.
			m_objStart   = objStart;
			m_objEnd     = objEnd;
			m_objControl = objControl;
		}
	}
}