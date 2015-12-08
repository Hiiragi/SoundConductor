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
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;
	import jp.hiiragi.managers.soundConductor.events.SoundConductorEvent;

	internal class AbstractPlayingDataForSoundGenerator extends AbstractPlayingData
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------
		/**
		 * ミリ秒からバイト数に変換する係数です (44.1 * 8 = 352.8).<p>
		 */
		private static const COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE:Number = 44.1 * 8;

		private static const BIT_MASK:int = int.MAX_VALUE - 7;

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function AbstractPlayingDataForSoundGenerator(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, groupController:SoundGroupController)
		{
			if (this["constructor"] != AbstractPlayingDataForSoundGenerator)
			{
				super(playInfo, registeredSoundData, groupController);

				_soundByteArray = registeredSoundData.soundByteArray;

				_startByteIndex = _currentByteIndex = playInfo.startTimeByMS * COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE;
				_loopStartByteIndex = playInfo.loopStartTimeByMS * COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE;
				_loopEndByteIndex = (playInfo.loopEndTimeByMS == 0) ? _soundByteArray.length : playInfo.loopEndTimeByMS * COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE;

				_startByteIndex &= BIT_MASK;
				_loopStartByteIndex &= BIT_MASK;
				_loopEndByteIndex &= BIT_MASK;

				totalLength = Math.floor(_soundByteArray.length / COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE);
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
		private var _soundByteArray:ByteArray;

		private var _startByteIndex:uint;
		private var _currentByteIndex:uint;
		private var _loopStartByteIndex:uint;
		private var _loopEndByteIndex:uint;

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
		//  propertyName
		//----------------------------------


//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------
		override protected function resume_internal(fadeInTimeByMS:Number, fadeInEasing:Function):void
		{
			volumeController.setValue(pausedVolume, fadeInTimeByMS, fadeInEasing);
		}

		override protected function seek_internal(timeByMS:Number):void
		{
			_currentByteIndex = timeByMS * COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE;
			setCurrentPosition();
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

		public function getSoundByteArrayForSoundGenerator(length:int):ByteArray
		{
			var byteArray:ByteArray = new ByteArray();

			// mute 状態だった場合、無音の ByteArray を書き込む。但し、時間経過などはして欲しいので、その辺の処理は続けて行う。
			if (isMute)
			{
				byteArray.writeBytes(SoundUtil.getSilentByteArray(length), 0, length);
			}

			var remainLength:Number;
			if (loops == SoundLoopType.NO_LOOP || (loops != SoundLoopType.INFINITE_LOOP && loops == currentLoopCount))
			{
				remainLength = _soundByteArray.length - _currentByteIndex;

				// 最後まで
				if (remainLength > length)
				{
					// 残りがある
					writeSoundBytes(byteArray, _soundByteArray, _currentByteIndex, length);
					_currentByteIndex += length;
				}
				else
				{
					// 残りがない（最終切り出し）
					writeSoundBytes(byteArray, _soundByteArray, _currentByteIndex, remainLength);
					_currentByteIndex = _soundByteArray.length;
				}
			}
			else
			{
				remainLength = _loopEndByteIndex - _currentByteIndex;
				if (remainLength < 0)
					remainLength = 0;

				// ループ地点を超えるか
				if (remainLength > length)
				{
					// 超えない
					writeSoundBytes(byteArray, _soundByteArray, _currentByteIndex, length);
					_currentByteIndex += length;
				}
				else
				{
					// 超える
					var lengthFromStartPoint:uint = length - remainLength;
					writeSoundBytes(byteArray, _soundByteArray, _currentByteIndex, remainLength);
					writeSoundBytes(byteArray, _soundByteArray, _loopStartByteIndex, lengthFromStartPoint);
					_currentByteIndex = _loopStartByteIndex + lengthFromStartPoint;
					incrementCurrentLoopCount();
					dispatchEvent(new SoundConductorEvent(SoundConductorEvent.LOOP, soundContoller));
				}
			}

			// ポジションを最初に戻す
			byteArray.position = 0;
			setCurrentPosition();
//			trace(_currentByteIndex + " / " + _soundByteArray.length);
			byteArray = writeSoundByteArrayFinished(byteArray);

			return byteArray;
		}



//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------
		protected function writeSoundByteArrayFinished(byteArray:ByteArray):ByteArray
		{
			return byteArray;
		}

//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------
		private function writeSoundBytes(target:ByteArray, source:ByteArray, offset:uint, length:uint):void
		{
			if (!isMute)
			{
				target.writeBytes(source, offset, length);
			}
		}

		private function setCurrentPosition():void
		{
			currentPosition = Math.floor(_currentByteIndex / COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE);
		}

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
