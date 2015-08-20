package jp.hiiragi.managers.soundConductor
{
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

	public class SoundGroupController
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
		public function SoundGroupController(groupName:String)
		{
			_isMute = false;

			_groupName = groupName;
			_groupVolumeController = new ParameterController(1);
			_soundControllerList = new Vector.<SoundController>();
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _soundControllerList:Vector.<SoundController>;

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
		//  groupName
		//----------------------------------
		private var _groupName:String;

		public function get groupName():String
		{
			return _groupName;
		}

		//----------------------------------
		//  isMute
		//----------------------------------
		private var _isMute:Boolean;

		public function get isMute():Boolean
		{
			return _isMute;
		}

		//----------------------------------
		//  groupVolumeController
		//----------------------------------
		private var _groupVolumeController:ParameterController;

		internal function get groupVolumeController():ParameterController
		{
			return _groupVolumeController;
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

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

		public function getVolume():Number
		{
			return groupVolumeController.value;
		}

		public function setVolume(volume:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			groupVolumeController.setValue(volume, easingTimeByMS, easing);
		}

		public function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].pause(fadeOutTimeByMS, fadeOutEasing);
			}
		}

		public function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].resume(fadeInTimeByMS, fadeInEasing);
			}
		}

		public function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].stop(fadeOutTimeByMS, fadeOutEasing);
			}
		}

		public function mute():void
		{
			if (_isMute)
			{
				return;
			}

			_isMute = true;
			_groupVolumeController.setEnabled(false);

			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].muteAtParent();
			}
		}

		public function unmute():void
		{
			if (!_isMute)
			{
				return;
			}

			_isMute = false;
			_groupVolumeController.setEnabled(true);

			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].unmuteAtParent();
			}
		}

//--------------------------------------------------------------------------
//
//  Internal methods
//
//--------------------------------------------------------------------------
		internal function addSoundController(soundController:SoundController):void
		{
			_soundControllerList.push(soundController);
			soundController.addEventListener(SoundConductorEvent.STOPPED, soundStoppedHandler);
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


		protected function soundStoppedHandler(event:SoundConductorEvent):void
		{
			var soundController:SoundController = event.soundController;
			var index:int = _soundControllerList.indexOf(soundController);

			soundController.removeEventListener(SoundConductorEvent.STOPPED, soundStoppedHandler);

			_soundControllerList.splice(index, 1);
		}

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
