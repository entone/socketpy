// *****************************************************************************************
// AnimationEvent.as
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

package com.boostworthy.events
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.events.Event;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'AnimationEvent' object extends upon the base 'Event' object by defining
	 * event type constants specific to animations, as well as offering getters for
	 * referencing the object and property being animated.
	 * 
	 * @see flash.events.Event
	 */
	public class AnimationEvent extends Event
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Event type constant for the 'animationStart' event.
		 */
		public static const START:String  = "animationStart";
		
		/**
		 * Event type constant for the 'animationChange' event.
		 */
		public static const CHANGE:String = "animationChange";
		
		/**
		 * Event type constant for the 'animationStop' event.
		 */
		public static const STOP:String   = "animationStop";
		
		/**
		 * Event type constant for the 'animationFinish' event.
		 */
		public static const FINISH:String = "animationFinish";
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A reference to the object whose property is being animated.
		 */
		protected var m_objTarget:Object;
		
		/**
		 * The property being animated.
		 */
		protected var m_strProperty:String;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	strType			The type of animation event.
		 * @param	objTarget		The object whose property is being animated.
		 * @param	strProperty		The property of the target object being animated.
		 */
		public function AnimationEvent(strType:String, objTarget:Object = null, strProperty:String = "")
		{
			// Invoke the superclass constructor with the necessary parameters.
			super(strType);
			
			// Store the additional parameters
			m_objTarget   = objTarget;
			m_strProperty = strProperty;
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Getter for referencing the object whose property is being animated.
		 * 
		 * @return	A reference to the object whose property is being animated.
		 */
		public function get animTarget():Object
		{
			// Return the target object.
			return m_objTarget;
		}
		
		/**
		 * Getter for referencing the property being animated.
		 * 
		 * @return	The property being animated.
		 */
		public function get animProperty():String
		{
			// Return the property.
			return m_strProperty;
		}
	}
}