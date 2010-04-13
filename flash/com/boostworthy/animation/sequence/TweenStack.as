// *****************************************************************************************
// TweenStack.as
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

package com.boostworthy.animation.sequence
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import com.boostworthy.animation.sequence.tweens.ITween;
	import com.boostworthy.collections.iterators.IIterator;
	import com.boostworthy.collections.iterators.IteratorType;
	import com.boostworthy.collections.Stack;
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'TweenStack' class is an extension of the regular stack. When new tweens are 
	 * added to this collection, they are first compared against other tweens which 
	 * target the same object and property and re-order them for proper rendering.
	 * 
	 * @see	com.boostworthy.animation.sequence.Timeline
	 * @see	com.boostworthy.collections.Stack
	 */
	public class TweenStack extends Stack
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function TweenStack()
		{
			// Initialize the superclass constructor.
			super();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// OVERRIDES ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Adds a new tween to this object's collection.
		 * 
		 * @param	objElement	The tween to add to this object.
		 */
		public override function addElement(objElement:Object):void
		{
			// Type cast the element as a tween.
			var objNewTween:ITween = objElement as ITween;
			
			// Create a new array for temporarily storing tweens.
			var aTweens:Array = new Array();
			
			// Get an iterator instance for iterating through this stack's tweens.
			var objIterator:IIterator = getIterator();
			
			// Iterate through the collection of tweens.
			while(objIterator.hasNext())
			{
				// Get the current tween and advance to the next.
				var objTween:ITween = objIterator.next() as ITween;
				
				// Compare the target object and property of each tween to the new tween 
				// to see if they match.
				if(objTween.target == objNewTween.target && objTween.property == objNewTween.property)
				{
					// Now compare the first frames of the tweens to see if the tween is 
					// later on in the timeline than the new tween.
					if(objTween.firstFrame > objNewTween.firstFrame)
					{
						// Clone the tween and add the clone to the temporary array.
						aTweens.push(objTween.clone());
						
						// Temporarily remove the tween from this stack.
						removeElement(objTween);
					}
				}
			}
			
			// Now add the new tween.
			super.addElement(objNewTween);
			
			// Get the length of the temporary array.
			var iLength:int = aTweens.length;
			
			// Loop through the tweens that are stored in the temporary array.
			for(var i:int = 0; i < iLength; i++)
			{
				// Re-add each tween to this stack.
				super.addElement(aTweens[i]);
			}
		}
	}
}