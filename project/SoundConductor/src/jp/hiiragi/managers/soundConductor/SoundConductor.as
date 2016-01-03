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

package jp.hiiragi.managers.soundConductor
{
	import com.jac.ogg.OggManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	import jp.hiiragi.managers.soundConductor.constants.SoundBufferType;
	import jp.hiiragi.managers.soundConductor.constants.SoundPlayType;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;
	import jp.hiiragi.managers.soundConductor.events.SoundConductorEvent;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	/**
	 * <code>SoundConductor</code> クラスは、様々なサウンドの再生を統括・管理するための静的なクラスです.
	 * <p>このクラスには、以下の機能が実装されています。</p>
	 * <ul>
	 * <li>SoundGenerator 機能を使用した、始点・終点を指定した無限ループ機能</li>
	 * <li>サウンドのグルーピング機能</li>
	 * <li>ボリュームのフェードイン・アウト</li>
	 * <li>「マスターボリューム」「グループボリューム」、そして「音そのもののボリューム」を使用した多段性のボリューム調整機能</li>
	 * <li>ポーズ・リジューム機能</li>
	 * </ul>
	 */
	public class SoundConductor
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class variables
//
//--------------------------------------------------------------------------
		private static var _registeredSoundList:Vector.<RegisteredSoundData>;

		private static var _playingSoundDataList:Vector.<AbstractPlayingData>;

		private static var _groupList:Vector.<SoundGroupController>;

		private static var _applyingFadeSoundChannelList:Vector.<ApplyFadeSoundData>;

		private static var _sharedSoundGeneratorEngine:SoundGeneratorEngine;

		private static var _isInitialized:Boolean;

		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();

//--------------------------------------------------------------------------
//
//  Class properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  soundBufferSize
		//----------------------------------
		private static var _soundBufferSize:SoundBufferType = SoundBufferType.BUFFER_SIZE_8192;

		/**
		 * 初期化の際に指定したサウンドのバッファを保持する量を取得します.
		 * @return 設定された <code>SoundBufferType</code> クラスの定数を返します.
		 */
		public static function get soundBufferSize():SoundBufferType  { return _soundBufferSize; }

		//----------------------------------
		//  useSharedSoundGenerator
		//----------------------------------
		private static var _useSharedSoundGenerator:Boolean;

		/**
		 * 共用の SoundGenerator を使用するかどうかを取得します.
		 * @return
		 */
		public static function get useSharedSoundGenerator():Boolean  { return _useSharedSoundGenerator; }

		//----------------------------------
		//  isMute
		//----------------------------------
		private static var _isMute:Boolean;

		/**
		 * ミュート状態かを取得します.
		 * @return
		 */
		public static function get isMute():Boolean  { return _isMute; }

		//----------------------------------
		//  masterVolumeController
		//----------------------------------
		private static var _masterVolumeController:ParameterController;

		/**
		 * マスターボリュームのコントローラを取得します.
		 * @return
		 */
		internal static function get masterVolumeController():ParameterController  { return _masterVolumeController; }


//--------------------------------------------------------------------------
//
//  Class Service methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Public methods
//
//--------------------------------------------------------------------------

		/**
		 * <code>SoundConductor</code> の初期化を行います.
		 *
		 * <p>使用する際には必ずこのメソッドを実行して初期化してください。</p>
		 *
		 * @param useSharedSoundGenerator	SoundGenerator 機能を使用するかを指定します。
		 * この値を <code>true</code> にすると、サウンド再生方式の種類として <code>SoundPlayType.SINGLE_SOUND_GENERATOR</code> と <code>SoundPlayType.SHARED_SOUND_GENERATOR</code> が使用できるようになります。
		 * デフォルトは <code>false</code> です。
		 *
		 * @param bufferType	 SoundGenerator 機能で扱われるサウンドのバッファを保持する量を設定します。
		 * <code>useSharedSoundGenerator</code> が <code>false</code> の場合、この値を設定する必要はありません。
		 * 設定には <code>SoundBufferType</code> クラスの定数を使用してください。<code>null</code> の場合は、<code>SoundBufferType.BUFFER_SIZE_4096</code> が適用されます。
		 * デフォルトは <code>null</code> です。
		 */
		public static function initialize(useSharedSoundGenerator:Boolean = false, bufferType:SoundBufferType = null):void
		{
			if (_isInitialized)
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10011);

			// 一回ここで OggManager を生成することによって OggManager 全体の初期化が走る
			var oggManager:OggManager = new OggManager();

			_soundBufferSize = bufferType || SoundBufferType.BUFFER_SIZE_4096;
			_useSharedSoundGenerator = useSharedSoundGenerator;

			if (!SoundUtil.checkPlayable())
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10200);
			}

			if (useSharedSoundGenerator)
			{
				_sharedSoundGeneratorEngine = new SoundGeneratorEngine();
			}

			_masterVolumeController = new ParameterController(1, 0, 1);

			_registeredSoundList = new Vector.<RegisteredSoundData>();
			_playingSoundDataList = new Vector.<AbstractPlayingData>();
			_groupList = new Vector.<SoundGroupController>();

			_applyingFadeSoundChannelList = new Vector.<ApplyFadeSoundData>();

			_isInitialized = true;
		}

		/**
		 * <code>SoundConductor</code> の終了処理を行います.
		 */
		public static function finalize():void
		{
			reset();

			if (_sharedSoundGeneratorEngine != null)
			{
				_sharedSoundGeneratorEngine.dispose();
				_sharedSoundGeneratorEngine = null;
			}

			_isInitialized = false;
		}

		/**
		 * <code>Sound</code> オブジェクトを登録します。
		 * @param sound	登録する <code>Sound</code> オブジェクトを指定します。
		 * @param createPCMByteArray	<code>Sound</code> オブジェクトから PCM の <code>ByteArray</code> を生成するかどうかを指定します。
		 * @param allowMultiple	登録した音源を複数同時再生できるかどうかを指定します。
		 * @param allowInterrupt	<code>allowMultiple</code> が <code>false</code> （複数同時再生しない）の場合において、追加で再生をしようとした際に、現在鳴っている音を止めて新しく鳴らすかどうかを指定します。
		 * @return 登録された音に紐付く <code>SoundId</code> オブジェクトです
		 */
		public static function registerSound(sound:Sound, createPCMByteArray:Boolean = false, allowMultiple:Boolean = true, allowInterrupt:Boolean = true):SoundId
		{
			checkInitialize();

			if (!SoundUtil.checkPlayable())
			{
				return null;
			}

			var soundId:SoundId = SoundId.create();
			var soundByteArray:ByteArray;

			if (createPCMByteArray)
			{
				soundByteArray = new ByteArray();
				sound.extract(soundByteArray, sound.length * 44.1);
				soundByteArray.position = 0;
			}

			var registeredSoundData:RegisteredSoundData = new RegisteredSoundData(soundId, sound, soundByteArray, allowMultiple, allowInterrupt);

			_registeredSoundList.push(registeredSoundData);
			return soundId;
		}

		/**
		 * PCM の <code>ByteArray</code> オブジェクトを登録します。
		 * @param sound	PCM の <code>ByteArray</code> オブジェクトを指定します。
		 * @param createSoundObject	PCM の <code>ByteArray</code> オブジェクトから <code>Sound</code> オブジェクトを生成するかどうかを指定します。
		 * @param allowMultiple	登録した音源を複数同時再生できるかどうかを指定します。
		 * @param allowInterrupt	<code>allowMultiple</code> が <code>false</code> （複数同時再生しない）の場合において、追加で再生をしようとした際に、現在鳴っている音を止めて新しく鳴らすかどうかを指定します。
		 * @return 登録された音に紐付く <code>SoundId</code> オブジェクトです
		 */
		public static function registerPCMBinary(pcmBinary:ByteArray, createSoundObject:Boolean = false, allowMultiple:Boolean = true, allowInterrupt:Boolean = true):SoundId
		{
			checkInitialize();

			if (!SoundUtil.checkPlayable())
			{
				return null;
			}

			var soundId:SoundId = SoundId.create();
			var soundByteArray:ByteArray;
			var sound:Sound;

			pcmBinary.position = 0;

			if (createSoundObject)
			{
				sound = new Sound();
				sound.loadPCMFromByteArray(pcmBinary,pcmBinary.bytesAvailable);
			}

			var registeredSoundData:RegisteredSoundData = new RegisteredSoundData(soundId, sound, pcmBinary, allowMultiple, allowInterrupt);

			_registeredSoundList.push(registeredSoundData);
			return soundId;
		}

		/**
		 * 音を登録します。
		 * @param sound	再生する音源を指定します。指定できる音源は、 "リンケージの文字列"、"<code>Sound</code> クラスを継承した音源クラス"です。
		 * @param createPCMByteArray	<code>sound</code> の引数が <code>ByteArray</code> 以外だった場合に、その音源から PCM の <code>ByteArray</code> を生成するかどうかを指定します。
		 * @param allowMultiple	登録した音源を複数同時再生できるかどうかを指定します。
		 * @param allowInterrupt	<code>allowMultiple</code> が <code>false</code> （複数同時再生しない）の場合において、追加で再生をしようとした際に、現在鳴っている音を止めて新しく鳴らすかどうかを指定します。
		 * @return 登録された音に紐付く <code>SoundId</code> オブジェクトです
		 */
		public static function registerSoundClass(soundClass:*, createPCMByteArray:Boolean = false, allowMultiple:Boolean = true, allowInterrupt:Boolean = true):SoundId
		{
			checkInitialize();

			if (!SoundUtil.checkPlayable())
			{
				return null;
			}

			var soundId:SoundId = SoundId.create();
			var soundTarget:Sound;
			var soundByteArray:ByteArray;

			if (soundClass is String && String(soundClass).length > 0)
			{
				var definitionName:String = String(soundClass);
				var definitionClass:Class = getDefinitionByName(definitionName) as Class;
				soundTarget = new definitionClass();

				if (soundTarget == null)
				{
					throw new SoundConductorError(SoundConductorErrorType.ERROR_10100);
				}
				else if (!(soundTarget is Sound))
				{
					throw new SoundConductorError(SoundConductorErrorType.ERROR_10101)
				}
			}
			else if (soundClass is Class)
			{
				soundTarget = new soundClass() as Sound;

				if (soundTarget == null)
				{
					throw new SoundConductorError(SoundConductorErrorType.ERROR_10102);
				}
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10103);
			}

			if (createPCMByteArray)
			{
				soundByteArray = new ByteArray();
				soundTarget.extract(soundByteArray, soundTarget.length * 44.1);
			}

			var registeredSoundData:RegisteredSoundData = new RegisteredSoundData(soundId, soundTarget, soundByteArray, allowMultiple, allowInterrupt);

			_registeredSoundList.push(registeredSoundData);
			return soundId;
		}

		public static function registerOggBinary(oggBinary:ByteArray, allowMultiple:Boolean = true, allowInterrupt:Boolean = true):SoundId
		{
			checkInitialize();

			if (!SoundUtil.checkPlayable())
			{
				return null;
			}

			var soundId:SoundId = SoundId.create();

			var registeredSoundData:RegisteredOggSoundData = new RegisteredOggSoundData(soundId, oggBinary, allowMultiple, allowInterrupt);

			_registeredSoundList.push(registeredSoundData);
			return soundId;
		}

		/**
		 * 登録した音を、登録解除します.
		 * @param soundId
		 */
		public static function unregisteredSound(soundId:SoundId):void
		{
			checkInitialize();

			// TODO : 該当する soundId のサウンドがなっている場合、速攻止める必要が有る。

			// 配列から削除
			var len:int = _registeredSoundList.length;
			for (var i:int = 0; i < len; i++)
			{
				var registeredSoundData:RegisteredSoundData = _registeredSoundList[i];
				if (registeredSoundData.soundId == soundId)
				{
					_registeredSoundList.splice(i, 1);
					registeredSoundData.dispose();
				}
			}
		}

		/**
		 * 音を再生します。
		 * @param playInfo
		 * @param fadeInTimeByMS
		 * @param fadeInEasing
		 * @return
		 */
		public static function play(playInfo:SoundPlayInfo, fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):SoundController
		{
			checkInitialize();

			var len:int;
			var i:int;
			var playingSoundData:AbstractPlayingData

			// SharedSoundGenerator を使わない設定をした上で、その機構を使って鳴らそうとした場合、エラーを出す。
			if (!_useSharedSoundGenerator && playInfo.soundPlayType == SoundPlayType.SHARED_SOUND_GENERATOR)
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10202);
			}

			// サウンドを再生できるかどうか調べる。
			var playable:Boolean = checkPlayable();
			if (!playable)
			{
				return null;
			}


			var registeredSoundData:RegisteredSoundData;

			// 登録されているデータを取り出す
			len = _registeredSoundList.length;
			for (i = 0; i < len; i++)
			{
				if (_registeredSoundList[i].soundId == playInfo.soundId)
				{
					registeredSoundData = _registeredSoundList[i];
					break;
				}
			}

			// 登録されている場合、allowMultiple と allowInterrupt を調べる
			if (registeredSoundData != null)
			{
				// 同時再生不可かどうか
				if (!registeredSoundData.allowMultiple)
				{
					// 現在再生されているかを調べる
					var alreadyPlayingSound:AbstractPlayingData;
					for each (playingSoundData in _playingSoundDataList)
					{
						if (playingSoundData.soundId == playInfo.soundId)
						{
							alreadyPlayingSound = playingSoundData;
							break;
						}
					}

					// 既に同一サウンドが再生されている
					if (alreadyPlayingSound != null)
					{
						// 同時再生不可、且つ、割り込み可であれば、現在再生しているものを停止して、新しく再生
						if (registeredSoundData.allowInterrupt)
						{
							alreadyPlayingSound.stop();
						}
						// 同時再生不可、且つ、割り込み不可であれば、再生しない。（エラー）
						else
						{
							throw new SoundConductorError(SoundConductorErrorType.ERROR_10204);
						}
					}
				}
			}
			// 登録されていない場合はエラー
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10110);
			}

			// Group 抽出
			var groupController:SoundGroupController;
			len = _groupList.length;
			for (i = 0; i < len; i++)
			{
				if (playInfo.groupName == _groupList[i].groupName)
				{
					groupController = _groupList[i];
				}
			}

			if (groupController == null && playInfo.groupName != "")
			{
				groupController = SoundGroupController.createController(playInfo.groupName);
			}


			// PlayingData 作成
			var playingData:AbstractPlayingData;
			if (playInfo.soundPlayType == SoundPlayType.NORMAL_SOUND_ARCHITECT)
			{
				if (registeredSoundData is RegisteredOggSoundData)
				{
					throw new SoundConductorError(SoundConductorErrorType.ERROR_10205);
				}
				
				playingData = new PlayingDataForNormalSound(playInfo, registeredSoundData, groupController);
			}
			else if (playInfo.soundPlayType == SoundPlayType.SINGLE_SOUND_GENERATOR)
			{
				playingData = new PlayingDataForSingleSoundGenerator(playInfo, registeredSoundData, groupController);
			}
			else if (playInfo.soundPlayType == SoundPlayType.SHARED_SOUND_GENERATOR)
			{
				playingData = new PlayingDataForSharedSoundGenerator(playInfo, registeredSoundData, groupController, _sharedSoundGeneratorEngine);
			}

			_playingSoundDataList.push(playingData);

			playingData.addEventListener(SoundConductorEvent.PLAYING, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.PAUSING, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.PAUSED, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.STOPPING, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.STOPPED, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.MUTE, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.UNMUTE, receiveEventFromPlayingData);
			playingData.addEventListener(SoundConductorEvent.LOOP, receiveEventFromPlayingData);

			playingData.play();

			if (fadeInTimeByMS > 0)
			{
				playingData.setVolume(0);
				playingData.setVolume(playInfo.volume, fadeInTimeByMS, fadeInEasing);
			}

			var soundController:SoundController = SoundController.createController(playingData);
			playingData.soundContoller = soundController;

			if (groupController != null)
				groupController.addSoundController(soundController);

			return soundController;
		}

		/**
		 * 再生している音を全て停止します.
		 * @param fadeOutTimeByMS
		 * @param fadeOutEasing
		 */
		public static function stopAll(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			checkInitialize();

			var len:int = _playingSoundDataList.length;
			for (var i:int = 0; i < len; i++)
			{
				_playingSoundDataList[i].stop(fadeOutTimeByMS, fadeOutEasing);
			}
		}


		/**
		 * 全音源をミュートします.
		 * マスターをミュートするため、各音源のミュート設定を変えてもミュート状態のままとなります。
		 */
		public static function muteAll():void
		{
			if (_isMute)
				return;

			_isMute = true;
			_masterVolumeController.setEnabled(false);

			var len:int = _playingSoundDataList.length;
			for (var i:int = 0; i < len; i++)
			{
				_playingSoundDataList[i].muteAtParent();
			}
		}

		/**
		 * 全音源のミュートを解除します.
		 * マスターのミュートを解除するため、各グループ、各音源のミュート設定が反映されます。
		 */
		public static function unmuteAll():void
		{
			if (!_isMute)
				return;

			_isMute = false;
			_masterVolumeController.setEnabled(true);

			var len:int = _playingSoundDataList.length;
			for (var i:int = 0; i < len; i++)
			{
				_playingSoundDataList[i].unmuteAtParent();
			}
		}

		/**
		 * 全ての音源の再生を停止し、登録済みの音源を全て削除します。
		 */
		public static function reset():void
		{
			checkInitialize();

			stopAll(0);
			_registeredSoundList.length = 0;
		}

		/**
		 * <code>Sound</code> オブジェクトを通常の再生方法で再生します.
		 *
		 * <p>このメソッドを通して再生することにより、<code>SoundConductor</code> が管理しているマスターボリュームとグループボリュームの恩恵を得ることが出来ます。
		 * グループを指定した場合、そのグループのミュート状態も適用されます。</p>
		 * <p>ミュート状態はボリュームを <code>0</code> にすることで再現しているため、ミュートの解除はボリュームを上げることで対応する必要が有ります。</p>
		 * @param sound	再生させる <code>Sound</code> オブジェクトです。
		 * @param groupName	適用するグループの文字列です。
		 * @param startTime		再生の始点をミリ秒単位で指定します。
		 * @param loops	ループ回数を指定します。通常のサウンド再生のため、<code>SoundLoopType</code> は使用しません。
		 * @param volume	再生するボリュームを設定します。
		 * @param pan		再生する定位を設定します。
		 * @return 再生した <code>Sound</code> から生成される <code>SoundChannel</code> クラスです。何らかの問題で再生されなかった場合は <code>null</code> が返ります。
		 */
		public static function playSoundObject(sound:Sound, groupName:String = "", startTimeByMS:Number = 0, loops:int = 0, volume:Number = 1, pan:Number = 0):SoundChannel
		{
			var playable:Boolean = checkPlayable();

			if (!playable)
				return null;

			volume *= getMasterVolume();
			volume = applyGroupVolume(volume, groupName);

			var soundChannel:SoundChannel = sound.play(startTimeByMS, loops);
			soundChannel.soundTransform = new SoundTransform(volume, pan);

			return soundChannel;
		}


		/**
		 * <code>Sound</code> オブジェクトに対して、音量のフェードを適用します.
		 *
		 * @param soundChannel	再生している <code>SoundChannel</code> オブジェクトを設定します。
		 * @param fadeTo	<code>0</code> から <code>1</code> の範囲で音量の到達地点を設定します。
		 * @param timeByMS	指定した音量に到達するまでの時間をミリ秒で設定します。
		 * @param easing	フェードのイージングを設定します。<code>null</code> を指定した場合、リニアなイージングが適用されます。指定には、<code>Ease24</code> を使用してください。
		 * デフォルトは <code>null</code> です。
		 * @param callback	フェードが完了した際のコールバック関数を設定します。デフォルトは <code>null</code> です。
		 * @param stopWhenCompleted	フェードが完了したときにサウンドを停止するかを指定します。主にフェードアウトの際に利用します。
		 * デフォルトは <code>false</code> です。
		 */
		public static function applyFadeToSoundObject(soundChannel:SoundChannel, fadeTo:Number, timeByMS:Number, easing:Function = null, callback:Function = null, stopWhenCompleted:Boolean = false):void
		{
			if (fadeTo < 0)
				fadeTo = 0;
			else if (fadeTo > 1)
				fadeTo = 1;

			var controller:SoundParameterController = new SoundParameterController(SoundParameterType.VOLUME, soundChannel, null, null);
			controller.addEventListener(Event.COMPLETE, fadeCompleteHandler);

			var data:ApplyFadeSoundData = new ApplyFadeSoundData(controller, soundChannel, stopWhenCompleted, callback);
			_applyingFadeSoundChannelList.push(data);

			controller.setValue(fadeTo, timeByMS, easing);
		}


