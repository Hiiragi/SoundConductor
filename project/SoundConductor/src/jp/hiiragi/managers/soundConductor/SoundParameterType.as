package jp.hiiragi.managers.soundConductor
{
	import flash.errors.IllegalOperationError;

	/**
	 * <code>SoundParameterType</code> クラスは、定数値の列挙です。
	 * @author
	 */
	internal class SoundParameterType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** サウンドのボリュームを示します. */
		public static const VOLUME:SoundParameterType = create("volume");

		/** サウンドの定位を示します. */
		public static const PAN:SoundParameterType = create("pan");

//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		private static var _isCalledFromInternal:Boolean = false;

//--------------------------------------------------------------------------
//
//  Class Public methods
//
//--------------------------------------------------------------------------
		/**
		 * 内部で定数を列挙する際のファクトリーメソッドです。
		 * @param value Enum値です。
		 * @return
		 */
		protected static function create(value:* = null):SoundParameterType
		{
			_isCalledFromInternal = true;
			var instance:SoundParameterType = new SoundParameterType(value);

			return instance;
		}

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		/**
		 * コンストラクタです。外部からはインスタンス化できません。
		 * @param value Enum値です。
		 * @private
		 */
		public function SoundParameterType(value:* = null)
		{
			if (_isCalledFromInternal)
			{
				_value = value || "";
				_isCalledFromInternal = false;
			}
			else
			{
				throw new IllegalOperationError("This class is emurated Enum.");
			}
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		private var _value:*;

		/**
		 * Enumの値を取得します。
		 * @return
		 */
		public function get value():*  { return _value; }

//--------------------------------------------------------------------------
//
//   Public methods
//
//--------------------------------------------------------------------------
		public function toString():String
		{
			return "[SoundParameterType value=" + _value.toString() + "]";
		}
	}
}
