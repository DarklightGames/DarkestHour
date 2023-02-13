//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGamePageMP extends UT2K4GamePageMP;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
    super.InitComponent(InController, InOwner);

    class'DHInterfaceUtil'.static.SetROStyle(InController, Controls);
    RuleInfo = new(none) class'Engine.PlayInfo';
    c_Tabs.RemoveTab(PanelCaption[0]);
    c_Tabs.RemoveTab(PanelCaption[4]);
    mcRules = DHIAMultiColumnRulesPanel(c_Tabs.ReplaceTab(c_Tabs.TabStack[1], PanelCaption[2], "DH_Interface.DHIAMultiColumnRulesPanel",, PanelHint[2]));
    DHTab_MainSP(c_Tabs.BorrowPanel(PanelCaption[1])).bHideDifficultyControl = true;
    p_game = none;
    Controller.LastGameType = "DH_Engine.DarkestHourGame";
    ChangeGameType(false);
}

// We only have one game type so it is never locked
function bool GameTypeLocked()
{
    local int          i;
    local GUITabButton tb;

    for (i = 0; i < c_Tabs.TabStack.Length; ++i)
    {
        tb = c_Tabs.TabStack[i];

        if (tb != none)
        {
            EnableComponent(tb);
        }
    }

    EnableComponent(b_Primary);
    EnableComponent(b_Secondary);

    if (RuleInfo != none && mcRules != none)
    {
        i = RuleInfo.FindIndex("BotMode");

        if (i != -1)
        {
            mcRules.UpdateBotSetting(i);
        }
    }

    return false;
}

function StartGame(string GameURL, bool bAlt)
{
    local GUIController C;

    C = Controller;

    if (bAlt)
    {
        if (mcServerRules != none)
        {
            GameURL $= mcServerRules.Play();
        }

        Log("GameURL is" @ GameURL);
        Log("ConsoleCommand is " $ "relaunch" @ GameURL @ "-server -mod=DarkestHour -log=server.log");
        PlayerOwner().ConsoleCommand("relaunch" @ GameURL @ "-server -mod=DarkestHour -log=server.log");
    }
    else
    {
        PlayerOwner().ClientTravel(GameURL $ "?Listen", TRAVEL_Absolute, false);
        C.CloseAll(false, true);
    }
}

defaultproperties
{
    Begin Object Class=DHGUITabControl Name=PageTabs
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinHeight=0.044
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        OnActivate=PageTabs.InternalOnActivate
        OnChange=DHGamePageMP.InternalOnChange
    End Object
    c_Tabs=DHGUITabControl'DH_Interface.DHGamePageMP.PageTabs'

    Begin Object Class=DHGUIHeader Name=GamePageHeader
        StyleName="DHTopper"
        WinHeight=32.0
        RenderWeight=0.3
    End Object
    t_Header=DHGUIHeader'DH_Interface.DHGamePageMP.GamePageHeader'

    Begin Object Class=DHGameFooterMP Name=MPFooter
        PrimaryCaption="Listen"
        SecondaryCaption="Dedicated"
        Spacer=0.01
        TextIndent=5
        FontScale=FNS_Small
        StyleName="DHFooter"
        WinTop=0.95
        WinHeight=0.045
        RenderWeight=0.3
        TabOrder=8
        OnPreDraw=MPFooter.InternalOnPreDraw
    End Object
    t_Footer=DHGameFooterMP'DH_Interface.DHGamePageMP.MPFooter'

    Begin Object Class=GUIImage Name=BkChar
        Image=Texture'DH_GUI_Tex.Menu.menuBackground'
        ImageStyle=ISTY_Scaled
        X1=0
        Y1=0
        X2=1024
        Y2=1024
        WinHeight=1.0
        RenderWeight=0.02
    End Object
    i_bkChar=GUIImage'DH_Interface.DHGamePageMP.BkChar'

    PanelClass(1)="DH_Interface.DHTab_MainMP"
    PanelClass(2)="DH_Interface.DHIAMultiColumnRulesPanel"
    PanelClass(3)="DH_Interface.DHTab_MutatorMP"
    PanelClass(4)="ROInterface.ROUT2K4Tab_BotConfigMP"
    PanelClass(5)="DH_Interface.DHTab_ServerRulesPanel"
}
