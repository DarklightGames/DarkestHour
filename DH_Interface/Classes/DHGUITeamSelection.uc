//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUITeamSelection extends ROGUITeamSelection;

var array<texture>                          BackgroundTextures;

var automated GUIButton                     b_Disconnect, b_Settings;

var DHPlayer                                PC;

var localized   string                      SizeBonusText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super(UT2K4GUIPage).InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return;
    }

    GRI = ROGameReplicationInfo(PC.GameReplicationInfo);

    // Matt: restated function & modified to avoid "accessed none" errors for GRI
    if (GRI != none)
    {
        LoadBriefing();

        // Set initial values
        l_TeamBriefing[0].SetContent(GRI.UnitName[AXIS_TEAM_INDEX] $ "||" $ Briefing[AXIS_TEAM_INDEX]);
        l_TeamBriefing[1].SetContent(GRI.UnitName[ALLIES_TEAM_INDEX] $ "||" $ Briefing[ALLIES_TEAM_INDEX]);
    }

    for (i = 0; i < 2; ++i)
    {
        b_TeamSelect[i].Caption = TeamJoinText[i];
        b_TeamSelect[i].SetHint(TeamJoinHint[i]);
    }

    Timer();
    SetTimer(0.25, true); //changed to 0.25 (4 times a second 10 times prob too much)

    SetBackground(); // this is added in DH
}

// Modified to keep trying to get PC and GRI if it hasn't been initialized yet
function Timer()
{
    if (PC == none)
    {
        PC = DHPlayer(PlayerOwner());
    }

    if (PC != none && GRI == none)
    {
        GRI = ROGameReplicationInfo(PC.GameReplicationInfo);
    }

    UpdateTeamCounts();
}

// Modified to add information to the end of the string like (+10% size advantage)
function UpdateTeamCounts()
{
    local DHGameReplicationInfo DHGRI;
    local string AlliedStr, AxisStr;
    local int TeamSizes[2];

    DHGRI = DHGameReplicationInfo(GRI);

    if (DHGRI != none)
    {
        DHGRI.GetTeamSizes(TeamSizes);

        if (DHGRI.CurrentAlliedToAxisRatio != 0.5)
        {
            AxisStr = " (" $ DHGRI.GetTeamScaleString(AXIS_TEAM_INDEX) @ SizeBonusText $ ")";
            AlliedStr = " (" $ DHGRI.GetTeamScaleString(ALLIES_TEAM_INDEX) @ SizeBonusText $ ")";
        }
    }

    l_TeamCount[AXIS_TEAM_INDEX].Caption = "" $ TeamSizes[AXIS_TEAM_INDEX] $ UnitsText $ AxisStr;
    l_TeamCount[ALLIES_TEAM_INDEX].Caption = "" $ TeamSizes[ALLIES_TEAM_INDEX] $ UnitsText $ AlliedStr;
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
        bg_Background.Image = BackgroundTextures[int(LI.AlliedNation)];
    }
}

