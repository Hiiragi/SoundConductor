package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;

	import jp.hiiragi.managers.soundConductor.constants.SoundPlayType;
	import jp.hiiragi.managers.soundConductor.constants.SoundStatusType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;
	import jp.hiiragi.managers.soundConductor.events.SoundConductorEvent;

//--------------------------------------
//  Events
//--------------------------------------
	[Event(name = "play", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "pausing", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "paused", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "stopping", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "stopped", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "mute", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]
	[Event(name = "unmute", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	internal class AbstractPlayingData extends EventDispatcher implements ISoundController
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
		public function AbstractPlayingData(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, soundGroupController:SoundGroupController)
		{
			if (this["constructor"] != AbstractPlayingData)
			{
				_soundId = playInfo.soundId;
				_startTime = playInfo.startTimeByMS;
				_loops = playInfo.loops;
				_loopStartTime = playInfo.loopStartTimeByMS;
				_loopEndTime = playInfo.loopEndTimeByMS;
				_soundPlayType = playInfo.soundPlayType;
				_weakReference = playInfo.weakReference;

				_allowMultiple = registeredSoundData.allowMultiple;
				_allowInterrupt = registeredSoundData.allowInterrupt;

				_soundGroupController = soundGroupController;


				_status = SoundStatusType.READY;
				_masterVolumeController = SoundConductor.masterVolumeController;

				_initVolume = playInfo.volume;
				_initPan = playInfo.pan;
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
		//  propertyName
		//----------------------------------
		private var _soundContoller:SoundController;

		public function get soundContoller():SoundController
		{
			return _soundContoller;
		}

		public function set soundContoller(value:SoundController):void
		{
			_soundContoller = value;
		}


		private var _soundId:SoundId;

		public function get soundId():SoundId
		{
			return _soundId;
		}


		private var _startTime:Number;

		public function get startTime():Number
		{
			return _startTime;
		}


		private var _loops:int;

		public function get loops():int
		{
			return _loops;
		}

		private var _currentLoopCount:int;

		public function get currentLoopCount():int
		{
			return _currentLoopCount;
		}

		private var _loopStartTime:Number;

		public function get loopStartTime():Number
		{
			return _loopStartTime;
		}


		private var _loopEndTime:Number;

		public function get loopEndTime():Number
		{
			return _loopEndTime;
		}


		private var _soundPlayType:SoundPlayType;

		public function get soundPlayType():SoundPlayType
		{
			return _soundPlayType;
		}


		private var _weakReference:Boolean;

		public function get weakReference():Boolean
		{
			return _weakReference;
		}


		private var _status:SoundStatusType;

		public function get status():SoundStatusType
		{
			return _status;
		}

		private var _volumeController:IParameterController;

		public function get volumeController():IParameterController
		{
			return _volumeController;
		}



		private var _panController:IParameterController;

		public function get panController():IParameterController
		{
			return _panController;
		}



		private var _masterVolumeController:ParameterController;

		public function get masterVolumeController():ParameterController
		{
			return _masterVolumeController;
		}


		private var _soundGroupController:SoundGroupController;

		public function get soundGroupController():SoundGroupController
		{
			return _soundGroupController;
		}


		private var _soundChannel:SoundChannel;

		public function get soundChannel():SoundChannel
		{
			return _soundChannel;
		}


		private var _allowMultiple:Boolean;

		public function get allowMultiple():Boolean
		{
			return _allowMultiple;
		}

		private var _allowInterrupt:Boolean;

		public function get allowInterrupt():Boolean
		{
			return _allowInterrupt;
		}

		private var _initVolume:Number;

		public function get initVolume():Number
		{
			return _initVolume;
		}

		private var _initPan:Number;

		public function get initPan():Number
		{
			return _initPan;
		}


		private var _pausedVolume:Number;

		protected function get pausedVolume():Number
		{
			return _pausedVolume;
		}

		private var _pausedPan:Number;

		protected function get pausedPan():Number
		{
			return _pausedPan;
		}

		private var _isMute:Boolean;

		protected function get isMute():Boolean
		{
			return _isMute;
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

		public final function getPan():Number
		{
			return _panController.value;
		}

		public final function setPan(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			if (_status == SoundStatusType.PLAYING)
			{
				_panController.setValue(value, easingTimeByMS, easing);
			}
		}

		public final function getVolume():Number
		{
			return _volumeController.value;
		}

		public final function setVolume(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			if (_status == SoundStatusType.PLAYING)
			{
				_volumeController.setValue(value, easingTimeByMS, easing);
			}
		}

		public final function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			if (_status == SoundStatusType.PLAYING)
			{
				_pausedVolume = _volumeController.value;
				_volumeController.addEventListener(Event.COMPLETE, onPauseCompleteHandler);
				_volumeController.setValue(0, fadeOutTimeByMS, fadeOutEasing);

				_status = SoundStatusType.PAUSING;
				dispatchEvent(new SoundConductorEvent(SoundConductorEvent.PAUSING, _soundContoller));
			}
		}

		public final function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			if (_status == SoundStatusType.PAUSED || _status == SoundStatusType.PAUSING)
			{
				_volumeController.removeEventListener(Event.COMPLETE, onPauseCompleteHandler); // pause の tween 中の可能性があるため、removeEventListener をかけておく。
				resume_internal(fadeInTimeByMS, fadeInEasing);

				_status = SoundStatusType.PLAYING;
				dispatchEvent(new SoundConductorEvent(SoundConductorEvent.PLAYING, _soundContoller));
			}
		}

		public final function seek(timeByMS:Number):void
		{
			if (status == SoundStatusType.PLAYING)
			{
				seek_internal(timeByMS);
			}
		}

		public final function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			if (_status == SoundStatusType.PAUSED || _status == SoundStatusType.PAUSING || _status == SoundStatusType.PLAYING)
			{
				if (_status == SoundStatusType.PAUSED)
				{
					dispose();
				}
				else
				{
					_volumeController.addEventListener(Event.COMPLETE, onStopCompleteHandler);
					_volumeController.setValue(0, fadeOutTimeByMS, fadeOutEasing);

					_status = SoundStatusType.STOPPING;
					dispatchEvent(new SoundConductorEvent(SoundConductorEvent.STOPPING, _soundContoller));
				}
			}
		}

		public final function mute():void
		{
			if (_isMute)
				return;

			_isMute = true;

			// mute の場合は、masterVolume または groupVolume の状況に関係なくミュートするため、そのままミュートする。
			// unmute は上記のボリュームを鑑みる必要がある。
			_volumeController.setEnabled(false);

			dispatchEvent(new SoundConductorEvent(SoundConductorEvent.MUTE, _soundContoller));
		}

		public final function unmute():void
		{
			if (!_isMute)
				return;

			_isMute = false;

			// unmute の場合、マスターと、（グループがある場合は）グループが非ミュート状態だった場合に再生させる。
			// それ以外では再生はさせない。
			var unmutable:Boolean = validateUnmutable();

			if (unmutable)
			{
				_volumeController.setEnabled(true);
			}

			// 上記で、再生されたにしても再生されなかったにしても、ミュート状態は変更されているので、イベントを発効する。
			dispatchEvent(new SoundConductorEvent(SoundConductorEvent.UNMUTE, _soundContoller));
		}

		public function dispose():void
		{
			_volumeController.dispose();
			_panController.dispose();

			_status = SoundStatusType.STOPPED;
			dispatchEvent(new SoundConductorEvent(SoundConductorEvent.STOPPED, _soundContoller));
		}

//--------------------------------------------------------------------------
//
//  Internal methods
//
//--------------------------------------------------------------------------
		internal final function play():void
		{
			if (status == SoundStatusType.READY)
			{
				play_internal();
				_status = SoundStatusType.PLAYING;
				dispatchEvent(new SoundConductorEvent(SoundConductorEvent.PLAYING, _soundContoller));
			}
		}

		internal final function incrementCurrentLoopCount():void
		{
			_currentLoopCount++;
		}

		/**
		 * 上位のコントローラがミュート状態になったときに実行されます.
		 */
		internal final function muteAtParent():void
		{
			// ミュート状態は変えず、音だけミュート状態にする
			_volumeController.setEnabled(false);
		}

		/**
		 * 上位のコントローラが非ミュート状態になったときに実行されます.
		 */
		internal final function unmuteAtParent():void
		{
			var unmutable:Boolean = validateUnmutable();

			if (unmutable)
			{
				_volumeController.setEnabled(true);
			}
		}

//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------

		/**
		 * マスターボリュームとグループボリュームの状況を見て、現在音が出せる状況であるかを取得します。
		 * @return
		 */
		protected final function validateEnabled():Boolean
		{
			var enabled:Boolean = _masterVolumeController.enabled;
			if (enabled && _soundGroupController != null)
			{
				enabled = _soundGroupController.groupVolumeController.enabled;
			}

			return enabled;
		}


		protected final function setSoundChannel(soundChannel:SoundChannel):void
		{
			_soundChannel = soundChannel;
		}

		protected final function setVolumeController(volumeController:IParameterController):void
		{
			_volumeController = volumeController;
		}

		protected final function setPanController(panController:IParameterController):void
		{
			_panController = panController;
		}


		protected function play_internal():void
		{

		}

		protected function seek_internal(timeByMS:Number):void
		{

		}

		protected function resume_internal(fadeInTimeByMS:Number, fadeInEasing:Function):void
		{

		}

		protected function pauseCompleted():void
		{

		}



//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------

		private function validateUnmutable():Boolean
		{
			// マスターのミュート状態と、（グループに所属している場合は）グループのミュート状態を見て、音を出せる状態であれば出す

			var unmutable:Boolean = !SoundConductor.isMute;
			if (_soundGroupController != null)
			{
				unmutable = !_soundGroupController.isMute;
			}

			return unmutable;
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

		private function onPauseCompleteHandler(event:Event):void
		{
			_pausedPan = panController.value;
			_volumeController.removeEventListener(Event.COMPLETE, onPauseCompleteHandler);
			_status = SoundStatusType.PAUSED;
			pauseCompleted();
			dispatchEvent(new SoundConductorEvent(SoundConductorEvent.PAUSED, _soundContoller));
		}

		private function onStopCompleteHandler(event:Event):void
		{
			volumeController.removeEventListener(Event.COMPLETE, onStopCompleteHandler);
			dispose();
		}
	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////