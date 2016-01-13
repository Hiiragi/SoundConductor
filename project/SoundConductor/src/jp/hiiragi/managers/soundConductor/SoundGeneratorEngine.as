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
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import jp.hiiragi.managers.soundConductor.constants.SoundStatusType;


	internal class SoundGeneratorEngine
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function SoundGeneratorEngine()
		{
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataEvent);
			_soundChannel = _sound.play();
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _sound:Sound = new Sound();

		private var _soundList:Vector.<AbstractPlayingDataForSoundGenerator> = new Vector.<AbstractPlayingDataForSoundGenerator>();

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
		//  soundChannel
		//----------------------------------
		private var _soundChannel:SoundChannel;

		internal function get soundChannel():SoundChannel
		{
			return _soundChannel;
		}

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
		public function addPlayingData(playingData:AbstractPlayingDataForSoundGenerator):void
		{
			_soundList.push(playingData);
		}


		public function dispose():void
		{
			// onSampleDataEvent との兼ね合いからか、1 フレーム以上待たないと FlashPlayer がクラッシュする
			var timer:Timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
			timer.start();

			function onTimerCompleteHandler(event:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);

				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataEvent);
				_soundChannel.stop();
				_soundList.length = 0;
			}
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
		private function removePlayingData(playingData:AbstractPlayingDataForSoundGenerator):void
		{
			var index:int = _soundList.indexOf(playingData);
			if (index > -1)
			{
				_soundList.splice(index, 1);
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

		private function onSampleDataEvent(event:SampleDataEvent):void
		{
			var i:int = 0;
			var playingData:AbstractPlayingDataForSoundGenerator;
			var soundListLength:int = _soundList.length;
			var bufferSize:int = int(SoundConductor.soundBufferSize.value);
			var bufferByteSize:int = bufferSize * 8;

			var bufferByteArrayList:Vector.<ByteArray>;

			if (soundListLength == 0)
			{
				event.data.writeBytes(SoundUtil.getSilentByteArray(bufferByteSize));
				return;
			}
			else
			{
				bufferByteArrayList = new Vector.<ByteArray>();
				for (i = soundListLength - 1; i >= 0; i--)
				{
					playingData = _soundList[i];
					var bufferByteArray:ByteArray;

					if (playingData.status == SoundStatusType.PAUSED)
					{
						// 何もしない
					}
					else
					{
						bufferByteArray = playingData.getSoundByteArrayForSoundGenerator(bufferByteSize);

						bufferByteArray.position = 0;
						if (bufferByteArray.length > 0)
						{
							bufferByteArrayList.push(bufferByteArray);
						}
						else if (bufferByteArray.length == 0 || playingData.status == SoundStatusType.STOPPED)
						{
							removePlayingData(playingData);
						}
					}
				}
			}

			var bufferListLength:int = bufferByteArrayList.length;
			if (bufferListLength == 0)
			{
				event.data.writeBytes(SoundUtil.getSilentByteArray(bufferByteSize));
				return;
			}
			else
			{
				var leftValue:Number;
				var rightValue:Number;
				for (i = 0; i < bufferSize; i++)
				{
					leftValue = 0;
					rightValue = 0;
					for (var j:int = 0; j < bufferListLength; j++)
					{
						bufferByteArray = bufferByteArrayList[j];
						if (bufferByteArray.bytesAvailable)
						{
							leftValue += bufferByteArray.readFloat();
							rightValue += bufferByteArray.readFloat();
						}
					}

					event.data.writeFloat(leftValue);
					event.data.writeFloat(rightValue);
				}
			}

		}
	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
