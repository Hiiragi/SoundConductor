package jp.hiiragi.managers.soundConductor
{
	import com.jac.ogg.OggManager;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	public class AbstractPlayingOggDataForSoundGenerator extends AbstractPlayingDataForSoundGenerator
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
//  Class Namespace methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Public methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Internal methods
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
//  Class Event handlers
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function AbstractPlayingOggDataForSoundGenerator(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, soundGroupController:SoundGroupController)
		{
			if (this["constructor"] != AbstractPlayingOggDataForSoundGenerator)
			{
				super(playInfo, registeredSoundData, soundGroupController);

				_oggManager = new OggManager();
				_oggManager.initDecoder(registeredSoundData.soundByteArray);
				
				_tempBuffer = new ByteArray();
				totalLength = Math.floor(SoundUtil.calcurateOggLength(registeredSoundData.soundByteArray, _oggManager.audioInfo.sampleRate) / SoundUtil.COEFFICIENT_OF_CONVERT_FROM_MS_TO_BYTE) * 1000;
				soundByteArray = new ByteArray();
				
				for (var i:int = 0; i < 60; i++)
				{
					writeDecodedSampleData();
				}
				
				_ticker = new Shape();
				_ticker.addEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);
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
		private var _oggManager:OggManager;

		private var _tempBuffer:ByteArray;
		
		private var _ticker:Shape;

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
			if (_ticker.hasEventListener(Event.ENTER_FRAME))
			{
				_oggManager.cancel();
				_ticker.removeEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);
			}
			
			_oggManager.decodedBytes.clear();
			_oggManager.encodedBytes.clear();
			_oggManager.wavBytes.clear();
			
			_tempBuffer.clear();
			
			super.dispose();
		}
//--------------------------------------------------------------------------
//
//  Service methods
//
//--------------------------------------------------------------------------

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

//--------------------------------------------------------------------------
//
//  Internal methods
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

		private function writeDecodedSampleData():void
		{
			if (!registeredSoundData.decodeOggCompleted)
			{
				_tempBuffer.length = 0;
				var result:Object = _oggManager.getSampleData(4096, _tempBuffer);
				
				if (result["position"] < result["length"])
				{
					soundByteArray.writeBytes(_tempBuffer);
				}
				else
				{
					registeredSoundData.setDecodedSoundByteArray(soundByteArray);
					finalizeOggDecode();
				}
			}
			// 別の PlayingData で同じ Ogg のデコードをしていたのが終わった場合に、こちらも読み込み済みの soundByteArray に切り替える
			else
			{
				finalizeOggDecode();
			}
		}
		
		private function finalizeOggDecode():void
		{
			_ticker.removeEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);
			soundByteArray.clear();
			soundByteArray = registeredSoundData.soundByteArray;
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

		private function onDecodeEnterFrameHandler(event:Event):void
		{
			writeDecodedSampleData();
		}
		
	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
