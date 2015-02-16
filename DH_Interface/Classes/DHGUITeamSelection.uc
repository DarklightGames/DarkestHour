//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHGUITeamSelection extends ROGUITeamSelection;

var  automated  BackgroundImage     bg_Background2, bg_Background3;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super(UT2K4GUIPage).InitComponent(MyController, MyOwner);

    if (PlayerOwner() != none)
    {
        GRI = ROGameReplicationInfo(PlayerOwner().GameReplicationInfo);

        if (GRI != none) // Matt: restated function & modified to avoid "accessed none" errors for GRI
        {
            loadBriefing();

            // Set initial values
            l_TeamBriefing[0].SetContent(GRI.UnitName[AXIS_TEAM_INDEX] $ "||" $ Briefing[AXIS_TEAM_INDEX]);
            l_TeamBriefing[1].SetContent(GRI.UnitName[ALLIES_TEAM_INDEX] $ "||" $ Briefing[ALLIES_TEAM_INDEX]);
        }
    }

    for (i = 0; i < 2; i++)
    {
        b_TeamSelect[i].Caption = TeamJoinText[i];
        b_TeamSelect[i].SetHint(TeamJoinHint[i]);
    }

    Timer();
    SetTimer(0.1, true);

    SetBackground(); // this is added in DH
}

function SetBackground()
{
    local DH_LevelInfo LI;

    // Find nationinfo
    foreach PlayerOwner().AllActors(class'DH_LevelInfo', LI)
    {
        break;
    }

    if (LI != none)
    {
        if (LI.AlliedNation == NATION_Britain)
        {
            bg_Background.SetVisibility(false);
            bg_Background2.SetVisibility(true);
            bg_Background3.SetVisibility(false);
        }
        else if (LI.AlliedNation == NATION_Canada)
        {
            bg_Background.SetVisibility(false);
            bg_Background2.SetVisibility(false);
            bg_Background3.SetVisibility(true);
        }
        else // NATION_USA
        {
            bg_Background.SetVisibility(true);
            bg_Background2.SetVisibility(false);
            bg_Background3.SetVisibility(false);
        }
    }
    else
    {
        bg_Background.SetVisibility(true);
        bg_Background2.SetVisibility(false);
        bg_Background3.SetVisibility(false);
    }
}

function SelectTeamSuccessfull()
{
    if (selectedTeam != -1)
    {
        if (ROPlayer(PlayerOwner()) != none)
        {
            //ROPlayer(PlayerOwner()).ForcedTeamSelectOnRoleSelectPage = selectedTeam;
        }

        Controller.OpenMenu("DH_Interface.DHDeployMenu");
    }

    class'DHRoleSelection'.static.CheckNeedForFadeFromBlackEffect(PlayerOwner());

    Controller.RemoveMenu(self);
}

defaultproperties
{
    Begin Object Class=BackgroundImage Name=PageBackground2
        Image=texture'DH_GUI_Tex.Menu.TeamselectB'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background2=BackgroundImage'DH_Interface.DHGUITeamSelection.PageBackground2'

    Begin Object Class=BackgroundImage Name=PageBackground3
        Image=texture'DH_GUI_Tex.Menu.TeamselectC'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background3=BackgroundImage'DH_Interface.DHGUITeamSelection.PageBackground3'

    Begin Object Class=GUILabel Name=TeamsCount
        Caption="? units"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinTop=0.871667
        WinLeft=0.096250
        WinWidth=0.300000
        WinHeight=0.040000
    End Object
    l_TeamCount(0)=GUILabel'DH_Interface.DHGUITeamSelection.TeamsCount'

    Begin Object Class=GUILabel Name=TeamsCount2
        Caption="? units"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinTop=0.415000
        WinLeft=0.096250
        WinWidth=0.300000
        WinHeight=0.040000
    End Object
    l_TeamCount(1)=GUILabel'DH_Interface.DHGUITeamSelection.TeamsCount2'

    Begin Object Class=DHGUIScrollTextBox Name=TeamsBriefing
        bNoTeletype=true
        OnCreateComponent=TeamsBriefing.InternalOnCreateComponent
        StyleName="DHBlackText"
        WinTop=0.530000
        WinLeft=0.503750
        WinWidth=0.446250
        WinHeight=0.342498
    End Object
    l_TeamBriefing(0)=DHGUIScrollTextBox'DH_Interface.DHGUITeamSelection.TeamsBriefing'

    Begin Object Class=DHGUIScrollTextBox Name=TeamsBriefing2
        bNoTeletype=true
        OnCreateComponent=TeamsBriefing2.InternalOnCreateComponent
        StyleName="DHBlackText"
        WinTop=0.078333
        WinLeft=0.503750
        WinWidth=0.446250
        WinHeight=0.342498
    End Object
    l_TeamBriefing(1)=DHGUIScrollTextBox'DH_Interface.DHGUITeamSelection.TeamsBriefing2'

    Begin Object Class=DHGUIButton Name=JoinTeamButton
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.823333
        WinLeft=0.118750
        WinWidth=0.250000
        WinHeight=0.050000
        TabOrder=1
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_TeamSelect(0)=DHGUIButton'DH_Interface.DHGUITeamSelection.JoinTeamButton'

    Begin Object Class=DHGUIButton Name=JoinTeamButton2
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.370000
        WinLeft=0.118750
        WinWidth=0.250000
        WinHeight=0.050000
        TabOrder=2
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_TeamSelect(1)=DHGUIButton'DH_Interface.DHGUITeamSelection.JoinTeamButton2'

    Begin Object Class=DHGUIButton Name=Spectate
        Caption="Spectate"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.920000
        WinLeft=0.550000
        WinWidth=0.250000
        WinHeight=0.050000
        TabOrder=4
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_Spectate=DHGUIButton'DH_Interface.DHGUITeamSelection.Spectate'

    Begin Object Class=DHGUIButton Name=AutoSelect
        Caption="Auto-select"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.920000
        WinLeft=0.250000
        WinWidth=0.250000
        WinHeight=0.050000
        TabOrder=3
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_AutoSelect=DHGUIButton'DH_Interface.DHGUITeamSelection.AutoSelect'

    Begin Object Class=BackgroundImage Name=PageBackground
        Image=texture'DH_GUI_Tex.Menu.Teamselect'
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Alpha
        X1=0
        Y1=0
        X2=1023
        Y2=1023
    End Object
    bg_Background=BackgroundImage'DH_Interface.DHGUITeamSelection.PageBackground'

    OnClose=DHGUITeamSelection.InternalOnClose
    OnMessage=DHGUITeamSelection.InternalOnMessage
    OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
}
