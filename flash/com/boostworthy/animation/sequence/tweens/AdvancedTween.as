// *****************************************************************************************
// AdvancedTween.as
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
	 * The 'AdvancedTween' class tweens the property of an object using a path as a graph.
	 * The 'x' axis of the path represents the frames and the 'y' axis represents the
	 * value of the property.
	 * 
	 * @see	com.boostworthy.animation.sequence.tweens.ITween
	 * @see	com.boostworthy.geom.Path
	 */
	public class AdvancedTween implements ITween
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
	
		/**
		 * The default transition to use for the tween.
		 */
		protected const DEFAULT_TRANSITION:String = Transitions.LINEAR;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A reference to the object to be tweened.
		 */
		protected var m_objToTween:Object;
		
		/**
		 * The object's property that is getting tweened.
		 */
		protected var m_strProperty:String;
		
		/**
		 * Holds a path object whose 'x' axis represents the frame number and 'y' axis represents the property value.
		 */
		protected var m_objPath:Path;
		
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
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		 
		/**
		 * Constructor.
		 * 
		 * @param	objToTween		The object to be tweened.
		 * @param	strProperty		The object's property that is getting tweened.
		 * @param	objPath			The path object to use as data for this tween. The 'x' axis of the path represents the frame number and the 'y' axis represents the property value.
		 * @param	strTransition	The name of the transition to be used for the tween.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.geom.Path
		 */
		public function AdvancedTween(objToTween:Object, strProperty:String, objPath:Path, strTransition:String = DEFAULT_TRANSITION)
		{
			// Store the necessary information for this tween.
			m_objToTween    = objToTween;
			m_strProperty   = strProperty;
			m_objPath       = objPath;
			m_uFirstFrame   = objPath.start.x;
			m_uLastFrame    = objPath.end.x;
			m_strTransition = strTransition;
			m_fncTransition = Transitions[m_strTransition];
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Creates a new advanced tween object that is a clone of this object.
		 * 
		 * @return	A new advanced tween object.
		 */
		public function clone():ITween
		{
			// Return a new advanced tween object.
			return new AdvancedTween(m_objToTween, m_strProperty, m_objPath, m_strTransition);
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
				
				// Tween the object's property to the 'y' value of the path.
				m_objToTween[m_strProperty] = objPoint.y;
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the frame is within the frames of this tween.
			else if(uFrame >= m_uFirstFrame && uFrame <= m_uLastFrame)
			{
				// Calculate the amount of time passed during this tween based on the frames.
				var nTime:Number = (uFrame - m_uFirstFrame) / (m_uLastFrame - m_uFirstFrame);
				
				// Get the point along the path at the current frame.
				objPoint = m_objPath.getPointAt(m_fncTransition(nTime, 0, 1, 1));
				
				// Tween the object's property to the 'y' value of the path.
				m_objToTween[m_strProperty] = objPoint.y;
				
				// Mark this tween as being dirty.
				m_bIsDirty = true;
			}
			// Check to see if the current frame is beyond the last from on this tween.
			else if(uFrame > m_uLastFrame && m_bIsDirty)
			{
				// Get the point along the path at the current frame.
				objPoint = m_objPath.getPointAt(1);
				
				// Tween the object's property to the 'y' value of the path.
				m_objToTween[m_strProperty] = objPoint.y;
				
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
			return m_strProperty;
		}
	}
}