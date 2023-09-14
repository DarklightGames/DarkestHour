//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHLearnToPlayFooter extends ButtonFooter;

var     automated GUIButton                 b_Back;

var     DHLearnToPlayPage                   Owner;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
    super.InitComponent(InController, InOwner);
    Owner = DHLearnToPlayPage(MenuOwner);
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_Back)
    {
        Owner.BackButtonClicked();
        return true;
    }

    return false;
}

defaultproperties
{
    Begin Object Class=GUIButton Name=GameBackButton
        Caption="Back"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.085678
        WinWidth=0.12
        WinHeight=0.036482
        TabOrder=0
        bBoundToParent=true
        OnKeyEvent=GameBackButton.InternalOnKeyEvent
        OnClick=InternalOnClick
    End Object
    b_Back=GameBackButton

    Margin=0.04
}
