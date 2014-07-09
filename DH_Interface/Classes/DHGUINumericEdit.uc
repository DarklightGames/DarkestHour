class DHGUINumericEdit extends GUINumericEdit;

defaultproperties
{
     Begin Object Class=DHGUIEditBox Name=cMyEditBox
         bIntOnly=True
         bNeverScale=True
         OnActivate=cMyEditBox.InternalActivate
         OnDeActivate=cMyEditBox.InternalDeactivate
         OnKeyType=cMyEditBox.InternalOnKeyType
         OnKeyEvent=cMyEditBox.InternalOnKeyEvent
     End Object
     MyEditBox=DHGUIEditBox'DH_Interface.DHGUINumericEdit.cMyEditBox'

     Begin Object Class=GUISpinnerButton Name=cMySpinner
         StyleName="DHSpinner"
         bTabStop=False
         bNeverScale=True
         OnClick=cMySpinner.InternalOnClick
         OnKeyEvent=cMySpinner.InternalOnKeyEvent
     End Object
     MySpinner=GUISpinnerButton'DH_Interface.DHGUINumericEdit.cMySpinner'

}
