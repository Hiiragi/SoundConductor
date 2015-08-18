package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import jp.hiiragi.managers.soundConductor.error.SoundConductorError;
	import jp.hiiragi.managers.soundConductor.error.SoundConductorErrorType;

//--------------------------------------
//  Events
//--------------------------------------
	[Event(name = "change", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	public class AbstractParameterController extends EventDispatcher implements IParameterController
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
		public function AbstractParameterController(initValue:Number, minValue:Number = 0, maxValue:Number = 1)
		{
			if (this["constructor"] != AbstractParameterController)
			{
				_minValue = minValue;
				_maxValue = maxValue;
				_value = initValue;

				_enabled = true;
				_value = applyLimitter(_value);
			}
			else
			{
				throw new SoundConductorError(SoundConductorErrorType.ERROR_10000);
			}
		}

		public function dispose():void
		{
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
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		private var _value:Number = 0;

		public function get value():Number
		{
			if (!_enabled)
			{
				return 0;
			}

			return _value;
		}

		//----------------------------------
		//  minValue
		//----------------------------------
		private var _minValue:Number;

		public function get minValue():Number
		{
			return _minValue;
		}

		//----------------------------------
		//  maxValue
		//----------------------------------
		private var _maxValue:Number;

		public function get maxValue():Number
		{
			return _maxValue;
		}


		//----------------------------------
		//  enabled
		//----------------------------------
		private var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
		}


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



		public function setEnabled(enabled:Boolean):void
		{
			if (_enabled == enabled)
			{
				return;
			}

			_enabled = enabled;
			valueChanged();
		}

		public function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			throw new SoundConductorError(SoundConductorErrorType.ERROR_10020);
		}


//--------------------------------------------------------------------------
//
//  Protected methods
//
//--------------------------------------------------------------------------
		protected function applyLimitter(value:Number):Number
		{
			if (value < _minValue)
				value = _minValue;
			else if (value > _maxValue)
				value = _maxValue;

			return value;
		}

		protected function valueChanged():void
		{

		}

		protected final function getValue_internal():Number
		{
			return _value;
		}

		protected final function setValue_internal(value:Number):void
		{
			_value = value;
		}

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
