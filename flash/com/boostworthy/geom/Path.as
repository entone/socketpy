// *****************************************************************************************
// Path.as
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
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.geom.IPathSegment;
	import com.boostworthy.geom.Line;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Path' class stores a collection of path segments, thus forming a path.
	 */
	public class Path implements IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * An array for storing path segments that form this path.
		 */
		protected var m_aSegments:Array;
		
		/**
		 * Stores a coordinate of the current location inside this path.
		 */
		protected var m_objLocation:Point;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function Path()
		{
			// Initialize this object.
			init();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Resets and clears this object back to new.
		 */
		public function reset():void
		{
			// Clear this object.
			clear();
			
			// Create a new location point.
			m_objLocation = new Point();
		}
		
		/**
		 * Clears the data being stored by this object.
		 */
		public function clear():void
		{
			// Create a new segments array.
			m_aSegments = new Array();
		}
		
		/**
		 * Moves the current location to the specified coordinate. This location represents the starting point segments and gets updated each time a new segment is added.
		 * 
		 * @param	nX	The 'x' position to move to.
		 * @param	nY	The 'y' position to move to.
		 */
		public function moveTo(nX:Number, nY:Number):void
		{
			// Store the new location.
			m_objLocation.x = nX;
			m_objLocation.y = nY;
		}
		
		/**
		 * Creates a line from the current location to the specified coordinate. The current location picks up from wherever the last segment ended or can be set manually using the 'MoveTo' method.
		 * 
		 * @param	nX	The 'x' position for the line to end at.
		 * @param	nY	The 'y' position for the line to end at.
		 * 
		 * @see 	#moveTo
		 */
		public function lineTo(nX:Number, nY:Number):void
		{
			// Add a new line segment to this path.
			addSegment(new Line(m_objLocation.clone(), new Point(nX, nY)));
			
			// Move to the end point.
			moveTo(nX, nY);
		}
		
		/**
		 * Creates a curve from the current location to the specified coordinate. The current location picks up from wherever the last segment ended or can be set manually using the 'MoveTo' method.
		 * 
		 * @param	nControlX	The 'x' position for the control point.
		 * @param	nControlY	The 'y' position for the control point.
		 * @param	nX			The 'x' position for the curve to end at.
		 * @param	nY			The 'y' position for the curve to end at.
		 * 
		 * @see		#moveTo
		 */
		public function curveTo(nControlX:Number, nControlY:Number, nX:Number, nY:Number):void
		{
			// Add a new curve segment to this path.
			addSegment(new Curve(m_objLocation.clone(), new Point(nX, nY), new Point(nControlX, nControlY)));
			
			// Move to the end point.
			moveTo(nX, nY);
		}
		
		/**
		 * Gets the starting point of the path.
		 * 
		 * @return	A point object containing information about the point.
		 */
		public function get start():Point
		{
			// Return the start point or current location if one does not exist.
			return m_aSegments[0].start || m_objLocation.clone();
		}
		
		/**
		 * Gets the end point of the path.
		 * 
		 * @return	A point object containing information about the point.
		 */
		public function get end():Point
		{
			// Return the end point or current location if one does not exist.
			return m_aSegments[m_aSegments.length - 1].end || m_objLocation.clone();
		}
		
		/**
		 * Gets the coordinate of a position along this path using a float value of '0.0' to '1.0' where '0.0' is the start of the path and '1.0' is the end of the path.
		 * 
		 * @param	nPosition	The position along this path (0.0 to 1.0) to get a coordinate from.
		 * 
		 * @return	The coordinate at the specified position.
		 */
		public function getPointAt(nPosition:Number):Point
		{
			// Calculate which segment the position is on.
			var nSegmentNum:Number = Math.min(Math.floor(m_aSegments.length * nPosition), m_aSegments.length - 1);
			
			// Calculate the percentage of the path which a single segment represents.
			var nCheckpoint:Number = 1 / m_aSegments.length;
			
			// Calculate the current percentage along the current segment.
			var nPercent:Number = (nPosition - (nCheckpoint * nSegmentNum)) / nCheckpoint;
			
			// Get a reference to the current segment.
			var objSegment:IPathSegment = m_aSegments[nSegmentNum];
			
			// Create a new point for storing the coordinate along the path.
			var objPoint:Point = new Point();
			
			// Check to see if the segment is a line.
			if(objSegment is Line)
			{
				// Calculate and store the coordinate at that position along the segment.
				objPoint.x = objSegment.start.x + (objSegment.end.x - objSegment.start.x) * nPercent;
				objPoint.y = objSegment.start.y + (objSegment.end.y - objSegment.start.y) * nPercent;
			}
			// The segment is a curve.
			else
			{
				// Check to see if there is only one segment. This reduces the amount of math involved.
				if(m_aSegments.length == 1)
				{
					// Calculate and store the coordinate at that position along the segment.
					objPoint.x = objSegment.start.x + ((nPercent * (2 * (1 - nPercent)) * (objSegment.control.x - objSegment.start.x)) + (nPercent * (objSegment.end.x - objSegment.start.x)));
					objPoint.y = objSegment.start.y + ((nPercent * (2 * (1 - nPercent)) * (objSegment.control.y - objSegment.start.y)) + (nPercent * (objSegment.end.y - objSegment.start.y)));
				}
				// Additional math for handeling more than one segment.
				else
				{
					// Create two point objects for storing segment midpoints.
					var objMidpoint1:Point = new Point();
					var objMidpoint2:Point = new Point();
					
					// Check to see if the current segment is the first segment.
					if(nSegmentNum == 0)
					{
						// Calculate and store the first midpoint.
						objMidpoint1.x = m_aSegments[0].start.x;
						objMidpoint1.y = m_aSegments[0].start.y;
						
						// Calculate and store the second midpoint.
						objMidpoint2.x = (m_aSegments[0].control.x + m_aSegments[1].control.x) / 2;
						objMidpoint2.y = (m_aSegments[0].control.y + m_aSegments[1].control.y) / 2;
					}
					// The current segment is any but the first.
					else
					{
						// Calculate and store the first midpoint.
						objMidpoint1.x = (m_aSegments[nSegmentNum - 1].control.x + objSegment.control.x) / 2;
						objMidpoint1.y = (m_aSegments[nSegmentNum - 1].control.y + objSegment.control.y) / 2;
						
						// Check to see if the segment is the last segment.
						if(nSegmentNum == m_aSegments.length - 1)
						{
							// Calculate and store the second midpoint.
							objMidpoint2.x = m_aSegments[m_aSegments.length - 1].end.x;
							objMidpoint2.y = m_aSegments[m_aSegments.length - 1].end.y;
						}
						// The segment is between the first and last segments.
						else
						{
							// Calculate and store the second midpoint.
							objMidpoint2.x = (objSegment.control.x + m_aSegments[nSegmentNum + 1].control.x) / 2;
							objMidpoint2.y = (objSegment.control.y + m_aSegments[nSegmentNum + 1].control.y) / 2;
						}
					}
					
					// Calculate and store the coordinate at that position along the current segment.
					objPoint.x = objMidpoint1.x + nPercent * (2 * (1 - nPercent) * (objSegment.control.x - objMidpoint1.x) + nPercent *(objMidpoint2.x - objMidpoint1.x));
					objPoint.y = objMidpoint1.y + nPercent * (2 * (1 - nPercent) * (objSegment.control.y - objMidpoint1.y) + nPercent *(objMidpoint2.y - objMidpoint1.y));
				}
			}
			
			// Return the position's coordinate along this path.
			return objPoint;
		}
		
		/**
		 * Gets the angle of a position along this path using a float value of '0.0' to '1.0' where '0.0' is the start of the path and '1.0' is the end of the path.
		 * 
		 * @param	nPosition	The position along this path (0.0 to 1.0) to get the angle from.
		 * 
		 * @return	The angle of the path at the specified position.
		 */
		public function getAngleAt(nPosition:Number):Number
		{
			// Get the current point at the specified position along the path.
			var objPoint1:Point = getPointAt(nPosition);
			var objPoint2:Point;
			
			// Check to see if data should be pulled from a future 
			// point or previous point.
			if(nPosition + 0.01 >= 1)
			{
				// Get a previous point.
				objPoint2 = getPointAt(nPosition - 0.01);
			}
			else
			{
				// Get a future point.
				objPoint2 = getPointAt(nPosition + 0.01);
			}
			
			// Calculate and return the angle between the two points.
			return Math.atan2(objPoint2.y - objPoint1.y, objPoint2.x - objPoint1.x) * (180 / Math.PI);
		}
		
		/**
		 * Uses the data stored by this object to draw a path into the specified graphics object.
		 * 
		 * @param	objGraphics		The graphics object to draw the path into.
		 */
		public function draw(objGraphics:Graphics):void
		{
			// Get the number of segments being stored.
			var uLength:uint = m_aSegments.length;
			
			// Loop through the segments array.
			for(var i:int = 0; i < uLength; i++)
			{
				// Draw each segment.
				m_aSegments[i].draw(objGraphics);
			}
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Get the number of segments being stored.
			var uLength:uint = m_aSegments.length;
			
			// Loop through the segments array.
			for(var i:int = 0; i < uLength; i++)
			{
				// Garbage collect for each object.
				m_aSegments[i].dispose();
			}
			
			// Null out the object reference.
			m_aSegments = null;
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
			// Reset this object.
			reset();
		}
		
		// SEGMENTS ////////////////////////////////////////////////////////////////////////
		
		/**
		 * Adds a new segment to this path.
		 * 
		 * @param	objSegment	The segment to add to this path.
		 */
		protected function addSegment(objSegment:IPathSegment):void
		{
			// Add the segment to the segments array.
			m_aSegments.push(objSegment);
		}
	}
}