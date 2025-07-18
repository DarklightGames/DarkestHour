//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMidGameVoiceChat extends ROUT2K4Tab_MidGameVoiceChat;

defaultproperties
{
    Begin Object Class=moCheckBox Name=NoSpeech
        WinWidth=0.338524
        WinHeight=0.049840
        WinLeft=0.647884
        WinTop=0.685424
        Caption="Ignore Voice Commands"
        Hint="Do not receive any voice commands, such as 'Take cover!' from this player"
        OnChange=InternalOnChange
        TabOrder=3
        MenuState=MSAT_Disabled
    End Object
    ch_NoSpeech=NoSpeech
}