function SelectTeamSuccessfull()
{
    if (PC == none || Controller == none)
    {
        return;
    }

    if (SelectedTeam != -1)
    {
        PC.ForcedTeamSelectOnRoleSelectPage = SelectedTeam;
        PC.DeployMenuStartMode = MODE_Map;
        Controller.ReplaceMenu("DH_Interface.DHDeployMenu");
    }
    else
    {
        Controller.RemoveMenu(self);
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    switch (Sender)
    {
        case b_AutoSelect:
            SelectTeam(-2);
            break;

        case b_Spectate:
            SelectTeam(-1);
            break;

        case b_Disconnect:
            PlayerOwner().ConsoleCommand("DISCONNECT");
            break;

        case b_Settings:
            Controller.OpenMenu("DH_Interface.DHSettingsPage");
            break;

        case b_TeamSelect[AXIS_TEAM_INDEX]:
            SelectTeam(AXIS_TEAM_INDEX);
            break;

        case b_TeamSelect[ALLIES_TEAM_INDEX]:
            SelectTeam(ALLIES_TEAM_INDEX);
            break;
    }
    return true;
}

function SelectTeam(int Team)
{
    SelectedTeam = Team;

    // Important check
    if (PC == none && GRI == none)
    {
        return;
    }

    // Check to make sure we actually can "change" teams
    if (PC.PlayerReplicationInfo != none &&
        PC.PlayerReplicationInfo.Team != none &&
        PC.PlayerReplicationInfo.Team.TeamIndex != Team &&
        PC.NextChangeTeamTime >= GRI.ElapsedTime)
    {
        // Trying to change teams, but recently did (give an error)
        Controller.ShowQuestionDialog(Repl(class'DHDeployMenu'.default.CantChangeTeamYetText, "{s}", PC.NextChangeTeamTime - GRI.ElapsedTime), QBTN_OK);

        return;
    }

    SetButtonsState(true);

    if (Team == -1) // Spectate
    {
        PC.ServerSetPlayerInfo(254, 255, 0, 0, -1, -1);
    }
    else if (Team == -2) // Auto-select
    {
        PC.ServerSetPlayerInfo(250, 255, 0, 0, -1, -1);
    }
    else // Allies or Axis
    {
        PC.ServerSetPlayerInfo(Team, 255, 0, 0, -1, -1);
    }
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    local int Result;
    local string ErrorMessage;

    if (Msg != "NOTIFY_GUI_ROLE_SELECTION_PAGE")
    {
        // Received success/failure message from server.

        Result = int(MsgLife);

        switch (Result)
        {
            case 0:
            case 96: // Team change successfull!
                SelectTeamSuccessfull();
                return;

            case 97: // Succesfully picked axis team
                SelectedTeam = AXIS_TEAM_INDEX;
                SelectTeamSuccessfull();

                return;

            case 98: // Successfully picked allies team
                SelectedTeam = ALLIES_TEAM_INDEX;
                SelectTeamSuccessfull();

                return;

            default: // Couldn't change teams: get error msg
                ErrorMessage = class'ROGUIRoleSelection'.static.GetErrorMessageForId(result);
        }

        SetButtonsState(false);

        Controller.ShowQuestionDialog(ErrorMessage, QBTN_OK, QBTN_OK);
    }
}

defaultproperties
{
    UnitsText=" players"
    SizeBonusText="army size"

    BackgroundTextures(0)=Texture'DH_GUI_Tex.Menu.Teamselect'
    BackgroundTextures(1)=Texture'DH_GUI_Tex.Menu.TeamselectB'
    BackgroundTextures(2)=Texture'DH_GUI_Tex.Menu.TeamselectC'
    BackgroundTextures(3)=Texture'DH_GUI_Tex.Menu.TeamselectD'
    BackgroundTextures(4)=Texture'DH_GUI_Tex.Menu.TeamselectP'
    BackgroundTextures(5)=Texture'DH_GUI_Tex.Menu.TeamselectCS'

    Begin Object Class=GUILabel Name=TeamsCount
        Caption="? players"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinTop=0.871667
        WinLeft=0.09625
        WinWidth=0.3
        WinHeight=0.04
    End Object
    l_TeamCount(0)=GUILabel'DH_Interface.DHGUITeamSelection.TeamsCount'

    Begin Object Class=GUILabel Name=TeamsCount2
        Caption="? players"
        TextAlign=TXTA_Center
        StyleName="DHLargeText"
        WinTop=0.415
        WinLeft=0.09625
        WinWidth=0.3
        WinHeight=0.04
    End Object
    l_TeamCount(1)=GUILabel'DH_Interface.DHGUITeamSelection.TeamsCount2'

    Begin Object Class=DHGUIScrollTextBox Name=TeamsBriefing
        bNoTeletype=true
        OnCreateComponent=TeamsBriefing.InternalOnCreateComponent
        StyleName="DHBlackText"
        WinTop=0.53
        WinLeft=0.50375
        WinWidth=0.44625
        WinHeight=0.342498
    End Object
    l_TeamBriefing(0)=DHGUIScrollTextBox'DH_Interface.DHGUITeamSelection.TeamsBriefing'

    Begin Object Class=DHGUIScrollTextBox Name=TeamsBriefing2
        bNoTeletype=true
        OnCreateComponent=TeamsBriefing2.InternalOnCreateComponent
        StyleName="DHBlackText"
        WinTop=0.078333
        WinLeft=0.50375
        WinWidth=0.44625
        WinHeight=0.342498
    End Object
    l_TeamBriefing(1)=DHGUIScrollTextBox'DH_Interface.DHGUITeamSelection.TeamsBriefing2'

    Begin Object Class=DHGUIButton Name=JoinTeamButton
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.823333
        WinLeft=0.11875
        WinWidth=0.25
        WinHeight=0.05
        TabOrder=1
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_TeamSelect(0)=DHGUIButton'DH_Interface.DHGUITeamSelection.JoinTeamButton'

    Begin Object class=DHGUIButton Name=JoinTeamButton2
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.37
        WinLeft=0.11875
        WinWidth=0.25
        WinHeight=0.05
        TabOrder=2
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_TeamSelect(1)=DHGUIButton'DH_Interface.DHGUITeamSelection.JoinTeamButton2'

    // Disconnect
    Begin Object class=DHGUIButton Name=Disconnect
        Caption="Disconnect"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.92
        WinLeft=0.0
        WinWidth=0.11875
        WinHeight=0.05
        TabOrder=3
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_Disconnect=Disconnect

    // auto Select
    Begin Object Class=DHGUIButton Name=AutoSelect
        Caption="Auto-Select"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.92
        WinLeft=0.11875
        WinWidth=0.25
        WinHeight=0.05
        TabOrder=4
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_AutoSelect=AutoSelect

    // Spectate
    Begin Object Class=DHGUIButton Name=Spectate
        Caption="Spectate"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.92
        WinLeft=0.36875
        WinWidth=0.315625
        WinHeight=0.05
        TabOrder=5
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_Spectate=Spectate

    // Settings Button
    Begin Object Class=DHGUIButton Name=SettingsButtonObject
        Caption="Settings"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.92
        WinLeft=0.684375
        WinWidth=0.315625
        WinHeight=0.05
        TabOrder=6
        OnClick=DHGUITeamSelection.InternalOnClick
        OnKeyEvent=DHGUITeamSelection.InternalOnKeyEvent
    End Object
    b_Settings=SettingsButtonObject

    // Background
    Begin Object Class=BackgroundImage Name=PageBackground
        Image=Texture'DH_GUI_Tex.Menu.Teamselect'
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
