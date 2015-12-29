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

	public class PlayingDataForOggSingleSoundGenerator extends AbstractPlayingOggDataForSoundGenerator
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
		public function PlayingDataForOggSingleSoundGenerator(playInfo:SoundPlayInfo, registeredSoundData:RegisteredSoundData, soundGroupController:SoundGroupController)
		{
			_soundGenerator = new SoundGeneratorEngine();
			super(playInfo, registeredSoundData, soundGroupController);
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _soundGenerator:SoundGeneratorEngine;

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
			_soundGenerator.addPlayingData(this);
			_soundGenerator.soundChannel.soundTransform = new SoundTransform(initVolume, initPan);

			var groupVolumeController:ParameterController;
			if (soundGroupController != null)
				groupVolumeController = soundGroupController.groupVolumeController;

			setVolumeController(new SoundParameterController(SoundParameterType.VOLUME, _soundGenerator.soundChannel, masterVolumeController, groupVolumeController));

			setPanController(new SoundParameterController(SoundParameterType.PAN, _soundGenerator.soundChannel));
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
