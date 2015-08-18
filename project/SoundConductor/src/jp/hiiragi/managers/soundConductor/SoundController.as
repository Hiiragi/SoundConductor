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

	public class SoundController extends EventDispatcher implements ISoundController
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function SoundController(playingData:AbstractPlayingData)
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
		//  propertyName
		//----------------------------------
		private var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
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

		public function getStatus():SoundStatusType
		{
			checkEnabled();
			return _playingData.status;
		}

		public function getPan():Number
		{
			checkEnabled();
			return _playingData.getPan();
		}

		public function getVolume():Number
		{
			checkEnabled();
			return _playingData.getVolume();
		}

		public function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			checkEnabled();
			_playingData.pause(fadeOutTimeByMS, fadeOutEasing);
		}

		public function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			checkEnabled();
			_playingData.resume(fadeInTimeByMS, fadeInEasing);
		}

		public function seek(timeByMS:Number):void
		{
			throw new Error("seek() is not implemented.");

			checkEnabled();
			_playingData.seek(timeByMS);
		}

		public function setPan(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			checkEnabled();
			_playingData.setPan(value, easingTimeByMS, easing);
		}

		public function setVolume(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			checkEnabled();
			_playingData.setVolume(value, easingTimeByMS, easing);
		}

		public function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			checkEnabled();
			_playingData.stop(fadeOutTimeByMS, fadeOutEasing);
		}

		public function mute():void
		{
			_playingData.mute();
		}

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
