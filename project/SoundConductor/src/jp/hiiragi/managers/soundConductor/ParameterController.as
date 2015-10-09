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
	import flash.display.Shape;
	import flash.events.Event;

	import a24.tween.Ease24;

	internal class ParameterController extends AbstractParameterController
	{

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function ParameterController(initValue:Number, minValue:Number = 0, maxValue:Number = 1)
		{
			super(initValue, minValue, maxValue);
			_ticker = new Shape();
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  tween
		//----------------------------------
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;

		private var _startTime:Number;

		private var _tweening:Boolean;

		private var _easing:Function;

		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _ticker:Shape;

		private var _targetValue:Number;


//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

		override public function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			value = applyLimitter(value);

			var currentValue:Number = getValue_internal();

			if (!_tweening && value == currentValue)
			{
				// 値は変わらないので、何もしない
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
					_startTime = new Date().time;
					var endTime:Number = _startTime + easingTimeByMS;
					_b = this.value;
					_c = value - this.value;
					_d = endTime - _startTime;
					_easing = easing || Ease24._Linear;
					_targetValue = value;
					_tweening = true;

					// トゥイーンで段階的に変化
					// トゥイーン中に値が変更される事を考慮して、ENTER_FRAME の登録を重複させない
					if (!_ticker.hasEventListener(Event.ENTER_FRAME))
					{
						_ticker.addEventListener(Event.ENTER_FRAME, update);
					}
				}
			}
		}


		override public function dispose():void
		{
			super.dispose();
			_ticker.removeEventListener(Event.ENTER_FRAME, update);
		}

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
		private function update(event:Event):void
		{
			var t:Number = new Date().time - _startTime;

			if (t < _d)
			{
				// トゥイーン続行
				setValue_internal(_easing(t, _b, _c, _d));
				dispatchEvent(new Event(Event.CHANGE));
			}
			else
			{
				// トゥイーン終了
				setValue_internal(_targetValue);

				_ticker.removeEventListener(Event.ENTER_FRAME, update);
				_tweening = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}

			valueChanged();
		}
	}
}
