package jp.hiiragi.managers.soundConductor.events
{
	import flash.events.Event;

	import jp.hiiragi.managers.soundConductor.SoundController;


	public class SoundConductorEvent extends Event
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------
		public static const PLAYING:String = "playing";
		public static const PAUSING:String = "pausing";
		public static const PAUSED:String = "paused";
		public static const STOPPING:String = "stopping";
		public static const STOPPED:String = "stopped";
		public static const MUTE:String = "mute";
		public static const UNMUTE:String = "unmute";

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function SoundConductorEvent(type:String, soundController:SoundController, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_soundController = soundController;
			super(type, bubbles, cancelable);
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  soundController
		//----------------------------------
		private var _soundController:SoundController;

		public function get soundController():SoundController
		{
			return _soundController;
		}


//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new SoundConductorEvent(type, soundController, bubbles, cancelable);
		}

		override public function toString():String
		{
			return formatToString("SoundConductorEvent", "type", "soundController", "bubbles", "cancelable", "eventPhase");
		}
	}
}

