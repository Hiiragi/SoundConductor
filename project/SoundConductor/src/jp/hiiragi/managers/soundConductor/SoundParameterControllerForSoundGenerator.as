/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Hiiragi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;

	import a24.tween.Ease24;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	internal class SoundParameterControllerForSoundGenerator extends AbstractParameterController
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		public function SoundParameterControllerForSoundGenerator(soundParameterType:SoundParameterType, initValue:Number)
		{
			var minValue:Number;
			var maxValue:Number;
			if (soundParameterType == SoundParameterType.VOLUME)
			{
				minValue = 0;
				maxValue = 1;
			}
			else if (soundParameterType == SoundParameterType.PAN)
			{
				minValue = -1;
				maxValue = 1;
			}

			super(initValue, minValue, maxValue);
		}


//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  tween
		//----------------------------------
		private var _t:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;

		private var _tweening:Boolean;

		private var _easing:Function;

		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _targetValue:Number;


//--------------------------------------------------------------------------
//
//  Overridden properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		override public function get value():Number
		{
			var value:Number = super.value;

			if (_tweening)
			{
				// 次の値を計算
				value = _easing(_t++, _b, _c, _d);
				if (_t == _d)
				{
					setValue_internal(_targetValue);
					_tweening = false;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}

			return value;
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

		override public function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			value = applyLimitter(value);

			if (!_tweening && value == this.value)
			{
				// 値は変わらないので、何もしない
				dispatchEvent(new Event(Event.CHANGE));
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				if (easingTimeByMS <= 0)
				{
					// 即時
					setValue_internal(value);
					valueChanged();
					dispatchEvent(new Event(Event.CHANGE));
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					_b = this.value;
					_c = value - this.value;
					_t = 0;
					_d = Math.floor(easingTimeByMS * 44.1);
					_easing = easing || Ease24._Linear;
					_targetValue = value;
					_tweening = true;
				}
			}
		}

//--------------------------------------------------------------------------
//
//  Service methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Overridden Event handlers
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Event handlers
//
//--------------------------------------------------------------------------

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
