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

			while (byteArray.bytesAvailable)
			{
				var volumeMultipleValue:Number = masterVolumeController.value;
				volumeMultipleValue *= volumeController.value;
				if (soundGroupController != null)
				{
					volumeMultipleValue *= soundGroupController.groupVolumeController.value;
				}

				var pan:Number = panController.value;
				var leftMultipleValue:Number = ((pan < 0) ? 1 : 1 - pan) * volumeMultipleValue;
				var rightMultipleValue:Number = ((pan > 0) ? 1 : pan + 1) * volumeMultipleValue;

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
