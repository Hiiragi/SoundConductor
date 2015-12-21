package jp.hiiragi.managers.soundConductor
{
	import flash.media.SoundChannel;


	internal class ApplyFadeSoundData
	{

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function ApplyFadeSoundData(controller:SoundParameterController, soundChannel:SoundChannel, stopSoundWhenCompleted:Boolean, callback:Function)
		{
			_controller = controller;
			_soundChannel = soundChannel;
			_stopSoundWhenCompleted = stopSoundWhenCompleted;
			_callback = callback;
		}


//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  controller
		//----------------------------------
		private var _controller:SoundParameterController

		public function get controller():SoundParameterController  { return _controller; }

		//----------------------------------
		//  soundChannel
		//----------------------------------
		private var _soundChannel:SoundChannel;

		public function get soundChannel():SoundChannel  { return _soundChannel; }

		//----------------------------------
		//  stopSoundWhenCompleted
		//----------------------------------
		private var _stopSoundWhenCompleted:Boolean;

		public function get stopSoundWhenCompleted():Boolean  { return _stopSoundWhenCompleted; }

		//----------------------------------
		//  callback
		//----------------------------------
		private var _callback:Function;

		public function get callback():Function  { return _callback; }

	}
}

