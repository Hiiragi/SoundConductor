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

package jp.hiiragi.managers.soundConductor.events
{
	import flash.events.Event;

	import jp.hiiragi.managers.soundConductor.SoundController;


	public class SoundConductorEvent extends Event
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** サウンドが再生中であることを表します.  */
		public static const PLAYING:String = "playing";
		/** サウンドが一時停止状態に移行中であることを表します.  */
		public static const PAUSING:String = "pausing";
		/** サウンドが一時停止状態であることを表します.  */
		public static const PAUSED:String = "paused";
		/** サウンドが停止状態に移行中であることを表します.  */
		public static const STOPPING:String = "stopping";
		/** サウンドが停止状態になったことを表します.  */
		public static const STOPPED:String = "stopped";
		/** サウンドがミュート状態になったことを表します.  */
		public static const MUTE:String = "mute";
		/** サウンドがミュート状態を解除されたことを表します.  */
		public static const UNMUTE:String = "unmute";
		/** サウンドがループしたことを表します.  */
		public static const LOOP:String = "loop";

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param type
		 * @param soundController
		 * @param bubbles
		 * @param cancelable
		 */
		public function SoundConductorEvent(type:String, soundController:SoundController, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_soundController = soundController;
			super(type, bubbles, cancelable);
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  soundController
		//----------------------------------
		private var _soundController:SoundController;

		public function get soundController():SoundController  { return _soundController; }


//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new SoundConductorEvent(type, soundController, bubbles, cancelable);
		}

		override public function toString():String
		{
			return formatToString("SoundConductorEvent", "type", "soundController", "bubbles", "cancelable", "eventPhase");
		}
	}
}

