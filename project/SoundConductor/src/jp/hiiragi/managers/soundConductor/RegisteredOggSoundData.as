package jp.hiiragi.managers.soundConductor
{
	import com.jac.ogg.OggManager;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.media.Sound;
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

	public class RegisteredOggSoundData extends RegisteredSoundData
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
		public function RegisteredOggSoundData(soundId:SoundId, oggBinary:ByteArray, allowMultiple:Boolean=false, allowInterrupt:Boolean=false)
		{
			super(soundId, null, new ByteArray(), allowMultiple, allowInterrupt);

			if (!SoundUtil.checkOggFormat(oggBinary))
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10206);
			}

			_oggManager = new OggManager();
			oggBinary.position = 0;
			_oggManager.initDecoder(oggBinary);

			_tempBuffer = new ByteArray();
			_totalLength = Math.floor(SoundUtil.calcurateOggLength(oggBinary, _oggManager.audioInfo.sampleRate));

			for (var i:int = 0; i < 60; i++)
			{
				writeDecodedSampleData();
			}

			_ticker = new Shape();
			_ticker.addEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
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
		//  oggManager
		//----------------------------------
		private var _oggManager:OggManager;

		public function get oggManager():OggManager { return _oggManager; }

		//----------------------------------
		//  oggManager
		//----------------------------------
		private var _totalLength:uint;

		public function get totalLength():uint { return _totalLength; }


		//----------------------------------
		//  decodeOggCompleted
		//----------------------------------
		private var _decodeOggCompleted:Boolean;

		public function get decodeOggCompleted():Boolean { return _decodeOggCompleted; }

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

		override public function dispose():void
		{
			if (_ticker.hasEventListener(Event.ENTER_FRAME))
			{
				_ticker.removeEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);
			}

			_ticker = null;

			if (_oggManager.isDecoding || _oggManager.isEncoding)
			{
				_oggManager.cancel();
			}
			_oggManager.decodedBytes.clear();
			_oggManager.encodedBytes.clear();
			_oggManager.wavBytes.clear();
			_oggManager = null;

			_tempBuffer.clear();
			_tempBuffer = null;

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
			_tempBuffer.length = 0;
			var result:Object = _oggManager.getSampleData(4096, _tempBuffer);

			if (result["position"] < result["length"])
			{
				soundByteArray.writeBytes(_tempBuffer);
			}
			else
			{
				finalizeOggDecode();
			}
		}

		private function finalizeOggDecode():void
		{
			_ticker.removeEventListener(Event.ENTER_FRAME, onDecodeEnterFrameHandler);

			_decodeOggCompleted = true;
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

