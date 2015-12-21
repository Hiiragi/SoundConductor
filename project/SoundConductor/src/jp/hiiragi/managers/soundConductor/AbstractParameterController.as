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
	import flash.events.EventDispatcher;

	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

//--------------------------------------
//  Events
//--------------------------------------
	[Event(name = "change", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	/**
	 * パラメータ用コントローラの抽象基本クラスです.
	 */
	internal class AbstractParameterController extends EventDispatcher implements IParameterController
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Class properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Class Service methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Public methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Protected methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Private methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです。
		 * @param initValue	パラメータの初期値を指定します。
		 * @param minValue	パラメータの最小値を指定します。
		 * @param maxValue	パラメータの最大値を指定します。
		 */
		public function AbstractParameterController(initValue:Number, minValue:Number = 0, maxValue:Number = 1)
		{
			if (this["constructor"] != AbstractParameterController)
			{
				_minValue = minValue;
				_maxValue = maxValue;
				_value = initValue;

				_enabled = true;
				_value = applyLimitter(_value);
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10000);
			}
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Overridden properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		private var _value:Number = 0;

		/**
		 * パラメータの値を取得します.
		 * @return
		 */
		public function get value():Number
		{
			if (!_enabled)
			{
				return 0;
			}

			return _value;
		}

		//----------------------------------
		//  minValue
		//----------------------------------
		private var _minValue:Number;

		/**
		 * コンストラクタにより設定されたパラメータの最小値を取得します.
		 * @return
		 */
		public function get minValue():Number  { return _minValue; }

		//----------------------------------
		//  maxValue
		//----------------------------------
		private var _maxValue:Number;

		/**
		 * コンストラクタにより設定されたパラメータの最大値を取得します.
		 * @return
		 */
		public function get maxValue():Number  { return _maxValue; }

		//----------------------------------
		//  enabled
		//----------------------------------
		private var _enabled:Boolean;

		/**
		 * コントローラが有効であるかどうかを取得します.
		 * @return
		 */
		public function get enabled():Boolean  { return _enabled; }

//--------------------------------------------------------------------------
//
//  Namespace methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

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

		/**
		 * コントローラが有効かどうかを設定します.
		 * @param enabled
		 */
		public function setEnabled(enabled:Boolean):void
		{
			if (_enabled == enabled)
			{
				return;
			}

			_enabled = enabled;
			valueChanged();
		}

		/**
		 * コントローラの値を設定します.
		 * @param value
		 * @param easingTimeByMS
		 * @param easing
		 */
		public function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			throw new SoundConductorError(SoundConductorErrorType.ERROR_10020);
		}

		public function getInternalValue():Number
		{
			return _value;
		}

		/**
		 * オブジェクトを破棄します.
		 */
		public function dispose():void
		{
		}

//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタにより設定された上限・下限を適用します.
		 * @param value
		 * @return
		 */
		protected function applyLimitter(value:Number):Number
		{
			if (value < _minValue)
				value = _minValue;
			else if (value > _maxValue)
				value = _maxValue;

			return value;
		}

		/**
		 * 値が変更されたときの呼び出されるメソッドです.
		 */
		protected function valueChanged():void
		{
		}

		protected final function getValue_internal():Number
		{
			return _value;
		}

		protected final function setValue_internal(value:Number):void
		{
			_value = value;
		}

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
