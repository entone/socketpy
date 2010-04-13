// *****************************************************************************************
// AnimationManager.as
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
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.ColorTransform;
	
	import com.boostworthy.animation.BoostworthyAnimation;
	import com.boostworthy.animation.easing.Transitions;
	import com.boostworthy.animation.management.Framebuffer;
	import com.boostworthy.animation.rendering.RenderMethod;
	import com.boostworthy.animation.management.types.AlphaAnimation;
	import com.boostworthy.animation.management.types.BlurAnimation;
	import com.boostworthy.animation.management.types.BrightnessAnimation;
	import com.boostworthy.animation.management.types.ColorAnimation;
	import com.boostworthy.animation.management.types.ContrastAnimation;
	import com.boostworthy.animation.management.types.FilterAnimation;
	import com.boostworthy.animation.management.types.FunctionsAnimation;
	import com.boostworthy.animation.management.types.HueAnimation;
	import com.boostworthy.animation.management.types.MoveAnimation;
	import com.boostworthy.animation.management.types.PropertyAnimation;
	import com.boostworthy.animation.management.types.PulseAnimation;
	import com.boostworthy.animation.management.types.RotationAnimation;
	import com.boostworthy.animation.management.types.SaturationAnimation;
	import com.boostworthy.animation.management.types.ScaleAnimation;
	import com.boostworthy.animation.management.types.SizeAnimation;
	import com.boostworthy.core.Global;
	import com.boostworthy.core.IColorable;
	import com.boostworthy.core.IDisposable;
	
	// META ////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Dispatched when an animation starts.
	 * 
	 * @eventType com.boostworthy.events.AnimationEvent.START
	 */
	[Event(name="animationStart", type="com.boostworthy.events.AnimationEvent")]
	
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
	 * The 'AnimationManager' class creates a quick and easy approach to simple animations.
	 * For more complex animation sequences, the 'Timeline' object is a better canidate.
	 * 
	 * @see	com.boostworthy.animation.sequence.Timeline
	 */
	public class AnimationManager implements IEventDispatcher, IDisposable
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Configures the default refresh rate to be used. This value is the interval 
		 * in which animations being rendered using the 'RenderMethod.TIMER' method  
		 * will be refreshed. The value is in milliseconds.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		protected const DEFAULT_REFRESH_RATE:Number = 10;
		
		/**
		 * Configures the default animation transition.
		 * 
		 * @see	com.boostworthy.animation.easing.Transitions
		 */
		protected const DEFAULT_TRANSITION:String   = Transitions.DEFAULT_TRANSITION;
		
		/**
		 * Configures the default render method for rendering animations.
		 * 
		 * @see	com.boostworthy.animation.rendering.RenderMethod
		 */
		protected const DEFAULT_RENDER_METHOD:uint  = RenderMethod.TIMER;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * A framebuffer instance for managing all animations to be rendered.
		 * 
		 * @see	com.boostworthy.animation.management.Framebuffer
		 */
		protected var m_objFramebuffer:Framebuffer;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function AnimationManager()
		{
			// Initialize this object.
			init();
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// ANIMATION TYPES /////////////////////////////////////////////////////////////////
		
		/**
		 * Animates any object's property to the desired target value.
		 * <p>
		 * @param	objTarget		A reference to the object whose property is being animated.
		 * @param	strProperty		The name of the property being animated.
		 * @param	nTargetValue	The value the property is getting animated to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function property(objTarget:Object, strProperty:String, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new PropertyAnimation(objTarget, strProperty, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates any value that is accessed through get and set functions instead of getter/setters.
		 * <p>
		 * @param	objTarget		A reference to the object whose functions are being used to animate a value.
		 * @param	strGetFunction	The get function of the target object that is being animated.
		 * @param	strSetFunction	The set function of the target object that is being animated.
		 * @param	nTargetValue	The target value the object's value is getting animated to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function functions(objTarget:Object, strGetFunction:String, strSetFunction:String, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new FunctionsAnimation(objTarget, strGetFunction, strSetFunction, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the 'x' and 'y' properties of a display object to the desired target values.
		 * <p>
		 * @param	objTarget		A reference to the object whose properties are being animated.
		 * @param	nTargetValueX	The target value for the 'x' property of the target object.
		 * @param	nTargetValueY	The target value for the 'y' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function move(objTarget:DisplayObject, nTargetValueX:Number, nTargetValueY:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new MoveAnimation(objTarget, nTargetValueX, nTargetValueY, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the 'width' and 'height' properties of a display object to the desired target values.
		 * <p>
		 * @param	objTarget		A reference to the object whose properties are being animated.
		 * @param	nTargetValueW	The target value for the 'width' property of the target object.
		 * @param	nTargetValueH	The target value for the 'height' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function size(objTarget:DisplayObject, nTargetValueW:Number, nTargetValueH:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new SizeAnimation(objTarget, nTargetValueW, nTargetValueH, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the 'scaleX' and 'scaleY' properties of a display object to the desired target values.
		 * <p>
		 * @param	objTarget		A reference to the object whose properties are being animated.
		 * @param	nTargetValueX	The target value for the 'scaleX' property of the target object.
		 * @param	nTargetValueY	The target value for the 'scaleY' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function scale(objTarget:DisplayObject, nTargetValueX:Number, nTargetValueY:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new ScaleAnimation(objTarget, nTargetValueX, nTargetValueY, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the 'rotation' property of a display object to the desired target value.
		 * <p>
		 * The advantage of using this method over the generic 'Property' method is that you can 
		 * specify the amount of times the animation occurs using the 'number of repeats' parameter. 
		 * If the number of repeats is set to '1', the animation will occur one time and animate the 
		 * rotation property to the specified target value. If a value other than '1' is used, the 
		 * animation will occur the set number of times, but instead of animating the rotation property 
		 * to the target value, the target value will be added to the current rotation value each time 
		 * the animation occurs. A value of '0' for the number of repeats will cause the animation to 
		 * continue until it is manually removed.
		 * <p>
		 * @param	objTarget		A reference to the object whose property is being animated.
		 * @param	nTargetValue	The target value for the 'rotation' property of the target object. If a repeat count other than '1' is used, this will be used as the amount to change the value instead of being a target value.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	uNumRepeats		The number of times to repeat the animation. A value of '0' will cause the animation to continue until manually removed.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function rotation(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, uNumRepeats:uint = 1, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new RotationAnimation(objTarget, nTargetValue, nDuration, uNumRepeats, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the 'alpha' property of a display object to the desired target value.
		 * <p>
		 * The advantage to using this method over the method 'Property' is that a.) it is slightly
		 * faster since the property is hard-coded into the animation instead of dynamically accessed each 
		 * update and more importantly b.) it checks the alpha property at the end of the animation and if 
		 * the value is '0', it sets the target object's visibility to 'false'. If you need the visibility
		 * to remain untouched, use the 'Property' method instead.
		 * <p>
		 * @param	objTarget		A reference to the object whose property is being animated.
		 * @param	nTargetValue	The target value for the 'alpha' property of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function alpha(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new AlphaAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the color of a display object to the desired target color value.
		 * <p>
		 * NOTE: If a display object doesn't already have a color transformation object 
		 * applied to it, use the 'InitColor' method to initialize it's starting color.
		 * <p>
		 * @param	objTarget		A reference to the object whose color value is being animated.
		 * @param	nTargetValue	The target color value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		#InitColor
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function color(objTarget:DisplayObject, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new ColorAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the brightness of a 'colorable' object to the desired target color value.
		 * <p>
		 * @param	objTarget		A reference to the object whose brightness value is being animated.
		 * @param	nTargetValue	The target brightness value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.core.IColorable
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function brightness(objTarget:IColorable, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new BrightnessAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the contrast of a 'colorable' object to the desired target color value.
		 * <p>
		 * @param	objTarget		A reference to the object whose contrast value is being animated.
		 * @param	nTargetValue	The target contrast value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.core.IColorable
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function contrast(objTarget:IColorable, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new ContrastAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the hue of a 'colorable' object to the desired target color value.
		 * <p>
		 * @param	objTarget		A reference to the object whose hue value is being animated.
		 * @param	nTargetValue	The target hue value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.core.IColorable
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function hue(objTarget:IColorable, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new HueAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the saturation of a 'colorable' object to the desired target color value.
		 * <p>
		 * @param	objTarget		A reference to the object whose saturation value is being animated.
		 * @param	nTargetValue	The target saturation value of the target object.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.core.IColorable
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function saturation(objTarget:IColorable, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new SaturationAnimation(objTarget, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates any object's property back and forth between a minimum and maximum 
		 * value using a sine wave. In this case, the duration is how long a single 
		 * wave cycle takes to occur, thus impacting the speed of the pulse. A pulse 
		 * animation will coninue to occur until it is removed from the framebuffer 
		 * using the 'Remove' or 'RemoveAll' methods of this manager.
		 * <p>
		 * @param	objTarget		A reference to the object whose property is being animated.
		 * @param	strProperty		The name of the property being animated.
		 * @param	nMin			The minimum value output by the pulse.
		 * @param	nMax			The maximum value output by the pulse.
		 * @param	nDuration		The amount of time it takes for one wave cycle (Min -> Max -> Min).
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		#Remove
		 * @see		#RemoveAll
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function pulse(objTarget:Object, strProperty:String, nMin:Number, nMax:Number, nDuration:Number, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Check to see if the target object is a display object.
			if(objTarget is DisplayObject)
			{
				// Set the global stage reference if one doesn't already exist.
				setStageReference(objTarget as DisplayObject);
			}
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new PulseAnimation(objTarget, strProperty, nMin, nMax, nDuration, uRenderMethod));
		}
		
		/**
		 * Animates the 'blurX' and 'blurX' filter properties of a display object to the desired target values.
		 * <p>
		 * @param	objTarget		A reference to the object whose blur filter propertes are being animated.
		 * @param	nTargetValueX	The target value for the 'blurX' property of the target object's blur filter. A value that is a power of two is recommended for maximum performance.
		 * @param	nTargetValueY	The target value for the 'blurY' property of the target object's blur filter. A value that is a power of two is recommended for maximum performance.
		 * @param	nQuality		The quality of the blur being applied.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function blur(objTarget:DisplayObject, nTargetValueX:Number, nTargetValueY:Number, nQuality:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new BlurAnimation(objTarget, nTargetValueX, nTargetValueY, nQuality, nDuration, strTransition, uRenderMethod));
		}
		
		/**
		 * Animates the property of any object's filter to a specified target value. The filter must already be applied to the display object; one will not be added for you if it is not present.
		 * <p>
		 * @param	objTarget		A reference to the object whose filter is being animated.
		 * @param	objFilter		The filter class whose property is being animated. The filter must already be applied to the display object prior to being animated.
		 * @param	strProperty		The property of the target object's filter that is being animated.
		 * @param	nTargetValue	The value the property is being animated to.
		 * @param	nDuration		The duration of the animation in milliseconds.
		 * @param	strTransition	The transition to be used for the animation. If one is not specified, the 'DEFAULT_TRANSITION' is used.
		 * @param	uRenderMethod	The render method to use for rendering this object. If one is not specified, the 'DEFAULT_RENDER_METHOD' is used.
		 * 
		 * @see		com.boostworthy.animation.easing.Transitions
		 * @see		com.boostworthy.animation.rendering.RenderMethod
		 * @see		#DEFAULT_TRANSITION
		 * @see		#DEFAULT_RENDER_METHOD
		 */
		public function filter(objTarget:DisplayObject, objFilter:Class, strProperty:String, nTargetValue:Number, nDuration:Number, strTransition:String = DEFAULT_TRANSITION, uRenderMethod:uint = DEFAULT_RENDER_METHOD):void
		{
			// Set the global stage reference if one doesn't already exist.
			setStageReference(objTarget);
			
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.addBufferObject(new FilterAnimation(objTarget, objFilter, strProperty, nTargetValue, nDuration, strTransition, uRenderMethod));
		}
		
		// GARBAGE COLLECTION //////////////////////////////////////////////////////////////
		
		/**
		 * Performs any appropriate clean-up tasks for garbage collection such as 
		 * removing event listeners, setting object references to 'null', etc.
		 */
		public function dispose():void
		{
			// Garbage collect for the framebuffer.
			m_objFramebuffer.dispose();
			
			// Null out the object reference.
			m_objFramebuffer = null;
		}
		
		/**
		 * Removes all instances of the specified object from the framebuffer.
		 * 
		 * @param	objTarget	The object to remove from the framebuffer.
		 */
		public function remove(objTarget:Object):void
		{
			// Remove the object from the framebuffer.
			m_objFramebuffer.removeBufferObject(objTarget);
		}
		
		/**
		 * Removes all animations currently in the framebuffer.
		 */
		public function removeAll():void
		{
			// Clear the framebuffer.
			m_objFramebuffer.clearBuffer();
		}
		
		// COLOR INITIALIZATION ////////////////////////////////////////////////////////////
		
		/**
		 * Initializes the color of a display object so that it's color can be animated.
		 * Use this method to set the starting color of a display object before calling 
		 * the 'Color' method.
		 * <p>
		 * @param	objTarget		The display object to initialize color for.
		 * @param	nColorValue		The color value to apply to the target display object.
		 * 
		 * @see #color
		 */
		public function initColor(objTarget:DisplayObject, nColorValue:Number):void
		{
			// Create a temporary color transform object to apply the color value to.
			var objColor:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, NaN);
			
			// Apply the color value to the color transform object.
			objColor.color = nColorValue;
				
			// Apply the color transform object to the target object.
			objTarget.transform.colorTransform = objColor;
		}
		
		// EVENT DISPATCHER COMPOSITION ////////////////////////////////////////////////////
		
		/**
		 * Adds an animation event listener to the framebuffer.
		 * <p>
		 * @param	strType			The event type being listened for.
		 * @param	fncListener		A reference to the event handler to be called upon the event being dispatched.
		 * 
		 * @see com.boostworthy.animation.management.Framebuffer
		 */
		public function addEventListener(strType:String, fncListener:Function, bUseCapture:Boolean = false, iPriority:int = 0, bUseWeakReference:Boolean = false):void
		{
			// Add the animation event listener to the framebuffer.
			m_objFramebuffer.addEventListener(strType, fncListener, bUseCapture, iPriority, bUseWeakReference);
		}
		
		/**
		 * Removes an animation event listener from the framebuffer.
		 * 
		 * @param	strType			The event type being listened for.
		 * @param	fncListener		A reference to the event handler to be called upon the event being dispatched.
		 * 
		 * @see com.boostworthy.animation.management.Framebuffer
		 */
		public function removeEventListener(strType:String, fncListener:Function, bUseCapture:Boolean = false):void
		{
			// Remove the animation event listener from the framebuffer.
			m_objFramebuffer.removeEventListener(strType, fncListener, bUseCapture);
		}
		
		/**
		 * Dispatches the specified event.
		 * 
		 * @param	objEvent	The event to dispatch.
		 * @return	A value of 'true' unless 'preventDefault()' is called on the event, in which case it returns 'false'.
		 */
		public function dispatchEvent(objEvent:Event):Boolean
		{
			// Return the result.
			return m_objFramebuffer.dispatchEvent(objEvent);
		}
		
		/**
		 * Check to see if the event dispatcher has any listeners registered for the specified event type.
		 * 
		 * @param	strType		The type of event.
		 * @return	A value of 'true' if a listener of the specified type is registered; 'false' otherwise. 
		 */
		public function hasEventListener(strType:String):Boolean
		{
			// Return the result.
			return m_objFramebuffer.hasEventListener(strType);
		}
		
		/**
		 * Check to see if the event dispatcher or any of it's ancestors have any listeners registered for the specified event type.
		 * 
		 * @param	strType		The type of event.
		 * @return	A value of true if a listener of the specified type will be triggered; false otherwise. 
		 */
		public function willTrigger(strType:String):Boolean
		{
			// Return the result.
			return m_objFramebuffer.willTrigger(strType);
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
			// Create an initial log for the animation system.
			BoostworthyAnimation.log();
			
			// Create a new framebuffer instance.
			m_objFramebuffer = new Framebuffer(DEFAULT_REFRESH_RATE);
		}
		
		// STAGE ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sets a global reference to the 'Stage' if one doesn't already exist.
		 * 
		 * @param	objTarget	A display object to grab a reference to the stage from.
		 * 
		 * @see	com.boostworthy.core.Global
		 */
		protected function setStageReference(objTarget:DisplayObject):void
		{
			// Check to see if a global stage reference exists.
			if(!Global.stage)
			{
				// Set the global stage reference.
				Global.stage = objTarget.stage;
			}
		}
	}
}