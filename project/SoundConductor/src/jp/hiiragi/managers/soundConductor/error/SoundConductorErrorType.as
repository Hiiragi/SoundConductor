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

package jp.hiiragi.managers.soundConductor.error
{


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

		/** このクラスは、外部からはインスタンス化出来ません。 */
		public static const ERROR_10003:SoundConductorErrorType = create(10003, "このクラスは、外部からはインスタンス化出来ません。");

		/** このクラスを使用するには初期化を行う必要が有ります。 */
		public static const ERROR_10010:SoundConductorErrorType = create(10010, "このクラスを使用するには初期化を行う必要が有ります。");

		/** このクラスは既に初期化されています。 */
		public static const ERROR_10011:SoundConductorErrorType = create(10011, "このクラスは既に初期化されています。");

		/** このメソッドは、抽象メソッドとして設計されています。サブクラスにてオーバーライドして使用してください。 */
		public static const ERROR_10020:SoundConductorErrorType = create(10020, "このメソッドは、抽象メソッドとして設計されています。サブクラスにてオーバーライドして使用してください。 ");


		/** 指定されたリンケージ名は存在しません。 */
		public static const ERROR_10100:SoundConductorErrorType = create(10100, "指定されたリンケージ名は存在しません。");

		/** 指定されたリンケージ名は Sound クラスではありません。 */
		public static const ERROR_10101:SoundConductorErrorType = create(10101, "指定されたリンケージ名は Sound クラスではありません。");

		/** 指定されたクラスは Sound クラスではありません。 */
		public static const ERROR_10102:SoundConductorErrorType = create(10102, "指定されたクラスは Sound クラスではありません。");

		/** Sound を登録するには、リンケージ名か Class クラス、あるいは Sound オブジェクトを指定する必要が有ります。 */
		public static const ERROR_10103:SoundConductorErrorType = create(10103, '指定された音源は対応していません。指定できる音源は、 "リンケージの文字列"、"Soundクラスを拡張した音源クラス"、"Sound オブジェクト"、"PCM の ByteArray" です。');

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

		/** 指定されたサウンドは複数再生不可であり、割り込み不可の設定になっているため、再生できません。 */
		public static const ERROR_10204:SoundConductorErrorType = create(10204, "指定されたサウンドは複数再生不可であり、割り込み不可の設定になっているため、再生できません。");

		/** Ogg Vorbis は SoundPlayType.NORMAL_SOUND_ARCHITECT では再生できません。 */
		public static const ERROR_10205:SoundConductorErrorType = create(10205, "Ogg Vorbis は SoundPlayType.NORMAL_SOUND_ARCHITECT では再生できません。");
		
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
		 * @private
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
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10002);
			}
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  id
		//----------------------------------
		private var _id:int;

		/**
		 * エラーの ID を取得します.
		 * @return
		 */
		public function get id():int  { return _id; }

		//----------------------------------
		//  message
		//----------------------------------
		private var _message:String;

		/**
		 * エラーメッセージを取得します.
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
