package jp.hiiragi.managers.soundConductor
{

	internal interface ISoundController
	{
		function seek(timeByMS:Number):void;
		function pause(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void;
		function resume(fadeInTimeByMS:Number = 0, fadeInEasing:Function = null):void;
		function stop(fadeOutTimeByMS:Number = 0, fadeOutEasing:Function = null):void;
		function setVolume(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void;
		function getVolume():Number;
		function setPan(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void;
		function getPan():Number;
		function mute():void;
		function unmute():void;
	}
}
