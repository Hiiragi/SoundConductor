package jp.hiiragi.managers.soundConductor
{
	import flash.utils.ByteArray;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	internal class PlayingDataForSharedSoundGenerator extends AbstractPlayingDataForSoundGenerator
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
		public function PlayingDataForSharedSoundGenerator(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, groupController:SoundGroupController
														   , sharedSoundGeneratorEngine:SoundGeneratorEngine)
		{
			_sharedSoundGeneratorEngine = sharedSoundGeneratorEngine;
			super(playInfo, registeredSoundData, groupController);
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _sharedSoundGeneratorEngine:SoundGeneratorEngine;

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
			setVolumeController(new SoundParameterControllerForSoundGenerator(SoundParameterType.VOLUME, initVolume));
			setPanController(new SoundParameterControllerForSoundGenerator(SoundParameterType.PAN, initPan));
			_sharedSoundGeneratorEngine.addPlayingData(this);
		}

		override protected function writeSoundByteArrayFinished(byteArray:ByteArray):ByteArray
		{
			var len:int = byteArray.length;
			var editedByteArray:ByteArray = new ByteArray();

			var volumeMultipleValue:Number = masterVolumeController.value;
			volumeMultipleValue *= volumeController.value;
			if (soundGroupController != null)
			{
				volumeMultipleValue *= soundGroupController.groupVolumeController.value;
			}

			var pan:Number = panController.value;
			var leftMultipleValue:Number = ((pan < 0) ? 1 : 1 - pan) * volumeMultipleValue;
			var rightMultipleValue:Number = ((pan > 0) ? 1 : pan + 1) * volumeMultipleValue;

			while (byteArray.bytesAvailable)
			{
				editedByteArray.writeFloat(byteArray.readFloat() * leftMultipleValue);
				editedByteArray.writeFloat(byteArray.readFloat() * rightMultipleValue);
			}


			// ポジションを最初に戻す
			editedByteArray.position = 0;

			return editedByteArray;
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

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
