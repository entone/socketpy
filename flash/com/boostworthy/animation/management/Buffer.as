// *****************************************************************************************
// Buffer.as
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

package com.boostworthy.animation.management
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.events.EventDispatcher;
	
	import com.boostworthy.animation.management.types.abstract.IAnimation;
	import com.boostworthy.animation.rendering.IRenderable;
	import com.boostworthy.collections.ICollection;
	import com.boostworthy.collections.iterators.IIterator;
	import com.boostworthy.collections.iterators.IteratorType;
	import com.boostworthy.collections.Queue;
	import com.boostworthy.core.IDisposable;
	import com.boostworthy.events.AnimationEvent;
	
	// META ////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Dispatched when an animation changes.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.CHANGE
	 */
	[Event(name="animationChange", type="com.boostworthy.events.AnimationEvent")]
	
	/**
	 * Dispatched when an animation stops.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.STOP
	 */
	[Event(name="animationStop", type="com.boostworthy.events.AnimationEvent")]
	
	/**
	 * Dispatched when an animation is finished.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.FINISH
	 */
	[Event(name="animationFinish", type="com.boostworthy.events.AnimationEvent")]
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Buffer' class manages a collection of animations to be rendered at 
	 * the same time.
	 * 
	 * @see	com.boostworthy.collections.Collection_I
	 */
	public class Buffer extends EventDispatcher implements ICollection, IDisposable, IRenderable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A queue for storing animation objects.
		 */
		protected var m_objQueue:Queue;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function Buffer()
		{
			// Initialize this object.
			init();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// BUFFER //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Adds a new animation to the buffer.
		 * 
		 * @param	objAnimation	The aniamtion to be added to the buffer.
		 */
		public function add(objAnimation:IAnimation):void
		{
			// Add the animation to the queue.
			m_objQueue.addElement(objAnimation);
		}
		
		/**
		 * Removes the specified animation from the buffer.
		 * 
		 * @param	objAnimation	The animation to be removed.
		 */
		public function remove(objAnimation:IAnimation):void
		{
			// Get an iterator instance from the queue.
			var objIterator:IIterator = getIterator();
			
			// Iterate through the enter frame buffer.
			while(objIterator.hasNext())
			{
				// Get the current animation object and advance to the next.
				var objElement:IAnimation = objIterator.next() as IAnimation;
				
				// Compare the buffer element to the target animation.
				if(objElement === objAnimation)
				{
					// Remove the element.
					removeElement(objElement);
					
					// Exit this loop.
					break;
				}
			}
		}
		
		/**
		 * Removes all animations involving the target object from the buffer.
		 * 
		 * @param	objTarget		The target object whose animations are to be removed.
		 */
		public function removeByTarget(objTarget:Object):void
		{
			// Get an iterator instance from the queue.
			var objIterator:IIterator = getIterator(IteratorType.ARRAY_REVERSE);
			
			// Iterate through the enter frame buffer.
			while(objIterator.hasNext())
			{
				// Get the current animation object and advance to the next.
				var objElement:IAnimation = objIterator.next() as IAnimation;
				
				// Compare the buffer element's target object to the specified target object.
				if(objElement.target === objTarget)
				{
					// Remove the element.
					removeElement(objElement);
				}
			}
		}
		
		/**
		 * Removes all animations involving the target object and it's specified property from the buffer.
		 * 
		 * @param	objTarget		The target object whose animations are to be removed.
		 * @param	strProperty		The target object's property being searched for.
		 */
		public function removeByProperty(objTarget:Object, strProperty:String):void
		{
			// Get an iterator instance from the queue.
			var objIterator:IIterator = getIterator();
			
			// Iterate through the enter frame buffer.
			while(objIterator.hasNext())
			{
				// Get the current animation object and advance to the next.
				var objElement:IAnimation = objIterator.next() as IAnimation;
				
				// Compare the buffer element's target object and property to the specified 
				// target object and property.
				if(objElement.target === objTarget && objElement.property == strProperty)
				{
					// Remove the element.
					removeElement(objElement);
					
					// Exit this loop.
					break;
				}
			}
		}
		
		/**
		 * Iterates through the contents of this buffer and renders each animation.
		 */
		public function render():Boolean
		{
			// Get an iterator instance from the queue.
			var objIterator:IIterator = getIterator();
			
			// Iterate through the buffer.
			while(objIterator.hasNext())
			{
				// Get the current animation object and advance to the next.
				var objElement:IAnimation = objIterator.next() as IAnimation;
				
				// Dispatch the animation 'change' event.
				dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE, objElement.target, objElement.property));
			
				// Render the animation. If 'false' is returned, the animation is finished.
				if(!objElement.render())
				{
					// Dispatch the animation 'finish' event.
					dispatchEvent(new AnimationEvent(AnimationEvent.FINISH, objElement.target, objElement.property));
					
					// Remove the animation from the buffer.
					m_objQueue.removeElement(objElement);
				}
			}
			
			// Return a result of 'true'.
			return true;
		}
		
		/**
		 * Clears all animations from the buffer.
		 */
		public function clear():void
		{
			// Get an iterator instance from the queue.
			var objIterator:IIterator = getIterator();
				
			// Iterate through the queue.
			while(objIterator.hasNext())
			{
				// Get the current animation object and advance to the next.
				var objElement:IAnimation = objIterator.next() as IAnimation;
				
				// Dispatch the animation 'stop' event.
				dispatchEvent(new AnimationEvent(AnimationEvent.STOP, objElement.target, objElement.property));
			}
			
			// Garbage collect for the queue.
			m_objQueue.dispose();
		}
		
		/**
		 * Gets the number of items in this buffer.
		 * 
		 * @return	The number of items in this buffer.
		 */
		public function get length():uint
		{
			// Return the queue length.
			return m_objQueue.length;
		}
		
		// ITERATION ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns an iterator of the specified type.
		 * 
		 * @param	uIterator	The iterator type to use for iterating through the data being stored by this collection. Default is '2' (IteratorType.ARRAY_FORWARD).
		 * 
		 * @return	An iterator instance of the specified type.
		 * 
		 * @see		com.boostworthy.collections.iterators.IteratorType
		 */
		public function getIterator(uIterator:uint = 2):IIterator
		{
			// Return the iterator instance.
			return m_objQueue.getIterator(uIterator);
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Clear this buffer.
			clear();
			
			// Null out the object reference.
			m_objQueue = null;
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
			// Create a new queue.
			m_objQueue = new Queue();
		}
		
		// BUFFER //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Removes an element from the queue.
		 * 
		 * @param	objElement	The element to be removed from the queue.
		 */
		protected function removeElement(objElement:IAnimation):void
		{
			// Dispatch the animation 'stop' event.
			dispatchEvent(new AnimationEvent(AnimationEvent.STOP, objElement.target, objElement.property));
					
			// Remove the animation from the buffer.
			m_objQueue.removeElement(objElement);
		}
	}
}