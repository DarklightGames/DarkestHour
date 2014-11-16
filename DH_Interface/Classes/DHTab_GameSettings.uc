//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHTab_GameSettings extends ROTab_GameSettings;

var automated moComboBox co_PurgeCacheDays;

var int PurgeCacheDaysValues[3];
var localized string PurgeCacheDaysText[3];

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    i_BG1.ManageComponent(co_PurgeCacheDays);

    for (i = 0; i < arraycount(PurgeCacheDaysText); i++)
    {
        co_PurgeCacheDays.AddItem(PurgeCacheDaysText[i]);
    }
}

function SaveSettings()
{
    local int PurgeCacheDaysIndex;

    PurgeCacheDaysIndex = co_PurgeCacheDays.GetIndex();

    PlayerOwner().ConsoleCommand("set Core.System PurgeCacheDays" @ PurgeCacheDaysValues[PurgeCacheDaysIndex]);

    super.SaveSettings();
}

function InternalOnLoadINI(GUIComponent Sender, string s)
{
    local int i;
    local int PurgeCacheDays;
    local int PurgeCacheDaysIndex;

    super.InternalOnLoadINI(Sender, s);

    switch(Sender)
    {
        case co_PurgeCacheDays:
            s = PlayerOwner().ConsoleCommand("get Core.System PurgeCacheDays", false);

            PurgeCacheDays = int(s);

            for(i = 0; i < arraycount(PurgeCacheDaysValues); ++i)
            {
                if(PurgeCacheDays == PurgeCacheDaysValues[i])
                {
                    PurgeCacheDaysIndex = i;

                    break;
                }
            }

            PlayerOwner().Level.Game.Broadcast(none, ">>" @ PurgeCacheDays @ "." @ PurgeCacheDaysIndex @ "<<");

            break;
    }

    co_PurgeCacheDays.SetIndex(PurgeCacheDaysIndex);
}

defaultproperties
{
    PurgeCacheDaysValues(0)=0
    PurgeCacheDaysValues(1)=7
    PurgeCacheDaysValues(2)=30

    PurgeCacheDaysText(0)="Never"
    PurgeCacheDaysText(1)="Weekly"
    PurgeCacheDaysText(2)="Monthly"

     Begin Object Class=DHGUISectionBackground Name=GameBK1
         Caption="Gameplay"
         WinTop=0.050000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.250000
         RenderWeight=0.100100
         OnPreDraw=GameBK1.InternalPreDraw
     End Object
     i_BG1=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK1'

     Begin Object Class=DHGUISectionBackground Name=GameBK2
         Caption="Network"
         WinTop=0.350000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.250000
         RenderWeight=0.100200
         OnPreDraw=GameBK2.InternalPreDraw
     End Object
     i_BG2=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK2'

     Begin Object Class=DHGUISectionBackground Name=GameBK3
         Caption="Simulation Realism"
         WinTop=0.650000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.250000
         RenderWeight=0.100200
         OnPreDraw=GameBK3.InternalPreDraw
     End Object
     i_BG3=DHGUISectionBackground'DH_Interface.DHTab_GameSettings.GameBK3'

     Begin Object Class=DHmoEditBox Name=OnlineStatsName
         Caption="Player Name"
         OnCreateComponent=OnlineStatsName.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.373349
         WinLeft=0.524912
         WinWidth=0.419316
         TabOrder=1
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     ed_PlayerName=DHmoEditBox'DH_Interface.DHTab_GameSettings.OnlineStatsName'

     Begin Object Class=DHmoComboBox Name=GameGoreLevel
         bReadOnly=true
         Caption="Gore Level"
         OnCreateComponent=GameGoreLevel.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.415521
         WinLeft=0.050000
         WinWidth=0.400000
         RenderWeight=1.040000
         TabOrder=2
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     co_GoreLevel=DHmoComboBox'DH_Interface.DHTab_GameSettings.GameGoreLevel'

     Begin Object Class=DHmoCheckBox Name=NetworkDynamicNetspeed
         ComponentJustification=TXTA_Left
         CaptionWidth=0.950000
         Caption="Dynamic Netspeed"
         OnCreateComponent=NetworkDynamicNetspeed.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.166017
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=4
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     ch_DynNetspeed=DHmoCheckBox'DH_Interface.DHTab_GameSettings.NetworkDynamicNetspeed'

     Begin Object Class=DHmoComboBox Name=OnlineNetSpeed
         bReadOnly=true
         ComponentJustification=TXTA_Left
         Caption="Connection"
         OnCreateComponent=OnlineNetSpeed.InternalOnCreateComponent
         IniOption="@Internal"
         IniDefault="Cable Modem/DSL"
         WinTop=0.122944
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=3
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     co_Netspeed=DHmoComboBox'DH_Interface.DHTab_GameSettings.OnlineNetSpeed'

     Begin Object Class=DHmoCheckBox Name=ThrottleTanks
         ComponentJustification=TXTA_Left
         CaptionWidth=0.950000
         Caption="Incremental Tank Throttle"
         OnCreateComponent=ThrottleTanks.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.166017
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=4
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     ch_TankThrottle=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ThrottleTanks'

     Begin Object Class=DHmoCheckBox Name=ThrottleVehicle
         ComponentJustification=TXTA_Left
         CaptionWidth=0.950000
         Caption="Incremental Vehicle Throttle"
         OnCreateComponent=ThrottleVehicle.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.166017
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=4
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     ch_VehicleThrottle=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ThrottleVehicle'

     Begin Object Class=DHmoCheckBox Name=ManualReloading
         ComponentJustification=TXTA_Left
         CaptionWidth=0.950000
         Caption="Manual Tank Shell Reloading"
         OnCreateComponent=ManualReloading.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.166017
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=5
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     ch_ManualReloading=DHmoCheckBox'DH_Interface.DHTab_GameSettings.ManualReloading'

     Begin Object Class=DHmoComboBox Name=PurgeCacheDaysComboBox
         bReadOnly=true
         ComponentJustification=TXTA_Left
         Caption="Purge Cache"
         OnCreateComponent=PurgeCacheDaysComboBox.InternalOnCreateComponent
         IniOption="@Internal"
         WinTop=0.122944
         WinLeft=0.528997
         WinWidth=0.419297
         TabOrder=3
         OnChange=DHTab_GameSettings.InternalOnChange
         OnLoadINI=DHTab_GameSettings.InternalOnLoadINI
     End Object
     co_PurgeCacheDays=DHmoComboBox'DH_Interface.DHTab_GameSettings.PurgeCacheDaysComboBox'
}
