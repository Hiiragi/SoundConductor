package jp.hiiragi.managers.soundConductor.constants
{
	import flash.errors.IllegalOperationError;

	/**
	 * <code>SoundPlayType</code> クラスは、定数値の列挙です。
	 * @author
	 */
	public class SoundPlayType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/**
		 * 通常の <code>Sound</code> を登録し、再生します.
		 * <p><code>SoundConductor</code> 内で通常の <code>Sound</code> オブジェクトを扱うので、挙動は <code>Sound</code> クラスそのものになります。
		 * このため、無限ループの機能は扱うことは出来ません。</p>
		 */
		public static const NORMAL_SOUND_ARCHITECT:SoundPlayType = create("normalSoundArchitect");

		/**
		 * 一つの音源に対して一つの <code>Sound</code> オブジェクトを割り当てて、SoundGenerator 機能を使用して再生します.
		 */
		public static const SINGLE_SOUND_GENERATOR:SoundPlayType = create("singleSoundGenerator");

		/**
		 * 共用の <code>Sound</code> オブジェクトの SoundGenerator 機能を使用して再生します.
		 * <p>共用の SoundGenerator のため、<code>SoundChannel</code> の発音数の上限を考える必要はなくなります。
		 * 但し、PCM の ByteArray を複数保持しておかなければならないためメモリが大量に必要になり、且つ、
		 * 計算して合成を行う必要があるために負荷が高いため、この共用の SoundGenerator において大量のサウンドを扱うことはお勧めしません。</p>
		 */
		public static const SHARED_SOUND_GENERATOR:SoundPlayType = create("sharedSoundGenerator");

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
		protected static function create(value:* = null):SoundPlayType
		{
			_isCalledFromInternal = true;
			var instance:SoundPlayType = new SoundPlayType(value);

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
		public function SoundPlayType(value:* = null)
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
			return "[SoundPlayType value=" + _value.toString() + "]";
		}
	}
}
