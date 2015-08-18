package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.constants.SoundStatusType;

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
			executePlaySoundProcess(startTime, initVolume, initPan);
		}

		override protected function seek_internal(timeByMS:Number):void
		{

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

		/*
		private var _volumeBeforeMute:Number;

		override public function mute():void
		{
			if (isMute)
				return;

			super.mute();

			_volumeBeforeMute = volumeController.value;
			volumeController.setEnabled(false);
		}

		override public function unmute():void
		{
			if (!isMute)
				return;

			super.unmute();

			volumeController.setEnabled(true);
		}
		*/

		override public function dispose():void
		{
			super.dispose();
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			_soundChannel.stop();
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

		private function executePlaySoundProcess(startPosition:int, volume:Number, pan:Number, fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			// まずは最大音量で鳴らす（Sound.play() で初回に設定された音量が内部的に 1 となる仕様らしいため）
			_soundChannel = _sound.play(startPosition, 0, new SoundTransform(1, pan));
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);

			// コントローラ設定
			var groupVolumeController:ParameterController;
			if (soundGroupController != null)
			{
				groupVolumeController = soundGroupController.groupVolumeController;
			}

			setSoundChannel(_soundChannel);
			setVolumeController(new SoundParameterController(SoundParameterType.VOLUME, _soundChannel, masterVolumeController, groupVolumeController));
			setPanController(new SoundParameterController(SoundParameterType.PAN, _soundChannel));

			var enabled:Boolean = validateEnabled();

			if (enabled)
			{
				volumeController.setEnabled(true);
			}
			else
			{
				volumeController.setEnabled(false);
			}
		/*
		// ボリュームの計算を行い、適用する
		var calcuratedVolume:Number = (fadeInTimeByMS > 0) ? 0 : volume;
		if (groupVolumeController != null)
		{
			calcuratedVolume *= groupVolumeController.value;
		}

		calcuratedVolume *= masterVolumeController.value;

		_soundChannel.soundTransform = new SoundTransform(calcuratedVolume, pan);

		// フェードインを行う場合は、その処理を行う
		if (fadeInTimeByMS > 0)
		{
			volumeController.setValue(calcuratedVolume, fadeInTimeByMS, fadeInEasing);
		}
		*/
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
			}
			else if (loops == SoundLoopType.INFINITE_LOOP || currentLoopCount < loops)
			{
				incrementCurrentLoopCount();

				// 再度再生
				executePlaySoundProcess(startTime, currentVolume, currentPan);
			}
		}

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
