package jp.hiiragi.managers.soundConductor.events
{
	import flash.events.Event;


	public class OggDecodeEvent extends Event
	{
//--------------------------------------------------------------------------
//
//  Class constants
//
//--------------------------------------------------------------------------

		public static const PROGRESS:String = "progress";

		public static const COMPLETE:String = "complete";

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
		public function OggDecodeEvent(type:String, decoded:Number, total:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_decoded = decoded;
			_total = total;

			super(type, bubbles, cancelable);
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  decoded
		//----------------------------------
		private var _decoded:Number;

		public function get decoded():Number  { return _decoded; }

		//----------------------------------
		//  total
		//----------------------------------
		private var _total:Number;

		public function get total():Number  { return _total; }

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

		override public function clone():Event
		{
			return new OggDecodeEvent(type, decoded, total, bubbles, cancelable);
		}

		override public function toString():String
		{
			return formatToString("OggDecodeEvent", "type", "decoded", "total", "bubbles", "cancelable");
		}


	}
}

