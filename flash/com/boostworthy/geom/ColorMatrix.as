// *****************************************************************************************
// ColorMatrix.as
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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// META ////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Dispatched when the value of this object changes.
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The 'ColorMatrix' class presents a useful API for transforming color values using 
	 * traditional methods such as brightness, contrast, hue, and saturation.
	 * <p>
	 * The general mindset behind the calculations for a color matrix are as follows:
	 * <p>
	 * redResult   = (a[0]  * srcR) + (a[1]  * srcG) + (a[2]  * srcB) + (a[3]  * srcA) + a[4]  <br>
	 * greenResult = (a[5]  * srcR) + (a[6]  * srcG) + (a[7]  * srcB) + (a[8]  * srcA) + a[9]  <br>
	 * blueResult  = (a[10] * srcR) + (a[11] * srcG) + (a[12] * srcB) + (a[13] * srcA) + a[14] <br>
	 * alphaResult = (a[15] * srcR) + (a[16] * srcG) + (a[17] * srcB) + (a[18] * srcA) + a[19]
	 * <p>
	 * For more information on the formulas used in this class, see:
	 * <p>
	 * http://www.graficaobscura.com/matrix/index.html
	 */
	public class ColorMatrix extends EventDispatcher
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Configuration for the red portion of the luminance vector.
		 */
		protected const LUMINANCE_R:Number = 0.212671;
		
		/**
		 * Configuration for the green portion of the luminance vector.
		 */
		protected const LUMINANCE_G:Number = 0.715160;
		
		/**
		 * Configuration for the blue portion of the luminance vector.
		 */
		protected const LUMINANCE_B:Number = 0.072169;
		
		/**
		 * The default matrix for this object to begin at.
		 */
		protected const IDENTITY:Array     = [1, 0, 0, 0, 0,
											  0, 1, 0, 0, 0,
											  0, 0, 1, 0, 0,
											  0, 0, 0, 1, 0];
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Stores the current matrix of values that this object represents.
		 */
		protected var m_aMatrix:Array;
		
		/**
		 * Stores the current alpha setting.
		 */
		protected var m_nAlpha:Number;
		
		/**
		 * Stores the current brightness setting.
		 */
		protected var m_nBrightness:Number;
		
		/**
		 * Stores the current contrast setting.
		 */
		protected var m_nContrast:Number;
		
		/**
		 * Stores the current hue setting.
		 */
		protected var m_nHue:Number;
		
		/**
		 * Stores the current saturation setting.
		 */
		protected var m_nSaturation:Number;
		
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 * 
		 * @param	aMatrix		An array of 20 items for 4 x 5 color transform to initialize this object with.
		 */
		public function ColorMatrix(aMatrix:Array = null)
		{
			// Initialize this object.
			init(aMatrix == null ? IDENTITY.concat() : aMatrix.concat());
		}
		
		// *********************************************************************************
		// API
		// *********************************************************************************
		
		// OBJECT OVERRIDE /////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the raw array of color transform data that this object represents.
		 * 
		 * @return	A copy of the color transform matrix that this object represents.
		 */
		public function valueOf():Array
		{
			// Return a copy of the matrix array.
			return m_aMatrix.concat();
		}
		
		// OBJECT //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new color matrix object that is a clone of this object.
		 * 
		 * @return	A new color matrix object.
		 */
		public function clone():ColorMatrix
		{
			// Return a new color matrix object.
			return new ColorMatrix(valueOf());
		}
		
		/**
		 * Resets this object back to it's original state.
		 */
		public function reset():void
		{
			// Initialize this object with it's original identity.
			init(IDENTITY.concat());
		}
		
		// ALPHA ///////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the current alpha setting.
		 * 
		 * @return	A value between 0 and 100 (0 being 0% alpha, 100 being 100% alpha).
		 */
		public function get alpha():Number
		{
			// Return the current alpha setting.
			return m_nAlpha;
		}
		
		/**
		 * Sets the current alpha setting.
		 * 
		 * @param	nAlpha	A value between 0 and 100 (0 being 0% alpha, 100 being 100% alpha).
		 */
		public function set alpha(nAlpha:Number):void
		{
			// Log the old value.
			var nOldValue:Number = m_nAlpha / 100;
			
			// Store the new alpha setting.
			m_nAlpha = nAlpha;
			
			// Interpolate the alpha range to be between 0.0 and 1.0.
			nAlpha  /= 100;
			
			// Adjust the new value so that it creates the target value when multiplied 
			// against the old.
			nAlpha  /= nOldValue;
			
			// Create a new matrix array and insert the new values.
			var aMatrix:Array = [1, 0, 0, 0,      0,
								 0, 1, 0, 0,      0,
								 0, 0, 1, 0,      0,
								 0, 0, 0, nAlpha, 0];
			
			// Multiply the matrix array against the current array.
			multiply(aMatrix);
		}
		
		// BRIGHTNESS //////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the current brightness setting.
		 * 
		 * @return	A value between -100 and 100 (0 being 'no changes').
		 */
		public function get brightness():Number
		{
			// Return the current brightness setting.
			return m_nBrightness;
		}
		
		/**
		 * Sets the current brightness setting.
		 * 
		 * @param	nBrightness		A value between -100 and 100 (0 being 'no changes').
		 */
		public function set brightness(nBrightness:Number):void
		{
			// Log the old value.
			var nOldValue:Number = m_nBrightness * (255 / 100);
			
			// Store the new brightness setting.
			m_nBrightness = nBrightness;
			
			// Interpolate the brightness value to a value ranging from -255 to 255.
			nBrightness  *= (255 / 100);
			
			// Subtract the old value from the new.
			nBrightness -= nOldValue;
			
			// Create a new matrix array and insert the new values.
			var aMatrix:Array = [1, 0, 0, 0, nBrightness,
								 0, 1, 0, 0, nBrightness,
								 0, 0, 1, 0, nBrightness,
								 0, 0, 0, 1, 0          ];
			
			// Multiply the matrix array against the current array.
			multiply(aMatrix);
		}
		
		// CONTRAST ////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the current contrast setting.
		 * 
		 * @return	A value between -100 and 100 (0 being 'no changes').
		 */
		public function get contrast():Number
		{
			// Return the current contrast setting.
			return m_nContrast;
		}
		
		/**
		 * Sets the current contrast setting.
		 * 
		 * @param	nContrast	A value between -100 and 100 (0 being 'no changes').
		 */
		public function set contrast(nContrast:Number):void
		{
			// Log the old value.
			var nOldValue:Number = m_nContrast / 100 + 1;
			
			// Store the new contrast setting.
			m_nContrast = nContrast;
			
			// Interpolate the contrast value to a value ranging from 0.0 to 2.0.
			nContrast   = nContrast / 100 + 1;
			
			/// Adjust the new value so that it creates the target value when multiplied 
			// against the old.
			nContrast  /= nOldValue;
			
			// Create a new matrix array and insert the new values.
			var aMatrix:Array = [nContrast, 0,         0,         0, 128 * (1 - nContrast),
								 0,         nContrast, 0,         0, 128 * (1 - nContrast),
								 0,         0,         nContrast, 0, 128 * (1 - nContrast),
								 0,         0,         0,         1, 0                    ];
			
			// Multiply the matrix array against the current array.
			multiply(aMatrix);
		}
		
		// HUE /////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the current hue setting.
		 * 
		 * @return	A value between -180 and 180 (0 being 'no changes').
		 */
		public function get hue():Number
		{
			// Return the current hue setting.
			return m_nHue;
		}
		
		/**
		 * Sets the current hue setting.
		 * 
		 * @param	nAngle	A value between -180 and 180 (0 being 'no changes').
		 */
		public function set hue(nAngle:Number):void
		{
			// Log the old value.
			var nOldValue:Number = m_nHue * (Math.PI / 180);
			
			// Store the new hue setting.
			m_nHue  = nAngle;
			
			// Convert the angle from degrees to radians.
			nAngle *= Math.PI / 180;
			
			// Subtract the old value from the new.
			nAngle -= nOldValue;
			
			// Calculate the cosine and sine of the angle.
			var nCos:Number   = Math.cos(nAngle);
			var nSin:Number   = Math.sin(nAngle);
			
			// Create a new matrix array and insert the new values.
			var aMatrix:Array = [(LUMINANCE_R + (nCos * (1 - LUMINANCE_R))) + (nSin * (-LUMINANCE_R)),       (LUMINANCE_G + (nCos * (-LUMINANCE_G)))    + (nSin * (-LUMINANCE_G)), (LUMINANCE_B + (nCos * (-LUMINANCE_B)))    + (nSin * (1 - LUMINANCE_B)), 0, 0,
								 (LUMINANCE_R + (nCos * (-LUMINANCE_R)))    + (nSin * 0.143),                (LUMINANCE_G + (nCos * (1 - LUMINANCE_G))) + (nSin * 0.14),           (LUMINANCE_B + (nCos * (-LUMINANCE_B)))    + (nSin * -0.283),            0, 0,
								 (LUMINANCE_R + (nCos * (-LUMINANCE_R)))    + (nSin * (-(1 - LUMINANCE_R))), (LUMINANCE_G + (nCos * (-LUMINANCE_G)))    + (nSin * LUMINANCE_G),    (LUMINANCE_B + (nCos * (1 - LUMINANCE_B))) + (nSin * LUMINANCE_B),       0, 0,
								 0,                                                                          0,                                                                    0,                                                                       1, 0];
			
			// Multiply the matrix array against the current array.
			multiply(aMatrix);
		}
		
		// SATURATION //////////////////////////////////////////////////////////////////////
		
		/**
		 * Gets the current saturation setting.
		 * 
		 * @return	A value between -100 and 100 (0 being 'no changes').
		 */
		public function get saturation():Number
		{
			// Return the current saturation setting.
			return m_nSaturation;
		}
		
		/**
		 * Sets the current saturation setting.
		 * 
		 * @param	nSaturation		A value between -100 and 100 (0 being 'no changes').
		 */
		public function set saturation(nSaturation:Number):void
		{
			// Log the old value.
			var nOldValue:Number = (m_nSaturation + 100) / 100;
			
			// Store the new saturation setting.
			m_nSaturation = Math.min(100, Math.max(-99.99, nSaturation));
			
			// Interpolate the saturation value to a value ranging from 0.0 to 2.0.
			nSaturation   = (m_nSaturation + 100) / 100;
			
			// Adjust the new value so that it creates the target value when multiplied 
			// against the old.
			nSaturation  /= nOldValue;
			
			// Calculate the luminance for R, G, and B.
			var nLumR:Number  = (1 - nSaturation) * LUMINANCE_R;
			var nLumG:Number  = (1 - nSaturation) * LUMINANCE_G;
			var nLumB:Number  = (1 - nSaturation) * LUMINANCE_B;
			
			// Create a new matrix array and insert the new values.
			var aMatrix:Array = [nLumR + nSaturation, nLumG,               nLumB,               0, 0, 
								 nLumR,               nLumG + nSaturation, nLumB,               0, 0,
								 nLumR,               nLumG,               nLumB + nSaturation, 0, 0,
								 0,                   0,                   0,                   1, 0];
		
			// Multiply the matrix array against the current array.
			multiply(aMatrix);
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 * 
		 * @param	aMatrix		An array of 20 items for 4 x 5 color transform to initialize this object with.
		 */
		protected function init(aMatrix:Array):void
		{
			// Store the matrix.
			m_aMatrix = aMatrix;
			
			// Set all default property values.
			setDefaultValues();
		}
		
		/**
		 * Applies all default values to the corresponding properties.
		 */
		protected function setDefaultValues():void
		{
			// Apply the default values.
			m_nAlpha      = 100;
			m_nBrightness = 0;
			m_nContrast   = 0;
			m_nHue        = 0;
			m_nSaturation = 0;
		}
		
		// MATRIX //////////////////////////////////////////////////////////////////////////
		
		/**
		 * Multiplies the specified matrix array against the one this object represents.
		 * 
		 * @param	aMatrix		An array of 20 items for 4 x 5 color transform to multiply against this object's matrix array.
		 */
		protected function multiply(aMatrix:Array):void
		{
			// Create a temporary buffer array for storing data.
			var aBuffer:Array = new Array();
			
			// Create a temporary integer for storing the count.
			var iCount:int = 0;
			
			// Loop through the matrix columns.
			for(var iCol:int = 0; iCol < 4; iCol++)
			{
				// Loop through the matrix rows.
				for(var iRow:int = 0; iRow < 5; iRow++)
				{
					// Multiply and add the results to each item.
					aBuffer[iCount + iRow] = aMatrix[iCount]     * m_aMatrix[iRow]      + 
											 aMatrix[iCount + 1] * m_aMatrix[iRow + 5]  + 
											 aMatrix[iCount + 2] * m_aMatrix[iRow + 10] + 
											 aMatrix[iCount + 3] * m_aMatrix[iRow + 15] + 
											 (iRow == 4 ? aMatrix[iCount + 4] : 0);
				}
				
				// Update the count.
				iCount += 5;
			}
			
			// Store the resulting array.
			m_aMatrix = aBuffer.concat();
			
			// Dispatch a new 'change' event.
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}