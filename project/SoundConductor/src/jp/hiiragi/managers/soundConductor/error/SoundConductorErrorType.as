package jp.hiiragi.managers.soundConductor.error
{
	import flash.errors.IllegalOperationError;

	/**
	 * <code>SoundConductorErrorType</code> クラスは、定数値の列挙です。
	 * @author
	 */
	public class SoundConductorErrorType
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		/** このクラスは抽象クラスとして設計されている為、インスタンス化出来ません。 */
		public static const ERROR_10000:SoundConductorErrorType = create(10000, "このクラスは抽象クラスとして設計されている為、インスタンス化出来ません。");

		/** このクラスは静的クラスとして設計されている為、インスタンス化出来ません。 */
		public static const ERROR_10001:SoundConductorErrorType = create(10001, "このクラスは静的クラスとして設計されている為、インスタンス化出来ません。");

		/** このクラスは Enum クラスとして設計されている為、インスタンス化出来ません。 */
		public static const ERROR_10002:SoundConductorErrorType = create(10002, "このクラスは Enum クラスとして設計されている為、インスタンス化出来ません。");



		/** このクラスを使用するには初期化を行う必要が有ります。 */
		public static const ERROR_10010:SoundConductorErrorType = create(10010, "このクラスを使用するには初期化を行う必要が有ります。");

		/** このメソッドは、抽象メソッドとして設計されています。サブクラスにてオーバーライドして使用してください。 */
		public static const ERROR_10020:SoundConductorErrorType = create(10020, "このメソッドは、抽象メソッドとして設計されています。サブクラスにてオーバーライドして使用してください。 ");


		/** 指定されたリンケージ名は存在しません。 */
		public static const ERROR_10100:SoundConductorErrorType = create(10100, "指定されたリンケージ名は存在しません。");

		/** 指定されたリンケージ名は Sound クラスではありません。 */
		public static const ERROR_10101:SoundConductorErrorType = create(10101, "指定されたリンケージ名は Sound クラスではありません。");

		/** 指定されたクラスは Sound クラスではありません。 */
		public static const ERROR_10102:SoundConductorErrorType = create(10102, "指定されたクラスは Sound クラスではありません。");

		/** Sound を登録するには、リンケージ名か Class クラス、あるいは Sound オブジェクトを指定する必要が有ります。 */
		public static const ERROR_10103:SoundConductorErrorType = create(10103, "Sound を登録するには、リンケージ名か Class クラス、あるいは Sound オブジェクトを指定する必要が有ります。");

		/** 指定された SoundId は登録されていません。 */
		public static const ERROR_10110:SoundConductorErrorType = create(10110, "指定された SoundId は登録されていません。");


		/** サウンドチャンネルに空きがないため、サウンドを再生できません。 */
		public static const ERROR_10200:SoundConductorErrorType = create(10200, "サウンドチャンネルに空きがないため、サウンドを再生できません。");

		/** コントローラは無効状態です。 */
		public static const ERROR_10201:SoundConductorErrorType = create(10201, "コントローラは無効状態です。");

		/** useSharedSoundGenerator プロパティは false です。SoundPlayType.SHARED_SOUND_GENERATOR での再生は出来ません。 */
		public static const ERROR_10202:SoundConductorErrorType = create(10202, "useSharedSoundGenerator プロパティは false です。SoundPlayType.SHARED_SOUND_GENERATOR での再生は出来ません。");

		/** 指定されたオブジェクトには soundTransform プロパティが存在しません。 */
		public static const ERROR_10203:SoundConductorErrorType = create(10203, "指定されたオブジェクトには soundTransform プロパティが存在しません。");


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
		protected static function create(id:int, message:String):SoundConductorErrorType
		{
			_isCalledFromInternal = true;
			var instance:SoundConductorErrorType = new SoundConductorErrorType(id, message);

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
		public function SoundConductorErrorType(id:int, message:String)
		{
			if (_isCalledFromInternal)
			{
				_id = id;
				_message = message;
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
		private var _id:int;

		/**
		 * Enumの値を取得します。
		 * @return
		 */
		public function get id():int  { return _id; }

		//----------------------------------
		//  value
		//----------------------------------
		private var _message:String;

		/**
		 *
		 * @return
		 */
		public function get message():String  { return _message; }

//--------------------------------------------------------------------------
//
//   Public methods
//
//--------------------------------------------------------------------------
		public function toString():String
		{
			return "[SoundConductorErrorType id=" + id.toString() + ", message=" + message + "]";
		}
	}
}
