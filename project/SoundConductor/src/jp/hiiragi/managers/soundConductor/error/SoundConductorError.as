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

package jp.hiiragi.managers.soundConductor.error
{

	public class SoundConductorError extends Error
	{

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param errorType		エラーの種類を表す <code>SoundConductorErrorType</code> の定数値です。
		 * @param args				メッセージ内に変数があって値を入れる必要がある場合、以降に指定された順番で置換されます。
		 */
		public function SoundConductorError(errorType:SoundConductorErrorType, ... args)
		{
			name = "SoundConductorError";

			var errorMessage:String = "[SoundConductorError #" + errorType.id + " : " + errorType.message + "]";
			var len:int = args.length;
			for (var i:int = 0; i < len; i++)
			{
				var replaceText:String = (args[i] != null) ? args[i].toString() : "null";
				errorMessage = errorMessage.replace(/%%/, replaceText);
			}

			super(errorMessage, errorType.id);
		}

	}
}
