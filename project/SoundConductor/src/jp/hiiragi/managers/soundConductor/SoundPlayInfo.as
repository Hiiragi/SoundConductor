package jp.hiiragi.managers.soundConductor
{
	import jp.hiiragi.managers.soundConductor.constants.SoundLoopType;
	import jp.hiiragi.managers.soundConductor.constants.SoundPlayType;


	public class SoundPlayInfo
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function SoundPlayInfo(soundId:SoundId)
		{
			_soundId = soundId;
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  soundId
		//----------------------------------
		private var _soundId:SoundId;

		public function get soundId():SoundId  { return _soundId; }

		//----------------------------------
		//  startTimeByMS
		//----------------------------------
		private var _startTimeByMS:Number = 0;

		public function get startTimeByMS():Number  { return _startTimeByMS; }

		public function set startTimeByMS(value:Number):void  { _startTimeByMS = value; }

		//----------------------------------
		//  loops
		//----------------------------------
		private var _loops:int = SoundLoopType.NO_LOOP;

		public function get loops():int  { return _loops; }

		public function set loops(value:int):void  { _loops = value; }

		//----------------------------------
		//  loopStartTimeByMS
		//----------------------------------
		private var _loopStartTimeByMS:Number = 0;

		public function get loopStartTimeByMS():Number  { return _loopStartTimeByMS; }

		public function set loopStartTimeByMS(value:Number):void  { _loopStartTimeByMS = value; }

		//----------------------------------
		//  loopEndTimeByMS
		//----------------------------------
		private var _loopEndTimeByMS:Number = 0;

		public function get loopEndTimeByMS():Number  { return _loopEndTimeByMS; }

		public function set loopEndTimeByMS(value:Number):void  { _loopEndTimeByMS = value; }

		//----------------------------------
		//  groupName
		//----------------------------------
		private var _groupName:String = "";

		public function get groupName():String  { return _groupName; }

		public function set groupName(value:String):void  { _groupName = value; }

		//----------------------------------
		//  volume
		//----------------------------------
		private var _volume:Number = 1;

		public function get volume():Number  { return _volume; }

		public function set volume(value:Number):void  { _volume = value; }

		//----------------------------------
		//  pan
		//----------------------------------
		private var _pan:Number = 0;

		public function get pan():Number  { return _pan; }

		public function set pan(value:Number):void  { _pan = value; }

		//----------------------------------
		//  soundPlayType
		//----------------------------------
		private var _soundPlayType:SoundPlayType = SoundPlayType.NORMAL_SOUND_ARCHITECT;

		public function get soundPlayType():SoundPlayType  { return _soundPlayType; }

		public function set soundPlayType(value:SoundPlayType):void  { _soundPlayType = value; }

		//----------------------------------
		//  weakReference
		//----------------------------------
		private var _weakReference:Boolean = false;

		public function get weakReference():Boolean  { return _weakReference; }

		public function set weakReference(value:Boolean):void  { _weakReference = value; }

	}
}

