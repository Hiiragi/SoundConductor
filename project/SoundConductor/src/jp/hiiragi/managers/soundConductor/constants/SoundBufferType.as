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

package jp.hiiragi.managers.soundConductor.constants
{
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

	/**
	 * <code>SoundBufferType</code> クラスは、SoundGenerator 機能で扱うバッファ値に関する定数値の列挙です.
	 */
	public class SoundBufferType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** サウンドのバッファ <code>8192</code> を示します。*/
		public static const BUFFER_SIZE_8192:SoundBufferType = create(8192);
		/** サウンドのバッファ <code>4096</code> を示します。*/
		public static const BUFFER_SIZE_4096:SoundBufferType = create(4096);
		/** サウンドのバッファ <code>2048</code> を示します。*/
		public static const BUFFER_SIZE_2048:SoundBufferType = create(2048);

//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		private static var _isCalledFromInternal:Boolean = false;

//--------------------------------------------------------------------------
//
//  Class Public methods
//
//--------------------------------------------------------------------------
		/**
		 * 内部で定数を列挙する際のファクトリーメソッドです。
		 * @param value Enum値です。
		 * @return
		 * @private
		 */
		protected static function create(value:* = null):SoundBufferType
		{
			_isCalledFromInternal = true;
			var instance:SoundBufferType = new SoundBufferType(value);

			return instance;
		}

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		/**
		 * コンストラクタです。外部からはインスタンス化できません。
		 * @param value Enum値です。
		 * @private
		 */
		public function SoundBufferType(value:* = null)
		{
			if (_isCalledFromInternal)
			{
				_value = value || "";
				_isCalledFromInternal = false;
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10002);
			}
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		private var _value:*;

		/**
		 * サウンドのバッファの値を取得します。
		 * @return
		 */
		public function get value():*  { return _value; }

//--------------------------------------------------------------------------
//
//   Public methods
//
//--------------------------------------------------------------------------
		public function toString():String
		{
			return "[SoundBufferType value=" + _value.toString() + "]";
		}
	}
}