//--------------------------------------------------------------------------
//
//  Class Public methods - SoundGroup
//
//--------------------------------------------------------------------------

		/**
		 * 任意の <code>SoundGroupController</code> を登録し、取得します.
		 * @param groupName
		 * @return
		 */
		public static function createGroup(groupName:String):SoundGroupController
		{
			checkInitialize();

			var groupController:SoundGroupController = getGroupController(groupName);

			if (groupController == null)
			{
				groupController = SoundGroupController.createController(groupName);
				_groupList.push(groupController);
			}

			return groupController;
		}

		/**
		 * 登録されている任意の <code>SoundGroupController</code> を、取得します.
		 * @param groupName
		 * @return
		 */
		public static function getGroupController(groupName:String):SoundGroupController
		{
			checkInitialize();

			if (groupName == "")
			{
				return null;
			}

			var len:int = _groupList.length;
			for (var i:int = 0; i < len; i++)
			{
				if (_groupList[i].groupName == groupName)
				{
					return _groupList[i];
				}
			}

			return null;
		}

		/*
		public static function deleteGroup(groupName:String):void
		{
			checkInitialize();

			var len:int = _groupList.length;
			for (var i:int = 0; i < len; i++)
			{
				var groupController:SoundGroupController = _groupList[i];

				if (_groupList[i].groupName == groupName)
				{
					groupController.dispose();
					_groupList.splice(i, 1);
					break;
				}
			}
		}
		*/

