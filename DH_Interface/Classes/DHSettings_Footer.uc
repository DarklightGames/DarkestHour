//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSettings_Footer extends ButtonFooter;

var automated GUIButton b_Back, b_Defaults;
var DHSettingsPage SettingsPage;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController,MyOwner);
        SettingsPage = DHSettingsPage(MyOwner);
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_Back)
    {
        SettingsPage.BackButtonClicked();
    }
    else if (Sender==b_Defaults)
    {
        SettingsPage.DefaultsButtonClicked();
    }

    return true;
}

defaultproperties
{
    Begin Object Class=GUIButton Name=BackB
        Caption="Back"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.085678
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=1
        bBoundToParent=true
        OnClick=DHSettings_Footer.InternalOnClick
        OnKeyEvent=BackB.InternalOnKeyEvent
    End Object
    b_Back=GUIButton'DH_Interface.DHSettings_Footer.BackB'
    Begin Object Class=GUIButton Name=DefaultB
        Caption="Defaults"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.085678
        WinLeft=0.885352
        WinWidth=0.114648
        WinHeight=0.036482
        RenderWeight=2.0
        TabOrder=0
        bBoundToParent=true
        OnClick=DHSettings_Footer.InternalOnClick
        OnKeyEvent=DefaultB.InternalOnKeyEvent
    End Object
    b_Defaults=GUIButton'DH_Interface.DHSettings_Footer.DefaultB'
}
