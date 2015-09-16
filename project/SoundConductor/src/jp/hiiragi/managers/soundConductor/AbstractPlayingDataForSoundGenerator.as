package jp.hiiragi.managers.soundConductor
{
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

	internal class AbstractPlayingDataForSoundGenerator extends AbstractPlayingData
	{

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

				_startByteIndex = _currentByteIndex = playInfo.startTimeByMS * 352.8; // 352.8 = 44.1 * 8
				_loopStartByteIndex = playInfo.loopStartTimeByMS * 352.8;
				_loopEndByteIndex = (playInfo.loopEndTimeByMS == 0) ? _soundByteArray.length : playInfo.loopEndTimeByMS * 352.8;

				totalLength = Math.floor(_soundByteArray.length / 352.8);
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

			var remainLength:uint;
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
				}
			}
			else
			{
				remainLength = _loopEndByteIndex - _currentByteIndex;
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
					_currentByteIndex = _loopStartByteIndex + (lengthFromStartPoint);
					incrementCurrentLoopCount();
				}
			}

			// ポジションを最初に戻す
			byteArray.position = 0;

			currentPosition = Math.floor(_currentByteIndex / 352.8); // 352.8 = 44100 * 8 / 1000
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
