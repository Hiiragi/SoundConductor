package jp.hiiragi.managers.soundConductor.constants
{
	import flash.errors.IllegalOperationError;

	/**
	 * <code>SoundBufferType</code> クラスは、SoundGenerator 機能で扱うバッファ値に関する定数値の列挙です。
	 * @author
	 */
	public class SoundBufferType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** サウンドのバッファ <code>8192</code> を示します。*/
		public static const BUFFER_SIZE_8192:SoundBufferType = create(8192);
		/** サウンドのバッファ <code>4096</code> を示します。*/
		public static const BUFFER_SIZE_4096:SoundBufferType = create(4096);
		/** サウンドのバッファ <code>2048</code> を示します。*/
		public static const BUFFER_SIZE_2048:SoundBufferType = create(2048);

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
		protected static function create(value:* = null):SoundBufferType
		{
			_isCalledFromInternal = true;
			var instance:SoundBufferType = new SoundBufferType(value);

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
		public function SoundBufferType(value:* = null)
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
			return "[SoundBufferType value=" + _value.toString() + "]";
		}
	}
}
