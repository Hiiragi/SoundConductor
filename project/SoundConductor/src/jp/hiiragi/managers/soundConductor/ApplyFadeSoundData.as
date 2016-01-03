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
	import flash.media.SoundChannel;


	internal class ApplyFadeSoundData
	{

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function ApplyFadeSoundData(controller:SoundParameterController, soundChannel:SoundChannel, stopSoundWhenCompleted:Boolean, callback:Function)
		{
			_controller = controller;
			_soundChannel = soundChannel;
			_stopSoundWhenCompleted = stopSoundWhenCompleted;
			_callback = callback;
		}


//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  controller
		//----------------------------------
		private var _controller:SoundParameterController

		public function get controller():SoundParameterController  { return _controller; }

		//----------------------------------
		//  soundChannel
		//----------------------------------
		private var _soundChannel:SoundChannel;

		public function get soundChannel():SoundChannel  { return _soundChannel; }

		//----------------------------------
		//  stopSoundWhenCompleted
		//----------------------------------
		private var _stopSoundWhenCompleted:Boolean;

		public function get stopSoundWhenCompleted():Boolean  { return _stopSoundWhenCompleted; }

		//----------------------------------
		//  callback
		//----------------------------------
		private var _callback:Function;

		public function get callback():Function  { return _callback; }

	}
}

