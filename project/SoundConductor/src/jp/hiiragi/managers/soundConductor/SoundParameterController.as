package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	public class SoundParameterController extends ParameterController
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
		public function SoundParameterController(parameterType:SoundParameterType, soundChannel:SoundChannel
												 , masterVolumeController:ParameterController = null, groupVolumeController:ParameterController = null)
		{
			_soundParameterType = parameterType;
			_soundChannel = soundChannel;
			_masterVolumeController = masterVolumeController;
			_groupVolumeController = groupVolumeController;

			var minValue:Number;
			var maxValue:Number;
			var initValue:Number;

			if (_soundParameterType == SoundParameterType.VOLUME)
			{
				minValue = 0;
				maxValue = 1;
				initValue = soundChannel.soundTransform.volume;

				if (masterVolumeController != null)
					_masterVolumeController.addEventListener(Event.CHANGE, onMasterVolumeChangeHandler);
				if (groupVolumeController != null)
					groupVolumeController.addEventListener(Event.CHANGE, onGroupVolumeChangeHandler);
			}
			else if (_soundParameterType == SoundParameterType.PAN)
			{
				minValue = -1;
				maxValue = 1;
				initValue = soundChannel.soundTransform.pan;
			}

			super(initValue, minValue, maxValue);
		}


//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _soundParameterType:SoundParameterType;

		private var _soundChannel:SoundChannel;

		private var _masterVolumeController:ParameterController;

		private var _groupVolumeController:ParameterController;

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

		override public function dispose():void
		{
			super.dispose();

			if (_masterVolumeController != null)
				_masterVolumeController.removeEventListener(Event.CHANGE, onMasterVolumeChangeHandler);
			if (_groupVolumeController != null)
				_groupVolumeController.removeEventListener(Event.CHANGE, onGroupVolumeChangeHandler);
		}

		override protected function valueChanged():void
		{
			var soundTransform:SoundTransform = _soundChannel.soundTransform;

			if (_soundParameterType == SoundParameterType.VOLUME)
			{
				var volume:Number = value;
				volume *= _masterVolumeController.value;
				if (_groupVolumeController != null)
					volume *= _groupVolumeController.value;

				soundTransform.volume = volume;
			}
			else if (_soundParameterType == SoundParameterType.PAN)
			{
				soundTransform.pan = value;
			}

			_soundChannel.soundTransform = soundTransform;
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
		private function onGroupVolumeChangeHandler(event:Event):void
		{
			valueChanged();
		}

		private function onMasterVolumeChangeHandler(event:Event):void
		{
			valueChanged();
		}
	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
