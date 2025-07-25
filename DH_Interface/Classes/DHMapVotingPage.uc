//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapVotingPage extends MapVotingPage;

var localized string                            lmsgMapOutOfBounds;
var localized string                            NoRestartMapPrivilegeText;
var localized string                            NoChangeMapPrivilegeText;

var automated moEditBox ed_Filter;
var automated GUIButton b_FilterClear;

function InternalOnOpen()
{
    super.InternalOnOpen();

    // Fill the filter box in case a pattern is set
    ed_Filter.SetText(DHMapVoteMultiColumnList(lb_MapListBox.List).GetFilterPattern());
}

function bool AlignBK(Canvas C)
{
    i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
    i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
    i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
    i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();

    return false;
}

function ForceMapVote(GUIComponent Sender)
{
    local int MapIndex, GameConfigIndex;
    local DHVotingReplicationInfo DHVRI;

    DHVRI = DHVotingReplicationInfo(MVRI);

    if (DHVRI == none)
    {
        return;
    }

    MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();

    if (MapIndex > -1)
    {
        GameConfigIndex = int(co_GameType.GetExtra());

        DHVRI.ServerForceMapVote(MapIndex,GameConfigIndex);
    }
}

function SendVote(GUIComponent Sender)
{
    local int MapIndex, GameConfigIndex;
    local DHGameReplicationInfo GRI;
    local int Min, Max;
    local DHMapDatabase MDB;
    local DHMapDatabase.SMapInfo MI;

    if (PlayerOwner() == none)
    {
        return;
    }

    MDB = DHPlayer(PlayerOwner()).MapDatabase;
    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    if (MVRI == none || GRI == none)
    {
        return;
    }

    if (Sender == lb_VoteCountListBox.List)
    {
        MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();

        if (MapIndex > -1)
        {
            GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();

            if (MDB.GetMapInfo(MVRI.MapList[MapIndex].MapName, MI))
            {
                Class'DHMapDatabase'.static.GetMapSizePlayerCountRange(MI.Size, Min, Max);

                // Do a check if the current player count is in bounds of recommended range or if level has failed QA
                if (!GRI.IsPlayerCountInRange(Min, Max))
                {
                    PlayerOwner().ClientMessage(lmsgMapOutOfBounds);
                    return;
                }
            }

            if (MVRI.MapList[MapIndex].bEnabled || PlayerOwner().PlayerReplicationInfo.bAdmin)
            {
                MVRI.SendMapVote(MapIndex,GameConfigIndex);
            }
            else
            {
                PlayerOwner().ClientMessage(lmsgMapDisabled);
            }
        }
    }
    else
    {
        MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();

        if (MapIndex > -1)
        {
            GameConfigIndex = int(co_GameType.GetExtra());

            if (MVRI.MapList[MapIndex].bEnabled || PlayerOwner().PlayerReplicationInfo.bAdmin)
            {
                MVRI.SendMapVote(MapIndex,GameConfigIndex);
            }
            else
            {
                PlayerOwner().ClientMessage(lmsgMapDisabled);
            }
        }
    }
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    // Update map list on "key down" event
    if (State == 3)
    {
        DHMapVoteMultiColumnList(lb_MapListBox.List).SetFilterPattern(ed_Filter.GetText());
        return true;
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_FilterClear)
    {
        OnFilterClear();
        return true;
    }
}

delegate OnFilterClear()
{
    ed_Filter.SetText("");
    DHMapVoteMultiColumnList(lb_MapListBox.List).SetFilterPattern("");
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    if (Msg ~= "NOTIFY_GUI_MAP_VOTE_RESULT")
    {
        switch (int(MsgLife))
        {
            case 0:
                Controller.ShowQuestionDialog(NoRestartMapPrivilegeText, QBTN_OK, QBTN_OK);
                break;
            case 1:
                Controller.ShowQuestionDialog(NoChangeMapPrivilegeText, QBTN_OK, QBTN_OK);
                break;

            default:
        }
    }
}

defaultproperties
{
    lmsgMapOutOfBounds="Please vote for a map suitable for the current player count. You can still vote for this map on the full list."

    lmsgMode(0)="Majority Wins"

    Begin Object class=DHMapVoteMultiColumnListBox Name=MapListBox
        WinWidth=0.96
        WinHeight=0.50
        WinLeft=0.02
        WinTop=0.371020
        bVisibleWhenEmpty=true
        StyleName="ServerBrowserGrid"
        bScaleToParent=true
        bBoundToParent=true
        FontScale=FNS_Small
        HeaderColumnPerc(0)=0.40 // Map Name
        HeaderColumnPerc(1)=0.15 // Allied Country
        HeaderColumnPerc(2)=0.15 // Axis Country
        HeaderColumnPerc(3)=0.15 // Type
        HeaderColumnPerc(4)=0.15 // Player Range
    End Object
    lb_MapListBox=DHMapVoteMultiColumnListBox'DH_Interface.MapListBox'

    Begin Object class=DHMapVoteCountMultiColumnListBox Name=VoteCountListBox
        HeaderColumnPerc(0)=0.4 // Nominated Maps
        HeaderColumnPerc(1)=0.3 // Votes
        HeaderColumnPerc(2)=0.3 // Player Range
        DefaultListClass="DH_Interface.DHMapVoteCountMultiColumnList"
        bVisibleWhenEmpty=true
        OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
        StyleName="ServerBrowserGrid"
        WinTop=0.077369
        WinLeft=0.02
        WinWidth=0.96
        WinHeight=0.26752
        bBoundToParent=true
        bScaleToParent=true
        OnRightClick=VoteCountListBox.InternalOnRightClick
    End Object
    lb_VoteCountListBox=DHMapVoteCountMultiColumnListBox'DH_Interface.VoteCountListBox'

    Begin Object Class=moComboBox Name=GameTypeCombo
        CaptionWidth=0.35
        Caption="Filter Game Type:"
        OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
        bScaleToParent=true
        bVisible=false
    End Object
    co_GameType=moComboBox'DH_Interface.GameTypeCombo'

    i_MapListBackground=none
    Begin Object Class=GUIImage Name=MapCountListBackground
        Image=Texture'InterfaceArt_tex.buttonGreyDark01'
        ImageStyle=ISTY_Stretched
        OnDraw=DHMapVotingPage.AlignBK
    End Object
    i_MapCountListBackground=GUIImage'DH_Interface.MapCountListBackground'

    Begin Object class=moEditBox Name=FilterEditbox
        WinWidth=0.86
        WinHeight=0.12
        WinLeft=0.02
        WinTop=0.90
        Caption="Search"
        CaptionWidth=0.074
        OnKeyEvent=InternalOnKeyEvent
        // TabOrder=0
        bScaleToParent=true
        bBoundToParent=true
    End Object
    ed_Filter=FilterEditbox

    Begin Object Class=GUIButton Name=FilterClearButton
        WinWidth=0.08
        WinHeight=0.04
        WinLeft=0.90
        WinTop=0.894
        Caption="Clear"
        FontScale=FNS_Small
        OnClick=InternalOnClick
        // TabOrder=1
        bStandardized=true
        bBoundToParent=true
        bScaleToParent=true
    End Object
    b_FilterClear=FilterClearButton

    f_Chat=none

    OnMessage=InternalOnMessage

    NoRestartMapPrivilegeText="You don't have sufficient admin privileges to restart a map!"
    NoChangeMapPrivilegeText="You don't have sufficient admin privileges to change a map!"
}
