//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapVotingPage extends MapVotingPage;

var localized string                lmsgMapQAFailed;

function bool AlignBK(Canvas C)
{
    i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
    i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
    i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
    i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();

    return false;
}

function SendVote(GUIComponent Sender)
{
    local int MapIndex, GameConfigIndex;

    if (Sender == lb_VoteCountListBox.List)
    {
        MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();

        if (MapIndex > -1)
        {
            GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();

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

            if(MVRI.MapList[MapIndex].bEnabled || PlayerOwner().PlayerReplicationInfo.bAdmin)
            {
                MVRI.SendMapVote(MapIndex,GameConfigIndex);

                // Theel:
                //if (level has failed QA)
                    // vote succedes, but lets send a client message to let them know their vote is silent
                    // PlayerOwner().ClientMessage(lmsgMapQAFailed);
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
    lmsgMapQAFailed="Because this map has failed quality assurance, this vote is silent."

    Begin Object class=DHMapVoteMultiColumnListBox Name=MapListBox
        WinWidth=0.96
        WinHeight=0.293104
        WinLeft=0.02
        WinTop=0.371020
        bVisibleWhenEmpty=true
        StyleName="ServerBrowserGrid"
        bScaleToParent=True
        bBoundToParent=True
        FontScale=FNS_Small
        HeaderColumnPerc(0)=0.2
        HeaderColumnPerc(1)=0.15
        HeaderColumnPerc(2)=0.15
        HeaderColumnPerc(3)=0.15
        HeaderColumnPerc(4)=0.2
        HeaderColumnPerc(5)=0.15
    End Object
    lb_MapListBox=DHMapVoteMultiColumnListBox'DH_Interface.DHMapVotingPage.MapListBox'
    Begin Object class=MapVoteCountMultiColumnListBox Name=VoteCountListBox
        HeaderColumnPerc(0)=0.4
        HeaderColumnPerc(1)=0.2
        DefaultListClass="DH_Interface.DHMapVoteCountMultiColumnList"
        bVisibleWhenEmpty=true
        OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
        WinTop=0.077369
        WinLeft=0.02
        WinWidth=0.96
        WinHeight=0.26752
        bBoundToParent=true
        bScaleToParent=true
        OnRightClick=VoteCountListBox.InternalOnRightClick
    End Object
    lb_VoteCountListBox=MapVoteCountMultiColumnListBox'DH_Interface.DHMapVotingPage.VoteCountListBox'
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
