class DHTab_Input extends ROTab_Input;

defaultproperties
{
     Begin Object Class=DHGUISectionBackground Name=InputBK1
         Caption="Options"
         WinTop=0.180360
         WinLeft=0.021641
         WinWidth=0.381328
         WinHeight=0.500000
         OnPreDraw=InputBK1.InternalPreDraw
     End Object
     i_BG1=DHGUISectionBackground'DH_Interface.DHTab_Input.InputBK1'

     Begin Object Class=DHGUISectionBackground Name=InputBK3
         Caption="Fine Tuning"
         WinTop=0.220000
         WinLeft=0.451289
         WinWidth=0.527812
         WinHeight=0.400000
         OnPreDraw=InputBK3.InternalPreDraw
     End Object
     i_BG3=DHGUISectionBackground'DH_Interface.DHTab_Input.InputBK3'

     Begin Object Class=DHmoCheckBox Name=InputAutoSlope
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Auto Slope"
         OnCreateComponent=InputAutoSlope.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.105365
         WinLeft=0.060937
         WinWidth=0.300000
         WinHeight=0.040000
         TabOrder=2
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     ch_AutoSlope=DHmoCheckBox'DH_Interface.DHTab_Input.InputAutoSlope'

     Begin Object Class=DHmoCheckBox Name=InputInvertMouse
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Invert Mouse"
         OnCreateComponent=InputInvertMouse.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.188698
         WinLeft=0.060938
         WinWidth=0.300000
         WinHeight=0.040000
         TabOrder=3
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     ch_InvertMouse=DHmoCheckBox'DH_Interface.DHTab_Input.InputInvertMouse'

     Begin Object Class=DHmoCheckBox Name=InputMouseSmoothing
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Mouse Smoothing"
         OnCreateComponent=InputMouseSmoothing.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.324167
         WinLeft=0.060938
         WinWidth=0.300000
         WinHeight=0.040000
         TabOrder=4
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     ch_MouseSmoothing=DHmoCheckBox'DH_Interface.DHTab_Input.InputMouseSmoothing'

     Begin Object Class=DHmoCheckBox Name=InputUseJoystick
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Enable Joystick"
         OnCreateComponent=InputUseJoystick.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.582083
         WinLeft=0.060938
         WinWidth=0.300000
         WinHeight=0.040000
         TabOrder=6
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     ch_Joystick=DHmoCheckBox'DH_Interface.DHTab_Input.InputUseJoystick'

     Begin Object Class=DHmoCheckBox Name=InputMouseLag
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Reduce Mouse Lag"
         OnCreateComponent=InputMouseLag.InternalOnCreateComponent
         IniOption="@Internal"
         Hint="Enable this option will reduce the amount of lag in your mouse."
         WinTop=0.405000
         WinLeft=0.060938
         WinWidth=0.300000
         WinHeight=0.040000
         TabOrder=5
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     ch_MouseLag=DHmoCheckBox'DH_Interface.DHTab_Input.InputMouseLag'

     Begin Object Class=DHmoFloatEdit Name=InputMouseSensitivity
         MinValue=0.250000
         MaxValue=25.000000
         Step=0.250000
         ComponentJustification=TXTA_Left
         CaptionWidth=0.725000
         Caption="Mouse Sensitivity (Game)"
         OnCreateComponent=InputMouseSensitivity.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.105365
         WinLeft=0.502344
         WinWidth=0.421680
         WinHeight=0.045352
         TabOrder=7
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     fl_Sensitivity=DHmoFloatEdit'DH_Interface.DHTab_Input.InputMouseSensitivity'

     Begin Object Class=DHmoFloatEdit Name=InputMenuSensitivity
         MinValue=1.000000
         MaxValue=6.000000
         Step=0.250000
         ComponentJustification=TXTA_Left
         CaptionWidth=0.725000
         Caption="Mouse Sensitivity (Menus)"
         OnCreateComponent=InputMenuSensitivity.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.188698
         WinLeft=0.502344
         WinWidth=0.421875
         WinHeight=0.045352
         TabOrder=8
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     fl_MenuSensitivity=DHmoFloatEdit'DH_Interface.DHTab_Input.InputMenuSensitivity'

     Begin Object Class=DHmoFloatEdit Name=InputMouseAccel
         MinValue=0.000000
         MaxValue=100.000000
         Step=5.000000
         ComponentJustification=TXTA_Left
         CaptionWidth=0.725000
         Caption="Mouse Accel. Threshold"
         OnCreateComponent=InputMouseAccel.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.405000
         WinLeft=0.502344
         WinWidth=0.421875
         WinHeight=0.045352
         TabOrder=10
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     fl_MouseAccel=DHmoFloatEdit'DH_Interface.DHTab_Input.InputMouseAccel'

     Begin Object Class=DHmoFloatEdit Name=InputMouseSmoothStr
         MinValue=0.000000
         MaxValue=1.000000
         Step=0.050000
         ComponentJustification=TXTA_Left
         CaptionWidth=0.725000
         Caption="Mouse Smoothing Strength"
         OnCreateComponent=InputMouseSmoothStr.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.324167
         WinLeft=0.502344
         WinWidth=0.421875
         WinHeight=0.045352
         TabOrder=9
         OnChange=DHTab_Input.InternalOnChange
         OnLoadINI=DHTab_Input.InternalOnLoadINI
     End Object
     fl_SmoothingStrength=DHmoFloatEdit'DH_Interface.DHTab_Input.InputMouseSmoothStr'

}
