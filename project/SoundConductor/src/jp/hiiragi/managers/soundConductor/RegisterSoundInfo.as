package jp.hiiragi.managers.soundConductor
{

    public class RegisterSoundInfo
    {

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
        public function RegisterSoundInfo(sound:*, createPCMByteArray:Boolean = false, allowMultiple:Boolean = true, allowInterrupt:Boolean = true)
        {
            _sound = sound;

            _createPCMByteArray = createPCMByteArray;
            _allowMultiple = allowMultiple;
            _allowInterrupt = allowInterrupt;
        }

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------
        //----------------------------------
        //  sound
        //----------------------------------
        private var _sound:*;

        public function get sound():* { return _sound; }

        //----------------------------------
        //  sound
        //----------------------------------
        private var _createPCMByteArray:Boolean = false;

        public function get createPCMByteArray():Boolean { return _createPCMByteArray; }

        //----------------------------------
        //  allowMultiple
        //----------------------------------
        private var _allowMultiple:Boolean = true;

        public function get allowMultiple():Boolean { return _allowMultiple; }

        //----------------------------------
        //  allowInterrupt
        //----------------------------------
        private var _allowInterrupt:Boolean = true;

        public function get allowInterrupt():Boolean { return _allowInterrupt; }

    }
}