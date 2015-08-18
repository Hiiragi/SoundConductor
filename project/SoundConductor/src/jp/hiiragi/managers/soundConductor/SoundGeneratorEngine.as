package jp.hiiragi.managers.soundConductor
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.constants.SoundStatusType;


	internal class SoundGeneratorEngine
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function SoundGeneratorEngine()
		{
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataEvent);
			_soundChannel = _sound.play();
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _sound:Sound = new Sound();

		private var _soundList:Vector.<AbstractPlayingDataForSoundGenerator> = new Vector.<AbstractPlayingDataForSoundGenerator>();

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
		//  soundChannel
		//----------------------------------
		private var _soundChannel:SoundChannel;

		internal function get soundChannel():SoundChannel
		{
			return _soundChannel;
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
		public function addPlayingData(playingData:AbstractPlayingDataForSoundGenerator):void
		{
			_soundList.push(playingData);
		}



		public function dispose():void
		{
			_soundList.length = 0;
			_soundChannel.stop();
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
		private function removePlayingData(playingData:AbstractPlayingDataForSoundGenerator):void
		{
			var index:int = _soundList.indexOf(playingData);
			if (index > -1)
			{
				_soundList.splice(index, 1);
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
		private function onSampleDataEvent(event:SampleDataEvent):void
		{
			var i:int = 0;
			var playingData:AbstractPlayingDataForSoundGenerator;
			var soundListLength:int = _soundList.length;
			var bufferSize:int = int(SoundConductor.soundBufferSize.value);
			var bufferByteSize:int = bufferSize * 8;

			var bufferByteArrayList:Vector.<ByteArray>;

			if (soundListLength == 0)
			{
				event.data.writeBytes(SoundUtil.getSilentByteArray(bufferByteSize));
				return;
			}
			else
			{
				bufferByteArrayList = new Vector.<ByteArray>();
				for (i = soundListLength - 1; i >= 0; i--)
				{
					playingData = _soundList[i];
					var bufferByteArray:ByteArray;

					if (playingData.status == SoundStatusType.PAUSED)
					{
					}
					else
					{
						bufferByteArray = playingData.getSoundByteArrayForSoundGenerator(bufferByteSize);

						bufferByteArray.position = 0;
						if (bufferByteArray.length > 0)
							bufferByteArrayList.push(bufferByteArray);

						if (playingData.status == SoundStatusType.STOPPED)
							removePlayingData(playingData);
					}



				}
			}

			var bufferListLength:int = bufferByteArrayList.length;
			if (bufferListLength == 0)
			{
				event.data.writeBytes(SoundUtil.getSilentByteArray(bufferByteSize));
				return;
			}
			else
			{
				var leftValue:Number;
				var rightValue:Number;
				for (i = 0; i < bufferSize; i++)
				{
					leftValue = 0;
					rightValue = 0;
					for (var j:int = 0; j < bufferListLength; j++)
					{
						bufferByteArray = bufferByteArrayList[j];
						if (bufferByteArray.bytesAvailable)
						{
							leftValue += bufferByteArray.readFloat();
							rightValue += bufferByteArray.readFloat();
						}
					}

					event.data.writeFloat(leftValue);
					event.data.writeFloat(rightValue);
				}

			}

		}
	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
