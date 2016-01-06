/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Hiiragi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package jp.hiiragi.managers.soundConductor
{
	import com.jac.ogg.OggManager;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;
	import jp.hiiragi.managers.soundConductor.events.OggDecodeEvent;

//--------------------------------------
//  Events
//--------------------------------------

	[Event(name = "progress", type = "jp.hiiragi.managers.soundConductor.events.OggDecodeEvent")]

	[Event(name = "complete", type = "jp.hiiragi.managers.soundConductor.events.OggDecodeEvent")]

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

		/**
		 * コンストラクタです.
		 * @param soundId
		 * @param oggBinary
		 * @param allowMultiple
		 * @param allowInterrupt
		 */
		public function RegisteredOggSoundData(soundId:SoundId, oggBinary:ByteArray, allowMultiple:Boolean = false, allowInterrupt:Boolean = false)
		{
			super(soundId, null, new ByteArray(), allowMultiple, allowInterrupt);

			if (!SoundUtil.checkOggFormat(oggBinary))
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10206);
			}

			_decodeOggCompleted = false;

			_oggManager = new OggManager();
			oggBinary.position = 0;
			_oggManager.initDecoder(oggBinary);

			_tempBuffer = new ByteArray();
			_totalLength = Math.floor(SoundUtil.calcurateOggLength(oggBinary, _oggManager.audioInfo.sampleRate));

			var samplingRate:int = _oggManager.audioInfo.sampleRate;

			// LOOPSTART と LOOPLENGTH のタグに対応
			if (_oggManager.oggComments.hasOwnProperty("LOOPSTART") && _oggManager.oggComments.hasOwnProperty("LOOPLENGTH"))
			{
				_hasLoopTag = true;
				_loopStartByteIndex = parseInt(_oggManager.oggComments["LOOPSTART"]) * 8;
				_loopEndByteIndex = _loopStartByteIndex + parseInt(_oggManager.oggComments["LOOPLENGTH"]) * 8;
			}
			else
			{
				_hasLoopTag = false;
				_loopStartByteIndex = -1;
				_loopEndByteIndex = -1;
			}

			// init buffer
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

		public function get oggManager():OggManager  { return _oggManager; }

		//----------------------------------
		//  oggManager
		//----------------------------------
		private var _totalLength:uint;

		public function get totalLength():uint  { return _totalLength; }

		//----------------------------------
		//  decodeOggCompleted
		//----------------------------------
		private var _decodeOggCompleted:Boolean;

		public function get decodeOggCompleted():Boolean  { return _decodeOggCompleted; }

		//----------------------------------
		//  hasLoopTag
		//----------------------------------
		private var _hasLoopTag:Boolean;

		public function get hasLoopTag():Boolean  { return _hasLoopTag; }

		//----------------------------------
		//  loopStartByteIndex
		//----------------------------------
		private var _loopStartByteIndex:Number;

		public function get loopStartByteIndex():Number  { return _loopStartByteIndex; }

		//----------------------------------
		//  loopEndByteIndex
		//----------------------------------
		private var _loopEndByteIndex:Number;

		public function get loopEndByteIndex():Number  { return _loopEndByteIndex; }

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

			var position:Number = result["position"];
			var length:Number = result["length"];

			soundByteArray.writeBytes(_tempBuffer);

			if (_tempBuffer.length > 0)
			{
				dispatchEvent(new OggDecodeEvent(OggDecodeEvent.PROGRESS, position, length));
			}
			else
			{
				finalizeOggDecode();
				dispatchEvent(new OggDecodeEvent(OggDecodeEvent.COMPLETE, position, length));
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

