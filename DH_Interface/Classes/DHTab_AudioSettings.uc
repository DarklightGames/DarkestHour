//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_AudioSettings extends ROTab_AudioSettings;

var automated moNumericEdit     nu_AudioChannels;

var int                         NumberOfChannels;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    i_BG1.ManageComponent(nu_AudioChannels);

    i_BG3.UnmanageComponent(co_Quality);
    i_BG3.UnmanageComponent(co_LANQuality);

    RemoveComponent(co_Quality);
    RemoveComponent(co_LANQuality);
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    switch (Sender)
    {
        case nu_AudioChannels:
            NumberOfChannels = int(PlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Channels"));
            nu_AudioChannels.SetComponentValue(NumberOfChannels, true);
            break;

        default:
            super.InternalOnLoadINI(Sender, s); // no need to call the Super if the passed GUIComponent is the option above
    }
}

function InternalOnChange(GUIComponent Sender)
{
    super.InternalOnChange(Sender);

    switch (Sender)
    {
        case nu_AudioChannels:
            NumberOfChannels = nu_AudioChannels.GetValue();
            PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Channels" @ NumberOfChannels);
            //PlayerOwner().ConsoleCommand("SetMusicVolume"@fMusic);
            break;
    }
}

function SaveSettings()
{
    if (NumberOfChannels != nu_AudioChannels.GetValue())
    {
        PlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Channels" @ NumberOfChannels);
    }

    super.SaveSettings();
}

