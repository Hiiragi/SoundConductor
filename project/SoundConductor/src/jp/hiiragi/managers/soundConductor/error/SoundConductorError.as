package jp.hiiragi.managers.soundConductor.error
{

	public class SoundConductorError extends Error
	{

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * @param errorType		エラーの種類を表す <code>SoundConductorErrorType</code> の定数値です。
		 * @param args				メッセージ内に変数があって値を入れる必要がある場合、以降に指定された順番で置換されます。
		 */
		public function SoundConductorError(errorType:SoundConductorErrorType, ... args)
		{
			name = "SoundConductorError";

			var errorMessage:String = "[SoundConductorError #" + errorType.id + " : " + errorType.message + "]";
			var len:int = args.length;
			for (var i:int = 0; i < len; i++)
			{
				var replaceText:String = (args[i] != null) ? args[i].toString() : "null";
				errorMessage = errorMessage.replace(/%%/, replaceText);
			}

			super(errorMessage, errorType.id);
		}

	}
}