//--------------------------------------------------------------------------
//
//  Class Public methods - MasterVolume
//
//--------------------------------------------------------------------------

		/**
		 * マスターボリュームを取得します.
		 * @return
		 */
		public static function getMasterVolume():Number
		{
			checkInitialize();

			return _masterVolumeController.value;
		}

		/**
		 * マスターボリュームを設定します.
		 * @param volume
		 * @param easingTimeByMS
		 * @param easing
		 */
		public static function setMasterVolume(volume:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			checkInitialize();

			masterVolumeController.setValue(volume, easingTimeByMS, easing);
		}

		/**
		 * <code>soundTransform</code> プロパティが存在する指定したオブジェクトにマスターボリュームを適用します.
		 * <p>グループ名を指定した場合、そのグループのボリュームも適用します。</p>
		 * @param object
		 * @param groupName
		 */
		public static function setVolumeToObject(object:*, groupName:String = ""):void
		{
			checkInitialize();

			if (object.hasOwnProperty("soundTransform"))
			{
				var volume:Number = 1;

				volume *= getMasterVolume();
				volume = applyGroupVolume(volume, groupName);

				var soundTransform:SoundTransform = object["soundTransform"];
				var pan:int = soundTransform.pan;

				object["soundTransform"] = new SoundTransform(volume, pan);
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10203);
			}
		}

