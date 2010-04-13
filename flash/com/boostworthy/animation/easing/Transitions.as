// *****************************************************************************************
// Transitions.as
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

package com.boostworthy.animation.easing
{
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'Transitions' class contains time-based easing equations.
	 * <p>
	 * A special thanks goes out to Robert Penner who came up with most of these 
	 * equations and basically paved the way for modern scripted animation in Flash.
	 */
	public final class Transitions
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Reference to the linear easing equation.
		 * 
		 * @see	#linear
		 */
		public static const LINEAR:String               = "linear";
		
		/**
		 * Reference to the sine in easing equation.
		 * 
		 * @see	#sineIn
		 */
		public static const SINE_IN:String              = "sineIn";
		
		/**
		 * Reference to the sine out easing equation.
		 * 
		 * @see	#sineOut
		 */
		public static const SINE_OUT:String             = "sineOut";
		
		/**
		 * Reference to the sine in and out easing equation.
		 * 
		 * @see	#sineInAndOut
		 */
		public static const SINE_IN_AND_OUT:String      = "sineInAndOut";
		
		/**
		 * Reference to the quad in easing equation.
		 * 
		 * @see	#quadIn
		 */
		public static const QUAD_IN:String              = "quadIn";
		
		/**
		 * Reference to the quad out easing equation.
		 * 
		 * @see	#quadOut
		 */
		public static const QUAD_OUT:String             = "quadOut";
		
		/**
		 * Reference to the quad in and out easing equation.
		 * 
		 * @see	#quadInAndOut
		 */
		public static const QUAD_IN_AND_OUT:String      = "quadInAndOut";
		
		/**
		 * Reference to the cubic in easing equation.
		 * 
		 * @see	#cubicIn
		 */
		public static const CUBIC_IN:String             = "cubicIn";
		
		/**
		 * Reference to the cubic out easing equation.
		 * 
		 * @see	#cubicOut
		 */
		public static const CUBIC_OUT:String            = "cubicOut";
		
		/**
		 * Reference to the cubic in and out easing equation.
		 * 
		 * @see #cubicInAndOut
		 */
		public static const CUBIC_IN_AND_OUT:String     = "cubicInAndOut";
		
		/**
		 * Reference to the quart in easing equation.
		 * 
		 * @see	#quartIn
		 */
		public static const QUART_IN:String             = "quartIn";
		
		/**
		 * Reference to the quart out easing equation.
		 * 
		 * @see	#quartOut
		 */
		public static const QUART_OUT:String            = "quartOut";
		
		/**
		 * Reference to the quart in and out easing equation.
		 * 
		 * @see	#quartInAndOut
		 */
		public static const QUART_IN_AND_OUT:String     = "quartInAndOut";
		
		/**
		 * Reference to the quint in easing equation.
		 * 
		 * @see	#quintIn
		 */
		public static const QUINT_IN:String             = "quintIn";
		
		/**
		 * Reference to the quint out easing equation.
		 * 
		 * @see	#quintOut
		 */
		public static const QUINT_OUT:String            = "quintOut";
		
		/**
		 * Reference to the quint in and out easing equation.
		 * 
		 * @see	#quintInAndOut
		 */
		public static const QUINT_IN_AND_OUT:String     = "quintInAndOut";
		
		/**
		 * Reference to the expo in easing equation.
		 * 
		 * @see	#expoIn
		 */
		public static const EXPO_IN:String              = "expoIn";
		
		/**
		 * Reference to the expo out easing equation.
		 * 
		 * @see	#expoOut
		 */
		public static const EXPO_OUT:String             = "expoOut";
		
		/**
		 * Reference to the expo in and out easing equation.
		 * 
		 * @see	#expoInAndOut
		 */
		public static const EXPO_IN_AND_OUT:String      = "expoInAndOut";
		
		/**
		 * Reference to the back in easing equation.
		 * 
		 * @see	#backIn
		 */
		public static const BACK_IN:String              = "backIn";
		
		/**
		 * Reference to the back out easing equation.
		 * 
		 * @see	#backOut
		 */
		public static const BACK_OUT:String             = "backOut";
		
		/**
		 * Reference to the back in and out easing equation.
		 * 
		 * @see	#backInAndOut
		 */
		public static const BACK_IN_AND_OUT:String      = "backInAndOut";
		
		/**
		 * Reference to the bounce easing equation.
		 * 
		 * @see	#bounce
		 */
		public static const BOUNCE:String               = "bounce";
		
		/**
		 * Reference to the elastic in easing equation.
		 * 
		 * @see	#elasticIn
		 */
		public static const ELASTIC_IN:String           = "elasticIn";
		
		/**
		 * Reference to the elastic out easing equation.
		 * 
		 * @see	#elasticOut
		 */
		public static const ELASTIC_OUT:String          = "elasticOut";
		
		/**
		 * Reference to the elastic in and out easing equation.
		 * 
		 * @see	#elasticInAndOut
		 */
		public static const ELASTIC_IN_AND_OUT:String   = "elasticInAndOut";
		
		/**
		 * Configuration for the default transition.
		 */
		public static const DEFAULT_TRANSITION:String   = LINEAR;
		
		/**
		 * Configures the amount of overshoot to use for 'back' transitions.
		 * 
		 * @see	#backIn
		 * @see	#backOut
		 * @see	#backInAndOut
		 */
		private static const BACK_OVERSHOOT:Number      = 1.70158;
		
		/**
		 * Configures the amplitude of an elastic wave.
		 * 
		 * @see #elasticIn
		 * @see #elasticOut
		 * @see #elasticInAndOut
		 */
		private static const ELASTIC_AMPLITUDE:Number   = undefined;
		
		/**
		 * Configures the period of an elastic wave.
		 * 
		 * @see #elasticIn
		 * @see #elasticOut
		 * @see #elasticInAndOut
		 */
		private static const ELASTIC_PERIOD:Number      = 400;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public final function Transitions()
		{
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		/**
		 * Linear easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function linear(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		/**
		 * Sine in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function sineIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * Math.cos((t / d) * (Math.PI / 2)) + b + c;
		}
		
		/**
		 * Sine out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function sineOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sin((t / d) * (Math.PI / 2)) + b;
		}
		
		/**
		 * Sine in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function sineInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c / 2 * (Math.cos((t / d) * Math.PI) - 1) + b;
		}
		
		/**
		 * Quad in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quadIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t + b;
		}
		
		/**
		 * Quad out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quadOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (t /= d) * (t - 2) + b;
		}
		
		/**
		 * Quad in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quadInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if((t /= d / 2) < 1)
			{
				return c / 2 * t * t + b;
			}
			else
			{
				return -c / 2 * ((--t) * (t - 2) - 1) + b;
			}
		}
		
		/**
		 * Cubic in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function cubicIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t + b;
		}
		
		/**
		 * Cubic out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function cubicOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		/**
		 * Cubic in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function cubicInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if(( t /= d / 2) < 1)
			{
				return c / 2 * t * t * t + b;
			}
			else
			{
				return c / 2 * (( t -= 2) * t * t + 2) + b;
			}
		}
		
		/**
		 * Quart in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quartIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t + b;
		}
		
		/**
		 * Quart out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quartOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		
		/**
		 * Quart in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quartInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if((t /= d / 2) < 1)
			{
				return c / 2 * t * t * t * t + b;
			}
			else
			{
				return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
			}
		}
		
		/**
		 * Quint in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quintIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * (t /= d) * t * t * t * t + b;
		}
		
		/**
		 * Quint out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quintOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		/**
		 * Quint in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function quintInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if((t /= d / 2) < 1)
			{
				return c / 2 * t * t * t * t * t + b;
			}
			else
			{
				return c / 2 * (( t -= 2) * t * t * t * t + 2) + b;
			}
		}
		
		/**
		 * Expo in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function expoIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
		}
		
		/**
		 * Expo out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function expoOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
		}
		
		/**
		 * Expo in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function expoInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if(t == 0) 
			{
				return b;
			}
			
			if(t == d) 
			{
				return b + c;
			}
			
			if((t /= d / 2) < 1)
			{
				return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
			}
			
			return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		/**
		 * Back in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function backIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			var s:Number = BACK_OVERSHOOT;
			
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		/**
		 * Back out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function backOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			var s:Number = BACK_OVERSHOOT;
			
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		/**
		 * Back in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function backInAndOut (t:Number, b:Number, c:Number, d:Number):Number
		{
			var s:Number = BACK_OVERSHOOT;
			
			if((t /= d / 2) < 1)
			{
				return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			}
			
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
		
		/**
		 * Bounce easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function bounce(t:Number, b:Number, c:Number, d:Number):Number
		{
			if((t /= d) < (1 / 2.75))
			{
				return c * (7.5625 * t * t) + b;
			}
			else if(t < (2 / 2.75))
			{
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
			}
			else if(t < (2.5 / 2.75))
			{
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
			}
			else
			{
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
			}
		}
		
		/**
		 * Elastic in easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function elasticIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			var a:Number = ELASTIC_AMPLITUDE;
			var p:Number = ELASTIC_PERIOD;
			var s:Number;
			
			if(t == 0)
			{
				return b;
			}
			
			if((t /= d) == 1)
			{
				return b + c; 
			}
			
			if(!p)
			{
				p = d * 0.3;
			}
			
			if(!a || a < Math.abs(c))
			{
				a = c; 
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin (c / a);
			}
			
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		}
		
		/**
		 * Elastic out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function elasticOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			var a:Number = ELASTIC_AMPLITUDE;
			var p:Number = ELASTIC_PERIOD;
			var s:Number;
			
			if(t == 0)
			{
				return b;
			}
			
			if((t /= d) == 1)
			{
				return b + c;
			}
			
			if(!p)
			{
				p = d * 0.3;
			}
			
			if(!a || a < Math.abs(c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin (c / a);
			}
			
			return (a * Math.pow(2, -10 * t) * Math.sin( (t * d - s)*(2 * Math.PI) / p) + c + b);
		}
		
		/**
		 * Elastic in and out easing equation.
		 * 
		 * @param	t	TIME: 		Current time during the tween. 0 to duration.
		 * @param	b	BEGINING:	Starting value of the property being tweened.
		 * @param	c	CHANGE:		Change in the properties value from start to target.
		 * @param	d	DURATION:	Duration of the tween.
		 * 
		 * @return	The resulting tweened value.
		 */
		public static function elasticInAndOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			var a:Number = ELASTIC_AMPLITUDE;
			var p:Number = ELASTIC_PERIOD;
			var s:Number;
			
			if(t == 0)
			{
				return b; 
			}
			
			if((t /= d / 2) == 2)
			{
				return b + c;
			}
			
			if(!p)
			{
				p = d * (0.3 * 1.5);
			}
			
			if(!a || a < Math.abs(c))
			{ 
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(c / a);
			}
			
			if(t < 1)
			{
				return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t * d - s)*(2 * Math.PI) / p )) + b;
			}
			else
			{
				return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
			}
		}
	}
}