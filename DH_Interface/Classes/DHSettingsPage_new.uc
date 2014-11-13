//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHSettingsPage_new extends UT2K4SettingsPage;

function bool InternalOnCanClose(optional bool bCanceled)
{
    return true;
}

defaultproperties
{
     Begin Object Class=DHGUITabControl Name=SettingTabs
         bFillSpace=false
         bDockPanels=true
         TabHeight=0.060000
         BackgroundStyleName="DHHeader"
         WinHeight=0.044000
         RenderWeight=0.490000
         TabOrder=3
         bAcceptsInput=true
         OnActivate=SettingTabs.InternalOnActivate
         OnChange=DHSettingsPage_new.InternalOnChange
     End Object
     c_Tabs=DHGUITabControl'DH_Interface.DHSettingsPage_new.SettingTabs'

     Begin Object Class=DHGUIHeader Name=SettingHeader
         Caption="Settings"
         StyleName="DHTopper"
         WinHeight=32.000000
         RenderWeight=0.300000
     End Object
     t_Header=DHGUIHeader'DH_Interface.DHSettingsPage_new.SettingHeader'

     Begin Object Class=DHSettings_FooterNew Name=SettingFooter
         Spacer=0.010000
         StyleName="DHFooter"
         RenderWeight=0.300000
         TabOrder=4
         OnPreDraw=SettingFooter.InternalOnPreDraw
     End Object
     t_Footer=DHSettings_FooterNew'DH_Interface.DHSettingsPage_new.SettingFooter'

     PanelClass(0)="DH_Interface.DHTab_GameSettings"
     PanelClass(1)="DH_Interface.DHTab_DetailSettings"
     PanelClass(2)="DH_Interface.DHTab_AudioSettings"
     PanelClass(3)="DH_Interface.DHTab_Controls"
     PanelClass(4)="DH_Interface.DHTab_Input"
     PanelClass(5)="DH_Interface.DHTab_Hud"
     PanelClass(6)="none"
     PanelCaption(0)="Game"
     PanelCaption(1)="Display"
     PanelCaption(2)="Audio"
     PanelCaption(3)="Controls"
     PanelCaption(5)="Hud"
     PanelCaption(6)="none"
     Background=Texture'DH_GUI_Tex.Menu.Setupmenu'
}
