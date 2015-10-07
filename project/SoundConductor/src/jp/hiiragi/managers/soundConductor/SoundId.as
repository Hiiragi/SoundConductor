package jp.hiiragi.managers.soundConductor
{
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

	/**
	 * 登録されたサウンドに紐づく ID オブジェクトです.
	 */
	public class SoundId
	{
//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------
		private static var _isCalledFromInternal:Boolean = false;

//--------------------------------------------------------------------------
//
//  Class Internal methods
//
//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		internal static function create():SoundId
		{
			_isCalledFromInternal = true;
			var soundId:SoundId = new SoundId();

			return soundId;
		}

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * コンストラクタです.
		 * <p>外部からのインスタンス化は出来ません。</p>
		 * @private
		 */
		public function SoundId()
		{
			if (_isCalledFromInternal)
			{
				_isCalledFromInternal = false;
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10003);
			}
		}

//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  valiableName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------


	}
}
