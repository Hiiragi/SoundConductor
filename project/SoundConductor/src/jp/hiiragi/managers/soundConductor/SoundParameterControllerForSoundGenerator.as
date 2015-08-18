package jp.hiiragi.managers.soundConductor
{
	import flash.events.Event;

	import a24.tween.Ease24;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

	public class SoundParameterControllerForSoundGenerator extends AbstractParameterController
	{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

		public function SoundParameterControllerForSoundGenerator(soundParameterType:SoundParameterType, initValue:Number)
		{
			var minValue:Number;
			var maxValue:Number;
			if (soundParameterType == SoundParameterType.VOLUME)
			{
				minValue = 0;
				maxValue = 1;
			}
			else if (soundParameterType == SoundParameterType.PAN)
			{
				minValue = -1;
				maxValue = 1;
			}

			super(initValue, minValue, maxValue);
		}


//--------------------------------------------------------------------------
//
//  Variables
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  tween
		//----------------------------------
		private var _t:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;

		private var _tweening:Boolean;

		private var _easing:Function;

		//----------------------------------
		//  valiableName
		//----------------------------------
		private var _targetValue:Number;


//--------------------------------------------------------------------------
//
//  Overridden properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  value
		//----------------------------------
		override public function get value():Number
		{
			var value:Number = super.value;

			if (_tweening)
			{
				// 次の値を計算
				value = _easing(_t++, _b, _c, _d);
				if (_t == _d)
				{
					setValue_internal(_targetValue);
					_tweening = false;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}

			return value;
		}

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
		//----------------------------------
		//  propertyName
		//----------------------------------

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

		override public function setValue(value:Number, easingTimeByMS:Number = 0, easing:Function = null):void
		{
			value = applyLimitter(value);

			if (!_tweening && value == this.value)
			{
				// 値は変わらないので、何もしない
			}
			else
			{
				if (easingTimeByMS <= 0)
				{
					// 即時
					setValue_internal(value);
					valueChanged();
					dispatchEvent(new Event(Event.CHANGE));
				}
				else
				{
					_b = this.value;
					_c = value - this.value;
					_t = 0;
					_d = Math.floor(easingTimeByMS * 44.1);
					_easing = easing || Ease24._Linear;
					_targetValue = value;
					_tweening = true;
				}
			}
		}

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
