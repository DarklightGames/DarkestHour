//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHTab_DetailSettings extends ROTab_DetailSettings;

//Overrided to remove extra options for scope detail
function MyGetComboOptions(moComboBox Combo, out array<GUIListElem> Ar)
{
    local int i;

    Ar.Remove(0, Ar.Length);
    if (Combo == None)
        return;

    switch (Combo)
    {
        case co_GlobalDetails:
            for (i = 0; i < arraycount(DetailOptions); i++)
            {
                Ar.Length = Ar.Length + 1;
                Ar[i].Item = DetailOptions[i];
            }
            break;

        case co_ScopeDetail:
            Ar.Length = Ar.Length + 1;
            Ar[i].Item = ScopeLevels[0];
            break;
    }

    if (Ar.length == 0)
        GetComboOptions(Combo, Ar);
}

defaultproperties
{
    ScopeLevels(0)="Textured"
    DisplayModes(0)=(Width=1280,Height=720)
    DisplayModes(1)=(Width=1024,Height=768)
    DisplayModes(2)=(Width=1280,Height=768)
    DisplayModes(3)=(Width=1360,Height=768)
    DisplayModes(4)=(Width=1366,Height=768)
    DisplayModes(5)=(Width=1280,Height=800)
    DisplayModes(6)=(Width=1152,Height=864)
    DisplayModes(7)=(Width=1536,Height=864)
    DisplayModes(8)=(Width=1440,Height=900)
    DisplayModes(9)=(Width=1600,Height=900)
    DisplayModes(10)=(Width=1280,Height=960)
    DisplayModes(11)=(Width=1280,Height=1024)
    DisplayModes(12)=(Width=1680,Height=1050)
    DisplayModes(13)=(Width=1920,Height=1080)
    DisplayModes(14)=(Width=1600,Height=1200)
    DisplayModes(15)=(Width=1920,Height=1200)
    DisplayModes(16)=(Width=2560,Height=1440)
    Begin Object Class=DHmoComboBox Name=GlobalDetails
        ComponentJustification=TXTA_Left
        CaptionWidth=0.550000
        Caption="Game details"
        OnCreateComponent=GlobalDetails.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Higher"
        WinTop=0.063021
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_GlobalDetails=DHmoComboBox'DH_Interface.DHTab_DetailSettings.GlobalDetails'
    Begin Object Class=DHmoComboBox Name=ScopeDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Scope Detail"
        OnCreateComponent=ScopeDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Textured"
        WinTop=0.063021
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=9
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_ScopeDetail=DHmoComboBox'DH_Interface.DHTab_DetailSettings.ScopeDetail'
    Begin Object Class=DHmoCheckBox Name=HDRCheckbox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="HDR Bloom"
        OnCreateComponent=HDRCheckbox.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_HDR=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.HDRCheckbox'
    Begin Object Class=DHmoCheckBox Name=Advanced
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Show Advanced Options"
        OnCreateComponent=Advanced.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Advanced=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.Advanced'
    Begin Object Class=DHmoCheckBox Name=MotionBlur
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Motion Blur"
        OnCreateComponent=MotionBlur.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_MotionBlur=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.MotionBlur'
    Begin Object Class=DHGUISectionBackground Name=sbSection1
        Caption="Resolution"
        WinTop=0.004000
        WinLeft=0.022000
        WinWidth=0.485000
        WinHeight=0.540729
        RenderWeight=0.010000
        OnPreDraw=sbSection1.InternalPreDraw
    End Object
    sb_Section1=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection1'
    Begin Object Class=DHGUISectionBackground Name=sbSection2
        Caption="Options"
        WinTop=0.004000
        WinLeft=0.530000
        WinWidth=0.452751
        WinHeight=0.875228
        RenderWeight=0.010000
        OnPreDraw=sbSection2.InternalPreDraw
    End Object
    sb_Section2=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection2'
    Begin Object Class=DHGUISectionBackground Name=sbSection3
        bFillClient=true
        Caption="Gamma Test"
        ImageOffset(3)=10.000000
        WinTop=0.562000
        WinLeft=0.022000
        WinWidth=0.485000
        WinHeight=0.411928
        RenderWeight=0.010000
        OnPreDraw=sbSection3.InternalPreDraw
    End Object
    sb_Section3=DHGUISectionBackground'DH_Interface.DHTab_DetailSettings.sbSection3'
    Begin Object Class=GUIImage Name=GammaBar
        Image=texture'DH_GUI_Tex.Menu.DHGammaSet'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Normal
        OnChange=DHTab_DetailSettings.InternalOnChange
    End Object
    i_GammaBar=GUIImage'DH_Interface.DHTab_DetailSettings.GammaBar'
    Begin Object Class=DHmoComboBox Name=DetailTextureDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Texture Detail"
        OnCreateComponent=DetailTextureDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.063021
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=7
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Texture=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailTextureDetail'
    Begin Object Class=DHmoComboBox Name=DetailCharacterDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Character Detail"
        OnCreateComponent=DetailCharacterDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.116667
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=8
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Char=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailCharacterDetail'
    Begin Object Class=DHmoComboBox Name=DetailWorldDetail
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="World Detail"
        OnCreateComponent=DetailWorldDetail.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.170312
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=9
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_World=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailWorldDetail'
    Begin Object Class=DHmoComboBox Name=DetailPhysics
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Physics Detail"
        OnCreateComponent=DetailPhysics.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="High"
        WinTop=0.223958
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=10
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Physics=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailPhysics'
    Begin Object Class=DHmoComboBox Name=DetailDecalStay
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Decal Stay"
        OnCreateComponent=DetailDecalStay.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="Normal"
        WinTop=0.282032
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Decal=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailDecalStay'
    Begin Object Class=DHmoComboBox Name=MeshLOD
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Dynamic Mesh LOD"
        OnCreateComponent=MeshLOD.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.223958
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=11
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_MeshLOD=DHmoComboBox'DH_Interface.DHTab_DetailSettings.MeshLOD'
    Begin Object Class=DHmoComboBox Name=VideoResolution
        bReadOnly=true
        CaptionWidth=0.550000
        Caption="Resolution"
        OnCreateComponent=VideoResolution.InternalOnCreateComponent
        IniOption="@INTERNAL"
        IniDefault="640x480"
        WinTop=0.060417
        WinLeft=0.030508
        WinWidth=0.390000
        TabOrder=1
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Resolution=DHmoComboBox'DH_Interface.DHTab_DetailSettings.VideoResolution'
    Begin Object Class=DHmoComboBox Name=VideoColorDepth
        CaptionWidth=0.550000
        Caption="Color Depth"
        OnCreateComponent=VideoColorDepth.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.117188
        WinLeft=0.030234
        WinWidth=0.390000
        TabOrder=2
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_ColorDepth=DHmoComboBox'DH_Interface.DHTab_DetailSettings.VideoColorDepth'
    Begin Object Class=DHmoComboBox Name=RenderDeviceCombo
        ComponentJustification=TXTA_Left
        CaptionWidth=0.550000
        Caption="Render Device"
        OnCreateComponent=RenderDeviceCombo.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.335021
        WinLeft=0.547773
        WinWidth=0.401953
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_RenderDevice=DHmoComboBox'DH_Interface.DHTab_DetailSettings.RenderDeviceCombo'
    Begin Object Class=DHmoComboBox Name=DetailCharacterShadows
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Character Shadows"
        OnCreateComponent=DetailCharacterShadows.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.431378
        WinLeft=0.600000
        WinWidth=0.300000
        TabOrder=13
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Shadows=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailCharacterShadows'
    Begin Object Class=DHmoComboBox Name=DetailAntialiasing
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Antialiasing"
        OnCreateComponent=DetailAntialiasing.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.450000
        WinLeft=0.550000
        WinWidth=0.400000
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_MultiSamples=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailAntialiasing'
    Begin Object Class=DHmoComboBox Name=DetailAnisotropy
        ComponentJustification=TXTA_Left
        CaptionWidth=0.650000
        Caption="Anisotropic Filtering"
        OnCreateComponent=DetailAnisotropy.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.480000
        WinLeft=0.600000
        WinWidth=0.400000
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    co_Anisotropy=DHmoComboBox'DH_Interface.DHTab_DetailSettings.DetailAnisotropy'
    Begin Object Class=DHmoCheckBox Name=DetailDecals
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Decals"
        OnCreateComponent=DetailDecals.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.479308
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=14
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Decals=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDecals'
    Begin Object Class=DHmoCheckBox Name=DetailDynamicLighting
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Dynamic Lighting"
        OnCreateComponent=DetailDynamicLighting.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.526716
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=15
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DynLight=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDynamicLighting'
    Begin Object Class=DHmoCheckBox Name=DetailCoronas
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Coronas"
        OnCreateComponent=DetailCoronas.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.624136
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=17
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Coronas=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailCoronas'
    Begin Object Class=DHmoCheckBox Name=DetailDetailTextures
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Detail Textures"
        OnCreateComponent=DetailDetailTextures.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.575425
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=16
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Textures=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDetailTextures'
    Begin Object Class=DHmoCheckBox Name=DetailProjectors
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Projectors"
        OnCreateComponent=DetailProjectors.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.721195
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=19
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Projectors=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailProjectors'
    Begin Object Class=DHmoCheckBox Name=DetailDecoLayers
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Foliage"
        OnCreateComponent=DetailDecoLayers.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.769906
        WinLeft=0.599727
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=20
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_DecoLayers=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailDecoLayers'
    Begin Object Class=DHmoCheckBox Name=DetailTrilinear
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Trilinear Filtering"
        OnCreateComponent=DetailTrilinear.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.673263
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=18
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Trilinear=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailTrilinear'
    Begin Object Class=DHmoCheckBox Name=VideoFullScreen
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Full Screen"
        OnCreateComponent=VideoFullScreen.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="true"
        WinTop=0.169531
        WinLeft=0.030976
        WinWidth=0.387500
        TabOrder=3
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_FullScreen=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.VideoFullScreen'
    Begin Object Class=DHmoCheckBox Name=WeatherEffects
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Weather Effects"
        OnCreateComponent=WeatherEffects.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.864910
        WinLeft=0.599727
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=21
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_Weather=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.WeatherEffects'
    Begin Object Class=DHmoCheckBox Name=DetailForceFSAASS
        ComponentJustification=TXTA_Left
        CaptionWidth=0.940000
        Caption="Force FSAA Screenshots"
        OnCreateComponent=DetailForceFSAASS.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="false"
        WinTop=0.499308
        WinLeft=0.600000
        WinWidth=0.300000
        WinHeight=0.040000
        TabOrder=12
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    ch_ForceFSAAScreenshotSupport=DHmoCheckBox'DH_Interface.DHTab_DetailSettings.DetailForceFSAASS'
    Begin Object Class=moSlider Name=GammaSlider
        MaxValue=2.500000
        MinValue=0.500000
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.550000
        Caption="Gamma"
        LabelStyleName="DHLargeText"
        OnCreateComponent=GammaSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.272918
        WinLeft=0.012501
        WinWidth=0.461133
        TabOrder=5
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Gamma=moSlider'DH_Interface.DHTab_DetailSettings.GammaSlider'
    Begin Object Class=moSlider Name=BrightnessSlider
        MaxValue=1.000000
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.550000
        Caption="Brightness"
        LabelStyleName="DHLargeText"
        OnCreateComponent=BrightnessSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.229951
        WinLeft=0.012188
        WinWidth=0.461445
        TabOrder=4
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Brightness=moSlider'DH_Interface.DHTab_DetailSettings.BrightnessSlider'
    Begin Object Class=moSlider Name=ContrastSlider
        MaxValue=1.000000
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.550000
        Caption="Contrast"
        LabelStyleName="DHLargeText"
        OnCreateComponent=ContrastSlider.InternalOnCreateComponent
        IniOption="@Internal"
        IniDefault="0.8"
        WinTop=0.313285
        WinLeft=0.012188
        WinWidth=0.461133
        TabOrder=6
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_Contrast=moSlider'DH_Interface.DHTab_DetailSettings.ContrastSlider'
    Begin Object Class=moSlider Name=DistanceLODSlider
        MaxValue=1.000000
        Value=0.500000
        SliderCaptionStyleName="DHLargeText"
        CaptionWidth=0.650000
        Caption="Fog Distance"
        LabelStyleName="DHLargeText"
        OnCreateComponent=DistanceLODSlider.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.910000
        WinLeft=0.560000
        WinWidth=0.400000
        TabOrder=22
        OnChange=DHTab_DetailSettings.InternalOnChange
        OnLoadINI=DHTab_DetailSettings.InternalOnLoadINI
    End Object
    sl_DistanceLOD=moSlider'DH_Interface.DHTab_DetailSettings.DistanceLODSlider'
}
