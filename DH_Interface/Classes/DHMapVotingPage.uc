//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMapVotingPage extends MapVotingPage;

function bool AlignBK(Canvas C)
{
    i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
    i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
    i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
    i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();

    return false;
}

defaultproperties
{
     Begin Object Class=MapVoteCountMultiColumnListBox Name=VoteCountListBox
         HeaderColumnPerc(0)=0.400000
         HeaderColumnPerc(1)=0.200000
         DefaultListClass="DH_Interface.DHMapVoteCountMultiColumnList"
         bVisibleWhenEmpty=true
         OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
         WinTop=0.077369
         WinLeft=0.020000
         WinWidth=0.960000
         WinHeight=0.267520
         bBoundToParent=true
         bScaleToParent=true
         OnRightClick=VoteCountListBox.InternalOnRightClick
     End Object
     lb_VoteCountListBox=MapVoteCountMultiColumnListBox'DH_Interface.DHMapVotingPage.VoteCountListBox'

     Begin Object Class=moComboBox Name=GameTypeCombo
         CaptionWidth=0.350000
         Caption="Filter Game Type:"
         OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
         bScaleToParent=true
         bVisible=false
     End Object
     co_GameType=moComboBox'DH_Interface.DHMapVotingPage.GameTypeCombo'

     i_MapListBackground=none

     Begin Object Class=GUIImage Name=MapCountListBackground
         Image=Texture'InterfaceArt_tex.Menu.buttonGreyDark01'
         ImageStyle=ISTY_Stretched
         OnDraw=DHMapVotingPage.AlignBK
     End Object
     i_MapCountListBackground=GUIImage'DH_Interface.DHMapVotingPage.MapCountListBackground'

}
