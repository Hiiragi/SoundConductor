package jp.hiiragi.managers.soundConductor
{
	import flash.events.IEventDispatcher;

	internal interface IParameterController extends IEventDispatcher
	{
		function get value():Number;
		function get enabled():Boolean;
		function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void;
		function setEnabled(enabled:Boolean):void;
		function dispose():void;
	}
}
