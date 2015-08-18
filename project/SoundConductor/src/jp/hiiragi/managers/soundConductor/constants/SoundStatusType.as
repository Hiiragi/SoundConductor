package jp.hiiragi.managers.soundConductor.constants
{
	import flash.errors.IllegalOperationError;

	/**
	 * <code>SoundStatusType</code> クラスは、定数値の列挙です。
	 * @author
	 */
	public class SoundStatusType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** 準備中であることを示します. */
		public static const READY:SoundStatusType = create("ready");

		/** 再生中であることを示します. */
		public static const PLAYING:SoundStatusType = create("playing");

		/** 一時停止状態に移行中であることを示します. */
		public static const PAUSING:SoundStatusType = create("pausing");

		/** 一時停止状態であることを示します. */
		public static const PAUSED:SoundStatusType = create("paused");

		/** 停止状態に移行中であることを示します. */
		public static const STOPPING:SoundStatusType = create("stopping");

		/** 停止状態であることを示します. */
		public static const STOPPED:SoundStatusType = create("stopped");

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
		protected static function create(value:* = null):SoundStatusType
		{
			_isCalledFromInternal = true;
			var instance:SoundStatusType = new SoundStatusType(value);

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
		public function SoundStatusType(value:* = null)
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
			return "[SoundStatusType value=" + _value.toString() + "]";
		}
	}
}
