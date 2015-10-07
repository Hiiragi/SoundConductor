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

		/** サウンドが再生中であることを表します.  */
		public static const PLAYING:String = "playing";
		/** サウンドが一時停止状態に移行中であることを表します.  */
		public static const PAUSING:String = "pausing";
		/** サウンドが一時停止状態であることを表します.  */
		public static const PAUSED:String = "paused";
		/** サウンドが停止状態に移行中であることを表します.  */
		public static const STOPPING:String = "stopping";
		/** サウンドが停止状態になったことを表します.  */
		public static const STOPPED:String = "stopped";
		/** サウンドがミュート状態になったことを表します.  */
		public static const MUTE:String = "mute";
		/** サウンドがミュート状態を解除されたことを表します.  */
		public static const UNMUTE:String = "unmute";

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param type
		 * @param soundController
		 * @param bubbles
		 * @param cancelable
		 */
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

		public function get soundController():SoundController  { return _soundController; }


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

