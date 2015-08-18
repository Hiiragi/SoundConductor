package jp.hiiragi.managers.soundConductor.constants
{

	/**
	 * <code>SoundLoopType</code> クラスは、サウンドのループ機能に関する定数値の列挙です。
	 * @author
	 */
	public class SoundLoopType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** ループを行わないことを表します.  */
		public static const NO_LOOP:int = 0;

		/** 無限ループを表します. */
		public static const INFINITE_LOOP:int = -1;

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		/**
		 * コンストラクタです。外部からはインスタンス化できません。
		 * @private
		 */
		public function SoundLoopType()
		{
			throw new Error("This class is static.");
		}

	}
}
