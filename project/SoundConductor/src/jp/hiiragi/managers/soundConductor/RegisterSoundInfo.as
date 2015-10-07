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
