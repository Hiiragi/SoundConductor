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
	[Event(name = "loop", type = "jp.hiiragi.managers.soundConductor.events.SoundConductorEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	/**
	 * 再生中の情報を持つデータの抽象基本クラスです.
	 */
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

		/**
		 * コンストラクタです.
		 * @param playInfo	再生したいデータの内容を保持する <code>SoundPlayInfo</code> オブジェクトを指定します。
		 * @param registeredSoundData	再生する登録済みデータを指定します。
		 * @param soundGroupController	グループに所属する場合のグループ用コントローラを指定します。
		 */
		public function AbstractPlayingData(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, soundGroupController:SoundGroupController)
		{
			if (this["constructor"] != AbstractPlayingData)
			{
				_playInfo = playInfo;
				_registeredSoundData = registeredSoundData;
				_soundGroupController = soundGroupController;

				_soundId = playInfo.soundId;
				_startTimeByMS = playInfo.startTimeByMS;
				_loops = playInfo.loops;
				_loopStartTimeByMS = playInfo.loopStartTimeByMS;
				_loopEndTimeByMS = playInfo.loopEndTimeByMS;
				_soundPlayType = playInfo.soundPlayType;
				_weakReference = playInfo.weakReference;

				_allowMultiple = registeredSoundData.allowMultiple;
				_allowInterrupt = registeredSoundData.allowInterrupt;

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
		//  playInfo
		//----------------------------------
		private var _playInfo:SoundPlayInfo;

		protected function get playInfo():SoundPlayInfo  { return _playInfo; }

		//----------------------------------
		//  registeredSoundData
		//----------------------------------
		private var _registeredSoundData:RegisteredSoundData;

		protected function get registeredSoundData():RegisteredSoundData  { return _registeredSoundData; }

		//----------------------------------
		//  soundContoller
		//----------------------------------
		private var _soundContoller:SoundController;

		/**
		 * 再生データに紐づく <code>SoundController</code> オブジェクトを取得・設定します.
		 * @return
		 */
		public function get soundContoller():SoundController  { return _soundContoller; }

		public function set soundContoller(value:SoundController):void  { _soundContoller = value; }

		//----------------------------------
		//  soundId
		//----------------------------------
		private var _soundId:SoundId;

		/**
		 * 再生中のデータが持つ <code>SoundId</code> オブジェクトを取得します.
		 * @return
		 */
		public function get soundId():SoundId  { return _soundId; }

		//----------------------------------
		//  soundId
		//----------------------------------
		private var _startTimeByMS:Number;

		/**
		 * 音源の再生開始時間をミリ秒で取得します.
		 * @return
		 */
		public function get startTimeByMS():Number  { return _startTimeByMS; }

		//----------------------------------
		//  loops
		//----------------------------------
		private var _loops:int;

		/**
		 * 指定されているループ回数を取得します.
		 * @return
		 */
		public function get loops():int  { return _loops; }

		//----------------------------------
		//  currentLoopCount
		//----------------------------------
		private var _currentLoopCount:int;

		/**
		 * 現在のループ回数を取得します.
		 * @return
		 */
		public function get currentLoopCount():int  { return _currentLoopCount; }

		//----------------------------------
		//  loopStartTime
		//----------------------------------
		private var _loopStartTimeByMS:Number;

		/**
		 * ループ開始時間をミリ秒で取得します.
		 * @return
		 */
		protected function get loopStartTimeByMS():Number  { return _loopStartTimeByMS; }

		//----------------------------------
		//  loopEndTime
		//----------------------------------
		private var _loopEndTimeByMS:Number;

		/**
		 * ループ終了時間をミリ秒で取得します.
		 * @return
		 */
		protected function get loopEndTimeByMS():Number  { return _loopEndTimeByMS; }

		//----------------------------------
		//  soundPlayType
		//----------------------------------
		private var _soundPlayType:SoundPlayType;

		/**
		 * 音源の再生タイプを取得します.
		 * @return
		 */
		protected function get soundPlayType():SoundPlayType  { return _soundPlayType; }

		//----------------------------------
		//  weakReference
		//----------------------------------
		private var _weakReference:Boolean;

		/**
		 * 再生中のサウンドオブジェクトが弱再生であるかを取得します.
		 * @return
		 */
		public function get weakReference():Boolean  { return _weakReference; }

		//----------------------------------
		//  status
		//----------------------------------
		private var _status:SoundStatusType;

		/**
		 * サウンドの再生状態を取得します.
		 * @return
		 */
		public function get status():SoundStatusType  { return _status; }

		//----------------------------------
		//  volumeController
		//----------------------------------
		private var _volumeController:IParameterController;

		/**
		 * ボリュームのコントローラを取得します.
		 * @return
		 */
		protected function get volumeController():IParameterController  { return _volumeController; }

		//----------------------------------
		//  panController
		//----------------------------------
		private var _panController:IParameterController;

		/**
		 * 定位のコントローラを取得します.
		 * @return
		 *
		 */
		protected function get panController():IParameterController  { return _panController; }

		//----------------------------------
		//  masterVolumeController
		//----------------------------------
		private var _masterVolumeController:ParameterController;

		/**
		 * マスターボリュームのコントローラを取得します.
		 * @return
		 */
		protected function get masterVolumeController():ParameterController  { return _masterVolumeController; }

		//----------------------------------
		//  soundGroupController
		//----------------------------------
		private var _soundGroupController:SoundGroupController;

		/**
		 * グループのコントローラを取得します.
		 * @return
		 */
		protected function get soundGroupController():SoundGroupController  { return _soundGroupController; }

		//----------------------------------
		//  soundChannel
		//----------------------------------
		private var _soundChannel:SoundChannel;

		/**
		 * 再生中の <code>SoundChannel</code> オブジェクトを取得します.
		 * @return
		 */
		public function get soundChannel():SoundChannel  { return _soundChannel; }

		//----------------------------------
		//  allowMultiple
		//----------------------------------
		private var _allowMultiple:Boolean;

		public function get allowMultiple():Boolean  { return _allowMultiple; }

		//----------------------------------
		//  allowInterrupt
		//----------------------------------
		private var _allowInterrupt:Boolean;

		public function get allowInterrupt():Boolean  { return _allowInterrupt; }

		//----------------------------------
		//  initVolume
		//----------------------------------
		private var _initVolume:Number;

		/**
		 * 初期のボリューム値を取得します.
		 * @return
		 */
		protected function get initVolume():Number  { return _initVolume; }

		//----------------------------------
		//  initPan
		//----------------------------------
		private var _initPan:Number;

		/**
		 * 初期の定位を取得します.
		 * @return
		 */
		protected function get initPan():Number  { return _initPan; }

		//----------------------------------
		//  pausedVolume
		//----------------------------------
		private var _pausedVolume:Number;

		/**
		 * 一時停止中のボリュームを取得します.
		 * @return
		 */
		protected function get pausedVolume():Number  { return _pausedVolume; }

		//----------------------------------
		//  pausedPan
		//----------------------------------
		private var _pausedPan:Number;

		/**
		 * 一時停止中の定位を取得します.
		 * @return
		 */
		protected function get pausedPan():Number  { return _pausedPan; }

		//----------------------------------
		//  isMute
		//----------------------------------
		private var _isMute:Boolean;

		/**
		 * ミュート中かを取得します.
		 * @return
		 */
		public function get isMute():Boolean  { return _isMute; }

		//----------------------------------
		//  currentPosition
		//----------------------------------
		private var _currentPosition:Number;

		/**
		 * 現在の再生中の場所を設定します.
		 * @return
		 */
		protected function set currentPosition(value:Number):void  { _currentPosition = value; }

		//----------------------------------
		//  totalLength
		//----------------------------------
		private var _totalLength:Number;

		/**
		 * サウンドの再生する長さを設定します.
		 * @return
		 */
		protected function set totalLength(value:Number):void  { _totalLength = value; }

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

		public function getCurrentPosition():Number
		{
			return _currentPosition;
		}

		public function getTotalLength():Number
		{
			return _totalLength;
		}

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
				_pausedVolume = _volumeController.getInternalValue();
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

		/**
		 * 使用する <code>SoundChannel</code> を設定します.</code>
		 * @param soundChannel
		 */
		protected final function setSoundChannel(soundChannel:SoundChannel):void
		{
			_soundChannel = soundChannel;
		}

		/**
		 * 使用するボリュームコントローラを設定します.</code>
		 * @param soundChannel
		 */
		protected final function setVolumeController(volumeController:IParameterController):void
		{
			_volumeController = volumeController;
		}

		/**
		 * 使用するパンコントローラを設定します.</code>
		 * @param soundChannel
		 */
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

		/**
		 * ミュート状態を解除可能かどうかを検証します.
		 * @return
		 */
		private function validateUnmutable():Boolean
		{
			// 下記の条件を満たした場合、ミュート解除可能（実質はコントローラの有効化が可能）とみなす
			// ・マスターボリュームがミュートされていない
			// ・自身がミュートされていない
			// ・グループボリュームがアサインされている場合、それがミュートされていない
			var unmutable:Boolean = !_isMute && !SoundConductor.isMute;
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

		/**
		 * 一時停止が完了した際に発火するイベントハンドラです.
		 * @param event
		 */
		private function onPauseCompleteHandler(event:Event):void
		{
			_pausedPan = panController.value;
			_volumeController.removeEventListener(Event.COMPLETE, onPauseCompleteHandler);
			_status = SoundStatusType.PAUSED;
			pauseCompleted();
			dispatchEvent(new SoundConductorEvent(SoundConductorEvent.PAUSED, _soundContoller));
		}

		/**
		 * 停止が完了した際に発火するイベントハンドラです.
		 * @param event
		 */
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
