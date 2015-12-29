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
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.constants.SoundBufferType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

	internal class SoundUtil
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** ミリ秒からバイト数に変換する係数です (44.1 * 8 = 352.8). */
		public static const COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE:Number = 44.1 * 8;

		/** 8 ビットより下のビットを切るためのマスクです. */
		public static const BIT_MASK:int = int.MAX_VALUE - 7;

		/** 無音の <code>ByteArray</code> です. */
		private static const SILENT_BYTE_ARRAY:ByteArray = new ByteArray();

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

		/**
		 * 現在サウンドが再生可能かをチェックします.
		 * @return
		 */
		public static function checkPlayable():Boolean
		{
			var sound:Sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
			var sc:SoundChannel = sound.play();

			if (sc != null)
			{
				sc.stop();
				return true;
			}

			return false;

			function onSampleDataHandler(event:SampleDataEvent):void
			{
				return;
			}
		}

		/**
		 * バイナリが Ogg フォーマットかどうかをチェックします.
		 * @param byteArray
		 * @return
		 */
		public static function checkOggFormat(byteArray:ByteArray):Boolean
		{
			var currentPosition:int = byteArray.position;

			byteArray.position = 0;
			var fourByteText:String = byteArray.readUTFBytes(4);

			byteArray.position = currentPosition;

			return fourByteText == "OggS";
		}

		/**
		 * 指定の長さで生成された無音の <code>ByteArray</code> を取得します.
		 * @param length
		 * @return
		 */
		public static function getSilentByteArray(length:int):ByteArray
		{
			if (SILENT_BYTE_ARRAY.length == 0)
			{
				var len:int = int(SoundBufferType.BUFFER_SIZE_8192.value);
				for (var i:int = 0; i < len; i++)
				{
					SILENT_BYTE_ARRAY.writeFloat(0);
					SILENT_BYTE_ARRAY.writeFloat(0);
				}
			}

			var byteArray:ByteArray = new ByteArray();
			byteArray.writeBytes(SILENT_BYTE_ARRAY, 0, length);

			return byteArray;
		}

		/**
		 * Ogg Vorbis の音の長さをミリ秒で取得します
		 * @param oggByteArray
		 * @param sampligRate
		 * @return
		 */
		public static function calcurateOggLength(oggByteArray:ByteArray, sampligRate:uint = 44100):Number
		{
			var currentCount:uint = oggByteArray.length - 14;
			while (currentCount >= 0)
			{
				if (oggByteArray[currentCount] == 0x4F && oggByteArray[currentCount + 1] == 0x67
					&& oggByteArray[currentCount + 2] == 0x67 && oggByteArray[currentCount + 3] == 0x53)
				{
					var typeFlag:uint = oggByteArray[currentCount + 5];
					if (typeFlag & 4)
					{
						var pos:int = oggByteArray.position;
						var lengthBits:String = fillZero(oggByteArray[currentCount + 9]) + fillZero(oggByteArray[currentCount + 8]) + fillZero(oggByteArray[currentCount + 7]) + fillZero(oggByteArray[currentCount + 6]);
						var length:uint = parseInt(lengthBits, 2) / sampligRate * 1000;
						return length;
					}
				}

				currentCount--;
			}

			return NaN;

			function fillZero(num:uint):String
			{
				var numText:String = num.toString(2);
				for (var i:int = 0; i < 8; i++)
				{
					numText = "0" + numText;
				}

				return numText.substr(-8, 8);
			}
		}

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

		public function SoundUtil()
		{
			throw new SoundConductorError(SoundConductorErrorType.ERROR_10001);
		}

	}
}

