// *****************************************************************************************
// Animation.as
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

package com.boostworthy.animation.management.types.abstract
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.animation.management.types.abstract.IAnimation
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Animation' class is the base class for all animation objects.
	 */
	public class Animation implements IAnimation
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds a reference to the target object being animated.
		 */
		protected var m_objTarget:Object;
		
		/**
		 * Holds the property of the target object that is being animated.
		 */
		protected var m_strProperty:String;
		
		/**
		 * Holds the method being used to render this animation.
		 */
		protected var m_uRenderMethod:uint;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	objTarget		The target object being animated.
		 * @param	strProperty		The property of the target object that is being animated.
		 * @param	uRenderMethod	The method being used to render this animation.
		 * 
		 * @see 	com.boostworthy.animation.RenderMethod
		 */
		public function Animation(objTarget:Object, strProperty:String, uRenderMethod:uint)
		{
			// Store the parameters.
			m_objTarget     = objTarget;
			m_strProperty   = strProperty;
			m_uRenderMethod = uRenderMethod;
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// INFO ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets a reference to the target object being animated.
		 * 
		 * @return	A reference to the target object being animated.
		 */
		public function get target():Object
		{
			// Return the scope.
			return m_objTarget;
		}
		
		/**
		 * Gets the property of the target object being animated.
		 * 
		 * @return	The property of the target object being animated.
		 */
		public function get property():String
		{
			// Return the property.
			return m_strProperty;
		}
		
		/**
		 * Gets the method being used to render the animation.
		 * 
		 * @return	The method being used to render the animation.
		 * 
		 * @see com.boostworthy.animation.RenderMethod
		 */
		public function get method():uint
		{
			// Return the property.
			return m_uRenderMethod;
		}
		
		// RENDERING ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Renders the animation.
		 * 
		 * @return	A boolean value that is 'true' if the animation was updated successfully, 'false' if it was not.
		 */
		public function render():Boolean
		{
			// Return 'false' by default.
			return false;
		}
	}
}