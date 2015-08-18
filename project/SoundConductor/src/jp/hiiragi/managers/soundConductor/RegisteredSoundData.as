package jp.hiiragi.managers.soundConductor
{
    import flash.media.Sound;
    import flash.utils.ByteArray;

//--------------------------------------
//  Events
//--------------------------------------

//--------------------------------------
//  Styles
//--------------------------------------

//--------------------------------------
//  Other metadata
//--------------------------------------

    internal class RegisteredSoundData
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
        public function RegisteredSoundData(soundId:SoundId, sound:Sound, soundByteArray:ByteArray, allowMultiple:Boolean, allowInterrupt:Boolean)
        {
            _soundId = soundId;
            _sound = sound;
            _soundByteArray = soundByteArray;
            _allowMultiple = allowMultiple;
            _allowInterrupt = allowInterrupt;
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
        //  propertyName
        //----------------------------------
        private var _soundId:SoundId;

        public function get soundId():SoundId
        {
            return _soundId;
        }

        private var _sound:Sound;

        public function get sound():Sound
        {
            return _sound;
        }

        private var _soundByteArray:ByteArray;

        public function get soundByteArray():ByteArray
        {
            return _soundByteArray;
        }


        private var _allowMultiple:Boolean;

        public function get allowMultiple():Boolean
        {
            return _allowMultiple;
        }

        private var _allowInterrupt:Boolean;

        public function get allowInterrupt():Boolean
        {
            return _allowInterrupt;
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