defaultproperties
{
    Begin Object Class=DHGUISectionBackground Name=AudioBK1
        Caption="Sound System"
        WinTop=0.1
        WinLeft=0.000948
        WinWidth=0.485
        WinHeight=0.7
        OnPreDraw=AudioBK1.InternalPreDraw
    End Object
    i_BG1=DHGUISectionBackground'DH_Interface.DHTab_AudioSettings.AudioBK1'

    Begin Object Class=DHGUISectionBackground Name=AudioBK3
        Caption="Voice Chat"
        WinTop=0.1
        WinLeft=0.495826
        WinWidth=0.502751
        WinHeight=0.633059
        OnPreDraw=AudioBK3.InternalPreDraw
    End Object
    i_BG3=DHGUISectionBackground'DH_Interface.DHTab_AudioSettings.AudioBK3'

    Begin Object Class=moSlider Name=AudioMusicVolume
        MaxValue=1.0
        Caption="Music Volume"
        LabelStyleName="DHLargeText"
        OnCreateComponent=AudioMusicVolume.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.5"
        WinTop=0.070522
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=2
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    sl_MusicVol=moSlider'DH_Interface.DHTab_AudioSettings.AudioMusicVolume'

    Begin Object Class=moSlider Name=AudioEffectsVolumeSlider
        MaxValue=1.0
        Caption="Effects Volume"
        LabelStyleName="DHLargeText"
        OnCreateComponent=AudioEffectsVolumeSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.9"
        WinTop=0.070522
        WinLeft=0.524024
        WinWidth=0.45
        TabOrder=1
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    sl_EffectsVol=moSlider'DH_Interface.DHTab_AudioSettings.AudioEffectsVolumeSlider'

    Begin Object Class=moSlider Name=VoiceVolume
        MaxValue=1.0
        MinValue=0.0
        Caption="Voice Receive Volume"
        LabelStyleName="DHLargeText"
        OnCreateComponent=VoiceVolume.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.142484
        WinLeft=0.518507
        WinWidth=0.408907
        RenderWeight=1.04
        TabOrder=3
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    sl_VOIP=moSlider'DH_Interface.DHTab_AudioSettings.VoiceVolume'

    Begin Object Class=DHmoComboBox Name=AudioMode
        bReadOnly=true
        Caption="Audio Mode"
        OnCreateComponent=AudioMode.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Software 3D Audio"
        WinTop=0.149739
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=4
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    co_Mode=DHmoComboBox'DH_Interface.DHTab_AudioSettings.AudioMode'

    Begin Object Class=DHmoComboBox Name=AudioPlayVoices
        bReadOnly=true
        Caption="Play Voice Messages"
        OnCreateComponent=AudioPlayVoices.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="All"
        WinTop=0.149739
        WinLeft=0.524024
        WinWidth=0.45
        TabOrder=8
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    co_Voices=DHmoComboBox'DH_Interface.DHTab_AudioSettings.AudioPlayVoices'

    Begin Object Class=DHmoCheckBox Name=AudioReverseStereo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Reverse Stereo"
        OnCreateComponent=AudioReverseStereo.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.405678
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=7
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_ReverseStereo=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AudioReverseStereo'

    Begin Object Class=DHmoCheckBox Name=AudioMessageBeep
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Message Beep"
        OnCreateComponent=AudioMessageBeep.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.405678
        WinLeft=0.524024
        WinWidth=0.45
        TabOrder=9
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_MessageBeep=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AudioMessageBeep'

    Begin Object Class=DHmoCheckBox Name=DisableGameMusic
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Disable Music During Gameplay"
        OnCreateComponent=DisableGameMusic.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.235052
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=10
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_DisableGameMusic=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.DisableGameMusic'

    Begin Object Class=DHmoCheckBox Name=AudioLowDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="Low Sound Detail"
        OnCreateComponent=AudioLowDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.235052
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=5
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_LowDetail=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AudioLowDetail'

    Begin Object Class=DHmoCheckBox Name=AudioDefaultDriver
        ComponentJustification=TXTA_Left
        CaptionWidth=0.94
        Caption="System Driver"
        OnCreateComponent=AudioDefaultDriver.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.320365
        WinLeft=0.018164
        WinWidth=0.45
        TabOrder=6
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_Default=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AudioDefaultDriver'

    Begin Object Class=DHmoCheckBox Name=EnableVoiceChat
        CaptionWidth=-1.0
        Caption="Enable Voice Chat"
        OnCreateComponent=EnableVoiceChat.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.834777
        WinLeft=0.527734
        WinWidth=0.461134
        TabOrder=20
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_VoiceChat=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.EnableVoiceChat'

    Begin Object Class=DHmoCheckBox Name=AutoJoinPublic
        CaptionWidth=0.94
        Caption="Autojoin Public Channel"
        OnCreateComponent=AutoJoinPublic.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.145784
        WinLeft=0.08628
        WinWidth=0.826652
        TabOrder=23
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_AJPublic=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AutoJoinPublic'

    Begin Object Class=DHmoCheckBox Name=AutoSpeakCheckbox
        Caption="Auto-select Active Channel"
        OnCreateComponent=AutoSpeakCheckbox.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.603526
        WinLeft=0.039812
        WinWidth=0.442638
        WinHeight=0.06
        TabOrder=24
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_AutoSpeak=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.AutoSpeakCheckbox'

    Begin Object Class=DHmoCheckBox Name=Dampen
        CaptionWidth=0.94
        Caption="Dampen Game Volume When Using VOIP"
        OnCreateComponent=Dampen.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.145784
        WinLeft=0.08628
        WinWidth=0.826652
        TabOrder=21
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ch_Dampen=DHmoCheckBox'DH_Interface.DHTab_AudioSettings.Dampen'

    Begin Object Class=DHmoEditBox Name=DefaultActiveChannelEditBox
        CaptionWidth=0.6
        Caption="Default Channel Name"
        OnCreateComponent=DefaultActiveChannelEditBox.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.757277
        WinLeft=0.032569
        WinWidth=0.420403
        TabOrder=25
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ed_Active=DHmoEditBox'DH_Interface.DHTab_AudioSettings.DefaultActiveChannelEditBox'

    Begin Object Class=DHmoEditBox Name=ChatPasswordEdit
        CaptionWidth=0.6
        Caption="Chat Password"
        OnCreateComponent=ChatPasswordEdit.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.332828
        WinLeft=0.032569
        WinWidth=0.420403
        TabOrder=26
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    ed_ChatPassword=DHmoEditBox'DH_Interface.DHTab_AudioSettings.ChatPasswordEdit'

    Begin Object Class=DHmoComboBox Name=VoiceQuality
        bReadOnly=true
        CaptionWidth=0.6
        Caption="Internet Quality"
        OnCreateComponent=VoiceQuality.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.241391
        WinLeft=0.52339
        WinWidth=0.408907
        TabOrder=27
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    co_Quality=DHmoComboBox'DH_Interface.DHTab_AudioSettings.VoiceQuality'

    Begin Object Class=DHmoComboBox Name=VoiceQualityLAN
        bReadOnly=true
        CaptionWidth=0.6
        Caption="LAN Quality"
        OnCreateComponent=VoiceQualityLAN.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.333786
        WinLeft=0.52339
        WinWidth=0.408907
        TabOrder=28
        OnChange=DHTab_AudioSettings.InternalOnChange
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
    End Object
    co_LANQuality=DHmoComboBox'DH_Interface.DHTab_AudioSettings.VoiceQualityLAN'

    Begin Object class=DHmoNumericEdit Name=AudioChannelsNum
        WinWidth=0.381250
        WinLeft=0.550781
        WinTop=0.196875
        Caption="Max Audio Channels"
        CaptionWidth=0.7
        OnCreateComponent=AudioChannelsNum.InternalOnCreateComponent
        MinValue=16
        MaxValue=128
        Step=16
        ComponentJustification=TXTA_Left
        Hint="Number of sound channels the game can use at once"
        OnLoadINI=DHTab_AudioSettings.InternalOnLoadINI
        OnChange=DHTab_AudioSettings.InternalOnChange
        INIOption="@Internal"
        bAutoSizeCaption=true
        TabOrder=29
    End Object
    nu_AudioChannels=AudioChannelsNum
}
