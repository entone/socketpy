// *****************************************************************************************
// ITween.as
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
	// INTERFACE ///////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'ITween' interface defines a common interface for all tween objects.
	 */
	public interface ITween
	{
		// *********************************************************************************
		// INTERFACE DECLERATIONS
		// *********************************************************************************
		
		/**
		 * Creates a new tween object that is a clone of it's creator.
		 * 
		 * @return	A new tween object.
		 */
		function clone():ITween
		
		/**
		 * Renders the specified frame.
		 * 
		 * @param	uFrame	The frame to render.
		 */
		function renderFrame(uFrame:uint):void
		
		/**
		 * Gets the first frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The first frame of the timeline that has a keyframe on it.
		 */
		function get firstFrame():uint
		
		/**
		 * Gets the last frame of the timeline that has a keyframe on it.
		 * 
		 * @return	The last frame of the timeline that has a keyframe on it.
		 */
		function get lastFrame():uint
		
		/**
		 * Gets a reference to the target object being tweened.
		 * 
		 * @return	A reference to the target object being tweened.
		 */
		function get target():Object
		
		/**
		 * Gets a string of the target property.
		 * 
		 * @return	A string of the target property.
		 */
		function get property():String
	}
}