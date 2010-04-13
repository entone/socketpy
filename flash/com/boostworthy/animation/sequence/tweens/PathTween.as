// *****************************************************************************************
// PathTween.as
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

package com.boostworthy.animation.sequence.tweens
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.sequence.tweens.ITween;
	import com.boostworthy.geom.Path;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'PathTween' class tweens a display object along a path.
	 * 
	 * @see	com.boostworthy.animation.sequence.tweens.ITween
	 * @see	com.boostworthy.geom.Path
	 */
	public class PathTween implements ITween
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
	
		/**
		 * The default transition to use for the tween.
		 */
		protected const DEFAULT_TRANSITION:String = Transitions.LINEAR;
		
		/**
		 * Meta data for representing the property being animated.
		 */
		protected const PROPERTY:String           = "x, y";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A reference to the display object to be tweened.
		 */
		protected var m_objToTween:DisplayObject;
		
		/**
		 * The path the target object is to be animated along.
		 */
		protected var m_objPath:Path;
		
		/**
		 * A value for determining whether or not to orient the object to the paths direction.
		 */
		protected var m_bOrientToPath:Boolean;
		
		/**
		 * The first frame of the tween.
		 */
		protected var m_uFirstFrame:uint;
		
		/**
		 * The last frame of the tween.
		 */
		protected var m_uLastFrame:uint;
		
		/**
		 * The name of the transition to be used for the tween.
		 */
		protected var m_strTransition:String;
		
		/**
		 * A reference to the transition being used for the tween.
		 */
		protected var m_fncTransition:Function;
		
		/**
		 * Determines whether or not this tween has changed and needs compared 
		 * towards it's target value again.
		 */
		protected var m_bIsDirty:Boolean;
		
		/**
		 * Stores the starting rotational value of the object being tween.
		 */
		protected var m_nStartRotation:Number;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		 
		/**
		 * Constructor.
		 * 
		 * @param	objToTween		The display object to be tweened.
		 * @param	objPath			The path the target object is to be animated along.
		 * @param	bOrientToPath	Determines whether or not to orient the object to the paths direction.
		 * @param	uFirstFrame		The first frame of the tween.
		 * @param	uLastFrame		The last frame of the tween.
		 * @param	strTransition	The name of the transition to be used for the tween.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.geom.Path
		 */
		public function PathTween(objToTween:DisplayObject, objPath:Path, bOrientToPath:Boolean, uFirstFrame:uint, uLastFrame:uint, strTransition:String = DEFAULT_TRANSITION)
		{
			// Store the necessary information for this tween.
			m_objToTween    = objToTween;
			m_objPath       = objPath;
			m_bOrientToPath = bOrientToPath;
			m_uFirstFrame   = uFirstFrame;
			m_uLastFrame    = uLastFrame;
			m_strTransition = strTransition;
			m_fncTransition = Transitions[m_strTransition];
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Creates a new path tween object that is a clone of this object.
		 * 
		 * @return	A new path tween object.
		 */
		public function clone():ITween
		{
			// Return a new path tween object.
			return new PathTween(m_objToTween, m_objPath, m_bOrientToPath, m_uFirstFrame, m_uLastFrame, m_strTransition);
		}
		
		/**
		 * Renders the specified frame.
		 * 
		 * @param	uFrame	The frame to render.
		 */
		public function renderFrame(uFrame:uint):void
		{
			// A point object for storing the current point along the path.
			var objPoint:Point;
			
			// Check to see if the frame is before the first frame of this tween and
			// whether or not a starting value has been stored.
			if(uFrame < m_uFirstFrame)
			{
				// Get the point along the path at the current frame.
				objPoint = m_objPath.getPointAt(0);
				
				// Apply the point to the target object.
				m_objToTween.x = objPoint.x;
				m_objToTween.y = objPoint.y;
				
				// Check to see if orienting to path direction is enabled.
				if(m_bOrientToPath && !isNaN(m_nStartRotation))
				{
					// Apply the starting value to the rotation.
					m_objToTween.rotation = m_nStartRotation;
				}
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the frame is within the frames of this tween.
			else if(uFrame >= m_uFirstFrame && uFrame <= m_uLastFrame)
			{
				// Calculate the amount of time passed during this tween based on the frames.
				var nTime:Number = (uFrame - m_uFirstFrame) / (m_uLastFrame - m_uFirstFrame);
				
				// Apply the easing transition to the position along the path.
				var nPosition:Number = m_fncTransition(nTime, 0, 1, 1);
				
				// Get the point along the path at the current frame.
				objPoint = m_objPath.getPointAt(nPosition);
				
				// Check to see if orienting to path direction is enabled.
				if(m_bOrientToPath)
				{
					// Calculate the distance from the current object coordinate
					// to it's new coordinate.
					var nDX:Number = objPoint.x - m_objToTween.x;
					var nDY:Number = objPoint.y - m_objToTween.y;
					
					// Calculate the angle between the two points, convert the value
					// to degrees, then apply it to the object's rotation.
					m_objToTween.rotation = m_objPath.getAngleAt(nPosition);
						
					// Check to see if a starting rotation value has been set yet.
					if(isNaN(m_nStartRotation) && uFrame == m_uFirstFrame)
					{
						// Store the starting value.
						m_nStartRotation = m_objToTween.rotation;
					}
				}
				
				// Apply the point to the target object.
				m_objToTween.x = objPoint.x;
				m_objToTween.y = objPoint.y;
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the current frame is beyond the last from on this tween.
			else if(uFrame > m_uLastFrame && m_bIsDirty)
			{
				// Get the point along the path at the current frame.
				objPoint = m_objPath.getPointAt(1);
				
				// Apply the point to the target object.
				m_objToTween.x = objPoint.x;
				m_objToTween.y = objPoint.y;
				
				// Mark this tween as being not dirty.
				m_bIsDirty = false;
			}
		}
		
		/**
		 * Gets the first frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The first frame of the timeline that has a keyframe on it.
		 */
		public function get firstFrame():uint
		{
			// Return the frame number.
			return m_uFirstFrame;
		}
	
		/**
		 * Gets the last frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The last frame of the timeline that has a keyframe on it.
		 */
		public function get lastFrame():uint
		{
			// Return the frame number.
			return m_uLastFrame;
		}
		
		/**
		 * Gets a reference to the target object being tweened.
		 * 
		 * @return	A reference to the target object being tweened.
		 */
		public function get target():Object
		{
			// Return the object reference.
			return m_objToTween;
		}
		
		/**
		 * Gets a string of the target property.
		 * 
		 * @return	A string of the target property.
		 */
		public function get property():String
		{
			// Return the property string.
			return PROPERTY;
		}
	}
}