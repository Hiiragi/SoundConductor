package jp.hiiragi.managers.soundConductor
{
	import flash.events.EventDispatcher;

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

	/**
	 * 再生中のサウンドを制御するためのコントローラクラスです.
	 */
	public class SoundController extends EventDispatcher
	{
//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private static var _isCalledFromInternal:Boolean = false;

//--------------------------------------------------------------------------
//
//  Class Internal methods
//
//--------------------------------------------------------------------------

		internal static function createController(playingData:AbstractPlayingData):SoundController
		{
			_isCalledFromInternal = true;
			var controller:SoundController = new SoundController(playingData);

			return controller;
		}

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * <p>外部からのインスタンス化は出来ません。</p>
		 * @param playingData
		 * @private
		 */
		public function SoundController(playingData:AbstractPlayingData)
		{
			if (_isCalledFromInternal)
			{
				_enabled = true;
				_playingData = playingData;

				_playingData.addEventListener(SoundConductorEvent.PAUSED, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.PAUSING, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.PLAYING, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.STOPPED, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.STOPPING, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.MUTE, receiveEventFromPlayingData);
				_playingData.addEventListener(SoundConductorEvent.UNMUTE, receiveEventFromPlayingData);

				_isCalledFromInternal = false;
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10003);
			}
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  playingData
		//----------------------------------
		private var _playingData:AbstractPlayingData;

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  enabled
		//----------------------------------
		private var _enabled:Boolean;

		/**
		 * 現在サウンドが有効であるかを取得します.
		 * @return
		 */
		internal function get enabled():Boolean  { return _enabled; }

		//----------------------------------
		//  status
		//----------------------------------
		/**
		 * サウンドの再生状態を取得します.
		 * @return
		 */
		public function get status():SoundStatusType
		{
			checkEnabled();
			return _playingData.status;
		}

		//----------------------------------
		//  volume
		//----------------------------------
		/**
		 * サウンドのボリュームを取得します.
		 * @return
		 */
		public function get volume():Number
		{
			checkEnabled();
			return _playingData.getVolume();
		}

		//----------------------------------
		//  pan
		//----------------------------------
		/**
		 * サウンドの定位を取得します.
		 * @return
		 */
		public function get pan():Number
		{
			checkEnabled();
			return _playingData.getPan();
		}

		//----------------------------------
		//  currentPosition
		//----------------------------------
		/**
		 * 現在の再生中の場所を取得します.
		 * @return
		 */
		public function get currentPosition():Number
		{
			return _playingData.getCurrentPosition();
		}

		//----------------------------------
		//  totalLength
		//----------------------------------
		/**
		 * サウンドの再生する長さを取得します.
		 * @return
		 */
		public function get totalLength():Number
		{
			return _playingData.getTotalLength();
		}

//--------------------------------------------------------------------------
//
//  Namespace methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------


		/**
		 * サウンドの一時停止を行います.
		 * @param fadeOutTimeByMS
		 * @param fadeOutEasing
		 */
		public function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			checkEnabled();
			_playingData.pause(fadeOutTimeByMS, fadeOutEasing);
		}

		/**
		 * サウンドの一時停止の解除を行います.
		 * @param fadeInTimeByMS
		 * @param fadeInEasing
		 */
		public function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			checkEnabled();
			_playingData.resume(fadeInTimeByMS, fadeInEasing);
		}

		/**
		 * サウンドのシークを行います
		 * @param timeByMS
		 */
		public function seek(timeByMS:Number):void
		{
			checkEnabled();
			_playingData.seek(timeByMS);
		}

		/**
		 * 定位を設定します.
		 * @param value
		 * @param easingTimeByMS
		 * @param easing
		 */
		public function setPan(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			checkEnabled();
			_playingData.setPan(value, easingTimeByMS, easing);
		}

		/**
		 * ボリュームを設定します.
		 * @param value
		 * @param easingTimeByMS
		 * @param easing
		 */
		public function setVolume(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			checkEnabled();
			_playingData.setVolume(value, easingTimeByMS, easing);
		}

		/**
		 * サウンドを停止します.
		 * @param fadeOutTimeByMS
		 * @param fadeOutEasing
		 */
		public function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			checkEnabled();
			_playingData.stop(fadeOutTimeByMS, fadeOutEasing);
		}

		/**
		 * サウンドをミュートします.
		 */
		public function mute():void
		{
			_playingData.mute();
		}

		/**
		 * サウンドのミュートを解除します.
		 */
		public function unmute():void
		{
			_playingData.unmute();
		}

//--------------------------------------------------------------------------
//
//  Internal methods
//
//--------------------------------------------------------------------------
		internal function dispose():void
		{
			_playingData.removeEventListener(SoundConductorEvent.PAUSED, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.PAUSING, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.PLAYING, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.STOPPED, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.STOPPING, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.MUTE, receiveEventFromPlayingData);
			_playingData.removeEventListener(SoundConductorEvent.UNMUTE, receiveEventFromPlayingData);

			_enabled = false;
			_playingData = null;
		}

		internal final function muteAtParent():void
		{
			_playingData.muteAtParent();
		}

		internal final function unmuteAtParent():void
		{
			_playingData.unmuteAtParent();
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
		private function checkEnabled():void
		{
			if (!_enabled)
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10201);
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

		protected function receiveEventFromPlayingData(event:SoundConductorEvent):void
		{
			dispatchEvent(event);
		}

	}
}
