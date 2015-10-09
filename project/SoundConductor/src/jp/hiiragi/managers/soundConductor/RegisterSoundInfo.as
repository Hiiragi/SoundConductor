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

	/**
	 *  <code>SoundConductor</code> にサウンドを登録するためのデータクラスです.
	 */
	public class RegisterSoundInfo
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param sound	再生する音源を指定します。指定できる音源は、 "リンケージの文字列"、"<code>Sound</code> クラスを継承した音源クラス"、"<code>Sound</code> オブジェクト"、"PCM の <code>ByteArray</code>" です。
		 * @param createPCMByteArray	<code>sound</code> の引数が <code>ByteArray</code> 以外だった場合に、その音源から PCM の <code>ByteArray</code> を生成するかどうかを指定します。
		 * @param allowMultiple	登録した音源を複数同時再生できるかどうかを指定します。
		 * @param allowInterrupt	<code>allowMultiple</code> が <code>false</code> （複数同時再生しない）の場合において、追加で再生をしようとした際に、現在鳴っている音を止めて新しく鳴らすかどうかを指定します。
		 */
		public function RegisterSoundInfo(sound:*, createPCMByteArray:Boolean = false, allowMultiple:Boolean = true, allowInterrupt:Boolean = true)
		{
			_sound = sound;

			_createPCMByteArray = createPCMByteArray;
			_allowMultiple = allowMultiple;
			_allowInterrupt = allowInterrupt;
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  sound
		//----------------------------------
		private var _sound:*;

		/**
		 * コンストラクタで指定した音源を取得します.
		 * 指定できる音源は、 "リンケージの文字列"、"<code>Sound</code> クラスを継承した音源クラス"、"<code>Sound</code> オブジェクト"、"PCM の <code>ByteArray</code>" です。
		 * @return
		 */
		public function get sound():*  { return _sound; }

		//----------------------------------
		//  sound
		//----------------------------------
		private var _createPCMByteArray:Boolean = false;

		/**
		 * <code>sound</code> の引数が PCM の <code>ByteArray</code> 以外だった場合に、その音源から PCM の <code>ByteArray</code> を生成するかどうかを取得します.
		 * <p><code>sound</code> の引数が <code>ByteArray</code> だった場合は無視されます.</p>
		 * <p>デフォルトは <code>false</code> です.</p>
		 * @return
		 */
		public function get createPCMByteArray():Boolean  { return _createPCMByteArray; }

		//----------------------------------
		//  allowMultiple
		//----------------------------------
		private var _allowMultiple:Boolean = true;

		/**
		 * 音源を複数同時再生できるかどうかを取得します.
		 * @return
		 */
		public function get allowMultiple():Boolean  { return _allowMultiple; }

		//----------------------------------
		//  allowInterrupt
		//----------------------------------
		private var _allowInterrupt:Boolean = true;

		/**
		 * <code>allowMultiple</code> が <code>false</code> （複数同時再生しない）の場合において、追加で再生をしようとした際に、現在鳴っている音を止めて新しく鳴らすかどうかを指定します.
		 * @return
		 */
		public function get allowInterrupt():Boolean  { return _allowInterrupt; }

	}
}
