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
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.constants.SoundStatusType;
	import jp.hiiragi.managers.soundConductor.events.SoundConductorEvent;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	internal class PlayingDataForNormalSound extends AbstractPlayingData
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
		public function PlayingDataForNormalSound(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, groupController:SoundGroupController)
		{
			super(playInfo, registeredSoundData, groupController);

			_sound = registeredSoundData.sound;
			totalLength = _sound.length;
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _sound:Sound;

		private var _soundChannel:SoundChannel;

		private var _pausedPosition:int;

		private var _currentLoopCount:int;

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


		override protected function play_internal():void
		{
			executePlaySoundProcess(startTimeByMS, initVolume, initPan);
		}

		override protected function seek_internal(timeByMS:Number):void
		{
			_soundChannel.stop();
			executePlaySoundProcess(timeByMS);
		}

		override protected function resume_internal(fadeInTimeByMS:Number, fadeInEasing:Function):void
		{
			if (status == SoundStatusType.PAUSED)
			{
				executePlaySoundProcess(_pausedPosition, pausedVolume, pausedPan, fadeInTimeByMS, fadeInEasing);
			}
			else if (status == SoundStatusType.PAUSING)
			{
				volumeController.setValue(pausedVolume, fadeInTimeByMS, fadeInEasing);
			}
		}

		override protected function pauseCompleted():void
		{
			_pausedPosition = _soundChannel.position;
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			_soundChannel.stop();
		}

		override public function getCurrentPosition():Number
		{
			return _soundChannel.position;
		}

		override public function dispose():void
		{
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			_soundChannel.stop();

			super.dispose();
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

		private function executePlaySoundProcess(startPosition:int, volume:Number = 1, pan:Number = 0
												 , fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			// まずは最大音量で鳴らす（Sound.play() で初回に設定された音量が内部的に 1 となる仕様らしいため）
			_soundChannel = _sound.play(startPosition, 0, new SoundTransform(1, pan));
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);

			var initVolume:Number = volume;
			if (fadeInTimeByMS > 0)
			{
				initVolume = 0;
			}

			// コントローラ設定
			var groupVolumeController:ParameterController;
			if (soundGroupController != null)
			{
				groupVolumeController = soundGroupController.groupVolumeController;
			}

			setSoundChannel(_soundChannel);

			if (volumeController != null)
			{
				SoundParameterController(volumeController).replaceSoundChannel(_soundChannel);
				SoundParameterController(panController).replaceSoundChannel(_soundChannel);
			}
			else
			{
				setVolumeController(new SoundParameterController(SoundParameterType.VOLUME, _soundChannel, masterVolumeController, groupVolumeController));
				setPanController(new SoundParameterController(SoundParameterType.PAN, _soundChannel));
			}

			if (initVolume == 1)
			{
				// 音は最大音量のままなので、マスターボリュームとグループボリュームを適用させるのみにする
				SoundParameterController(volumeController).validateNow();
			}
			else
			{
				// 音の変更があるので、通常通りセットする
				volumeController.setValue(volume, fadeInTimeByMS, fadeInEasing);
			}

			var enabled:Boolean = validateEnabled();

			if (enabled)
			{
				volumeController.setEnabled(true);
			}
			else
			{
				volumeController.setEnabled(false);
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

		protected function onSoundCompleteHandler(event:Event):void
		{
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);

			var currentVolume:Number = volumeController.value;
			var currentPan:Number = panController.value;

			if (volumeController != null)
				volumeController.dispose();
			if (panController != null)
				panController.dispose();

			if (loops == SoundLoopType.NO_LOOP || (loops != SoundLoopType.INFINITE_LOOP && currentLoopCount >= loops))
			{
				// 終了
				dispose();
			}
			else if (loops == SoundLoopType.INFINITE_LOOP || currentLoopCount < loops)
			{
				incrementCurrentLoopCount();
				dispatchEvent(new SoundConductorEvent(SoundConductorEvent.LOOP, soundContoller));

				// 再度再生
				executePlaySoundProcess(startTimeByMS, currentVolume, currentPan);
			}
		}

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
