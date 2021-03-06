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
	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.constants.SoundPlayType;


	/**
	 * <code>SoundConductor</code> において、登録されたサウンドを再生するためのデータクラスです.
	 */
	public class SoundPlayInfo
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param soundId 再生したいサウンドを <code>SoundConductor</code> に登録した際に受け取る <code>SoundId</code> です.
		 */
		public function SoundPlayInfo(soundId:SoundId)
		{
			_soundId = soundId;
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  soundId
		//----------------------------------
		private var _soundId:SoundId;

		/**
		 * コンストラクタで指定した <code>SoundId</code> を取得します.
		 * @return
		 */
		public function get soundId():SoundId  { return _soundId; }

		public function set soundId(value:SoundId):void  { _soundId = value; }

		//----------------------------------
		//  startTimeByMS
		//----------------------------------
		private var _startTimeByMS:Number = 0;

		/**
		 * サウンドの開始時間をミリ秒で取得・設定します.
		 * @return
		 * @default 0
		 */
		public function get startTimeByMS():Number  { return _startTimeByMS; }

		public function set startTimeByMS(value:Number):void  { _startTimeByMS = value; }

		//----------------------------------
		//  loops
		//----------------------------------
		private var _loops:int = SoundLoopType.NO_LOOP;

		/**
		 * サウンドのループ回数を取得・設定します.
		 * <p>指定には、<code>int</code> の正の整数か、<code>SoundLoopType</code> の定数を使用します.</p>
		 * @return
		 * @default SoundLoopType.NO_LOOP
		 */
		public function get loops():int  { return _loops; }

		public function set loops(value:int):void  { _loops = value; }

		//----------------------------------
		//  loopStartTimeByMS
		//----------------------------------
		private var _loopStartTimeByMS:Number = 0;

		/**
		 * サウンドのループ開始時間をミリ秒で取得・設定します.
		 * @return
		 * @default 0
		 */
		public function get loopStartTimeByMS():Number  { return _loopStartTimeByMS; }

		public function set loopStartTimeByMS(value:Number):void  { _loopStartTimeByMS = value; }

		//----------------------------------
		//  loopEndTimeByMS
		//----------------------------------
		private var _loopEndTimeByMS:Number = 0;

		/**
		 * サウンドのループ終了時間をミリ秒で取得・設定します.
		 * @return
		 */
		public function get loopEndTimeByMS():Number  { return _loopEndTimeByMS; }

		public function set loopEndTimeByMS(value:Number):void  { _loopEndTimeByMS = value; }

		//----------------------------------
		//  groupName
		//----------------------------------
		private var _groupName:String = "";

		/**
		 * アサインするグループ名を取得・設定します.
		 * @return
		 * @default ""
		 */
		public function get groupName():String  { return _groupName; }

		public function set groupName(value:String):void  { _groupName = value; }

		//----------------------------------
		//  volume
		//----------------------------------
		private var _volume:Number = 1;

		/**
		 * 再生する際のボリュームを取得・設定します.
		 * @return
		 * @default 1
		 */
		public function get volume():Number  { return _volume; }

		public function set volume(value:Number):void  { _volume = value; }

		//----------------------------------
		//  pan
		//----------------------------------
		private var _pan:Number = 0;

		/**
		 * 再生する際の定位を取得・設定します.
		 * @return
		 * @default 0
		 */
		public function get pan():Number  { return _pan; }

		public function set pan(value:Number):void  { _pan = value; }

		//----------------------------------
		//  soundPlayType
		//----------------------------------
		private var _soundPlayType:SoundPlayType = SoundPlayType.NORMAL_SOUND_ARCHITECT;

		/**
		 * 音源の再生タイプを取得・設定します.
		 * @return
		 * @default SoundPlayType.NORMAL_SOUND_ARCHITECT
		 */
		public function get soundPlayType():SoundPlayType  { return _soundPlayType; }

		public function set soundPlayType(value:SoundPlayType):void  { _soundPlayType = value; }

		//----------------------------------
		//  weakReference
		//----------------------------------
		private var _weakReference:Boolean = false;

		/**
		 * 再生可能な同時発音数をオーバーした際に、強制的に音を停止し、サウンドチャンネルを譲るかどうかを取得・設定します.
		 * @return
		 * @default false
		 */
		public function get weakReference():Boolean  { return _weakReference; }

		public function set weakReference(value:Boolean):void  { _weakReference = value; }

	}
}