//--------------------------------------------------------------------------
//
//  Class Public methods - EventDispatcher
//
//--------------------------------------------------------------------------

		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}

		public static function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public static function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

//--------------------------------------------------------------------------
//
//  Class Protected methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Class Private methods
//
//--------------------------------------------------------------------------
		private static function checkInitialize():void
		{
			if (!_isInitialized)
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10010);
		}

		private static function checkPlayable():Boolean
		{
			if (SoundUtil.checkPlayable())
			{
				return true;
			}
			else
			{
				// 空きが無い場合、weak 状態で再生されているサウンドを即停止させる。
				for each (var playingData:AbstractPlayingData in _playingSoundDataList)
				{
					if (playingData.weakReference)
					{
						playingData.stop();
						return true;
					}
				}
			}

			return false;
		}


		/**
		 * 指定グループのボリュームを適用した値を取得します.
		 * @param volume
		 * @param groupName
		 * @return 指定グループのボリュームです。指定グループが無い場合は、何も適用しません。
		 */
		private static function applyGroupVolume(volume:Number, groupName:String = ""):Number
		{
			var groupController:SoundGroupController = getGroupController(groupName);
			if (groupController != null)
			{
				volume *= groupController.getVolume();
			}

			return volume;
		}


//--------------------------------------------------------------------------
//
//  Class Event handlers
//
//--------------------------------------------------------------------------
		protected static function receiveEventFromPlayingData(event:SoundConductorEvent):void
		{
			var playingData:AbstractPlayingData = AbstractPlayingData(event.target);

			if (event.type == SoundConductorEvent.STOPPED)
			{
				playingData.removeEventListener(SoundConductorEvent.PLAYING, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.PAUSING, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.PAUSED, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.STOPPING, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.STOPPED, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.MUTE, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.UNMUTE, receiveEventFromPlayingData);
				playingData.removeEventListener(SoundConductorEvent.LOOP, receiveEventFromPlayingData);

				var index:int = _playingSoundDataList.indexOf(playingData);
				_playingSoundDataList.splice(index, 1);
				playingData.dispose();
			}

			dispatchEvent(event);
		}

		/**
		 * <code>applyFadeToSoundObject</code> を利用した際に、フェード実行完了後に発火するイベントハンドラです.
		 * @param event
		 */
		private static function fadeCompleteHandler(event:Event):void
		{
			var completedController:SoundParameterController = SoundParameterController(event.target);
			completedController.removeEventListener(Event.COMPLETE, fadeCompleteHandler);

			var len:int = _applyingFadeSoundChannelList.length;

			for (var i:int = 0; i < len; i++)
			{
				var data:ApplyFadeSoundData = _applyingFadeSoundChannelList[i];

				if (data.controller == completedController)
				{
					// 停止
					if (data.stopSoundWhenCompleted)
					{
						data.soundChannel.stop();
					}
					// コールバック
					if (data.callback != null)
					{
						data.callback();
					}

					_applyingFadeSoundChannelList.splice(i, 1);
					break;
				}
			}

			completedController.dispose();
		}

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		public function SoundConductor()
		{
			throw new SoundConductorError(SoundConductorErrorType.ERROR_10001);
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
//  Overridden properties
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
		//  valiableName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Service methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------


//--------------------------------------------------------------------------
//
//  Overridden Event handlers
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Event handlers
//
//--------------------------------------------------------------------------

	}
}


////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////


