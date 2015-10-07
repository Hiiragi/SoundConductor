package jp.hiiragi.managers.soundConductor
{
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
	 * サウンドのグループ用コントローラクラスです.
	 */
	public class SoundGroupController
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
		//----------------------------------
		//  valiableName
		//----------------------------------
		private static var _isCalledFromInternal:Boolean = false;

//--------------------------------------------------------------------------
//
//  Class properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

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

//--------------------------------------------------------------------------
//
//  Class Internal methods
//
//--------------------------------------------------------------------------

		internal static function createController(groupName:String):SoundGroupController
		{
			_isCalledFromInternal = true;
			var controller:SoundGroupController = new SoundGroupController(groupName);

			return controller;
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

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		/**
		 * コンストラクタです.
		 * <p>外部からのインスタンス化は出来ません。</p>
		 * @param groupName
		 * @private
		 */
		public function SoundGroupController(groupName:String)
		{
			if (_isCalledFromInternal)
			{
				_isMute = false;

				_groupName = groupName;
				_groupVolumeController = new ParameterController(1);
				_soundControllerList = new Vector.<SoundController>();

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
		private var _soundControllerList:Vector.<SoundController>;

//--------------------------------------------------------------------------
//
//  Overridden properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  groupName
		//----------------------------------
		private var _groupName:String;

		public function get groupName():String  { return _groupName; }

		//----------------------------------
		//  isMute
		//----------------------------------
		private var _isMute:Boolean;

		public function get isMute():Boolean  { return _isMute; }

		//----------------------------------
		//  groupVolumeController
		//----------------------------------
		private var _groupVolumeController:ParameterController;

		internal function get groupVolumeController():ParameterController  { return _groupVolumeController; }

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
//  Public methods
//
//--------------------------------------------------------------------------

		/**
		 * グループのボリュームを取得します.
		 * @return
		 */
		public function getVolume():Number
		{
			return groupVolumeController.value;
		}

		/**
		 * グループのボリュームを設定します.
		 * @param volume
		 * @param easingTimeByMS
		 * @param easing
		 */
		public function setVolume(volume:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			groupVolumeController.setValue(volume, easingTimeByMS, easing);
		}

		/**
		 * グループに所属するサウンドの再生を一時停止します.
		 * @param fadeOutTimeByMS
		 * @param fadeOutEasing
		 */
		public function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].pause(fadeOutTimeByMS, fadeOutEasing);
			}
		}

		/**
		 * グループに所属するサウンドの一時停止状態を解除します.
		 * @param fadeInTimeByMS
		 * @param fadeInEasing
		 */
		public function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].resume(fadeInTimeByMS, fadeInEasing);
			}
		}

		/**
		 * グループに所属するサウンドの再生を停止します.
		 * @param fadeOutTimeByMS
		 * @param fadeOutEasing
		 */
		public function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void
		{
			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].stop(fadeOutTimeByMS, fadeOutEasing);
			}
		}

		/**
		 * グループに所属するサウンドをミュートします.
		 */
		public function mute():void
		{
			if (_isMute)
			{
				return;
			}

			_isMute = true;
			_groupVolumeController.setEnabled(false);

			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].muteAtParent();
			}
		}

		/**
		 * グループに所属するサウンドのミュート状態を解除します.
		 */
		public function unmute():void
		{
			if (!_isMute)
			{
				return;
			}

			_isMute = false;
			_groupVolumeController.setEnabled(true);

			var len:int = _soundControllerList.length;
			for (var i:int = 0; i < len; i++)
			{
				_soundControllerList[i].unmuteAtParent();
			}
		}

//--------------------------------------------------------------------------
//
//  Internal methods
//
//--------------------------------------------------------------------------

		internal function addSoundController(soundController:SoundController):void
		{
			_soundControllerList.push(soundController);
			soundController.addEventListener(SoundConductorEvent.STOPPED, soundStoppedHandler);
		}

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

		protected function soundStoppedHandler(event:SoundConductorEvent):void
		{
			var soundController:SoundController = event.soundController;
			var index:int = _soundControllerList.indexOf(soundController);

			soundController.removeEventListener(SoundConductorEvent.STOPPED, soundStoppedHandler);

			_soundControllerList.splice(index, 1);
		}

	}
}



////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ClassName
//
////////////////////////////////////////////////////////////////////////////////
