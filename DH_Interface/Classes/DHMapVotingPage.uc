//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapVotingPage extends MapVotingPage;

var localized string                            lmsgMapOutOfBounds;

function bool AlignBK(Canvas C)
{
    i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
    i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
    i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
    i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();

    return false;
}

// Modified to confirm we are voting within bounds (this will need changed)
function SendVote(GUIComponent Sender)
{
    local int                       MapIndex, GameConfigIndex, Min, Max;
    local DHGameReplicationInfo     GRI;
    local JSONObject                MapObject;

    if (PlayerOwner() == none)
    {
        return;
    }

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

            // Parse the JSON object
            MapObject = (new class'JSONParser').ParseObject(MVRI.MapList[MapIndex].MapName);

            // Do a check if the current player count is in bounds of recommended range or if level has failed QA
            if (MapObject != none && MapObject.Get("MinPlayers").AsString() != "" && MapObject.Get("MaxPlayers").AsString() != "")
            {
                Min = MapObject.Get("MinPlayers").AsInteger();
                Max = MapObject.Get("MaxPlayers").AsInteger();

                if (GRI.PRIArray.Length < Min || (GRI.PRIArray.Length > Max && GRI.PRIArray.Length < GRI.MaxPlayers))
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

defaultproperties
{
    lmsgMapOutOfBounds="Please vote for a map suitable for the current player count. You can still vote for this map on the full list."

    lmsgMode(0)="Majority Wins"

    Begin Object class=DHMapVoteMultiColumnListBox Name=MapListBox
        WinWidth=0.96
        WinHeight=0.293104
        WinLeft=0.02
        WinTop=0.371020
        bVisibleWhenEmpty=true
        StyleName="ServerBrowserGrid"
        bScaleToParent=true
        bBoundToParent=true
        FontScale=FNS_Small
        HeaderColumnPerc(0)=0.25 // Map Name
        HeaderColumnPerc(1)=0.2  // Source
        HeaderColumnPerc(2)=0.15 // Country
        HeaderColumnPerc(3)=0.15 // Type
        HeaderColumnPerc(4)=0.25 // Player Range
    End Object
    lb_MapListBox=DHMapVoteMultiColumnListBox'DH_Interface.DHMapVotingPage.MapListBox'
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
    lb_VoteCountListBox=DHMapVoteCountMultiColumnListBox'DH_Interface.DHMapVotingPage.VoteCountListBox'
    Begin Object Class=moComboBox Name=GameTypeCombo
        CaptionWidth=0.35
        Caption="Filter Game Type:"
        OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
        bScaleToParent=true
        bVisible=false
    End Object
    co_GameType=moComboBox'DH_Interface.DHMapVotingPage.GameTypeCombo'
    i_MapListBackground=none
    Begin Object Class=GUIImage Name=MapCountListBackground
        Image=texture'InterfaceArt_tex.Menu.buttonGreyDark01'
        ImageStyle=ISTY_Stretched
        OnDraw=DHMapVotingPage.AlignBK
    End Object
    i_MapCountListBackground=GUIImage'DH_Interface.DHMapVotingPage.MapCountListBackground'
}
