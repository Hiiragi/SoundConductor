package jp.hiiragi.managers.soundConductor
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	import jp.hiiragi.managers.soundConductor.constants.SoundBufferType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

	internal class SoundUtil
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** 無音の <code>ByteArray</code> です. */
		private static const SILENT_BYTE_ARRAY:ByteArray = new ByteArray();


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

		/**
		 * 現在サウンドが再生可能かをチェックします.
		 * @return
		 */
		public static function checkPlayable():Boolean
		{
			var sound:Sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
			var sc:SoundChannel = sound.play();

			if (sc != null)
			{
				sc.stop();
				return true;
			}

			return false;

			function onSampleDataHandler(event:SampleDataEvent):void
			{
				return;
			}
		}

		/**
		 * 指定の長さで生成された無音の <code>ByteArray</code> を取得します.
		 * @param length
		 * @return
		 */
		public static function getSilentByteArray(length:int):ByteArray
		{
			if (SILENT_BYTE_ARRAY.length == 0)
			{
				var len:int = int(SoundBufferType.BUFFER_SIZE_8192.value);
				for (var i:int = 0; i < len; i++)
				{
					SILENT_BYTE_ARRAY.writeFloat(0);
					SILENT_BYTE_ARRAY.writeFloat(0);
				}
			}

			var byteArray:ByteArray = new ByteArray();
			byteArray.writeBytes(SILENT_BYTE_ARRAY, 0, length);

			return byteArray;
		}

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

		public function SoundUtil()
		{
			throw new SoundConductorError(SoundConductorErrorType.ERROR_10001);
		}

	}
}

