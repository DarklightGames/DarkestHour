//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUINumericEdit extends GUINumericEdit;

var()   int                 MidValue;

defaultproperties
{
    Begin Object Class=DHGUIEditBox Name=cMyEditBox
        bIntOnly=true
        bNeverScale=true
        OnActivate=cMyEditBox.InternalActivate
        OnDeActivate=cMyEditBox.InternalDeactivate
        OnKeyType=cMyEditBox.InternalOnKeyType
        OnKeyEvent=cMyEditBox.InternalOnKeyEvent
    End Object
    MyEditBox=DHGUIEditBox'DH_Interface.DHGUINumericEdit.cMyEditBox'
    Begin Object Class=GUISpinnerButton Name=cMySpinner
        StyleName="DHSpinner"
        bTabStop=false
        bNeverScale=true
        OnClick=cMySpinner.InternalOnClick
        OnKeyEvent=cMySpinner.InternalOnKeyEvent
    End Object
    MySpinner=GUISpinnerButton'DH_Interface.DHGUINumericEdit.cMySpinner'
}
