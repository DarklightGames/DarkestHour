//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHGUISquadComponent extends GUIPanel;

var int SquadIndex;
var bool bIsEditingName;

var automated   DHGUIListBox        lb_Members;
var             DHGUIList           li_Members;
var automated   GUILabel            l_SquadName;
var automated   DHGUIButton         b_CreateSquad;  // Creates a squad. Only show if squad slot is empty.
var automated   DHGUIButton         b_JoinSquad;    // Joins the squad. Only show to non-members. Disable if squad is full or locked.
var automated   DHGUIButton         b_LeaveSquad;   // Leaves the squad. Only show to members of this squad.
var automated   DHGUIButton         b_LockSquad;    // Locks and unlocks the squad. Only show to squad leader.
var automated   GUIImage            i_LockSquad;
var automated   GUIImage            i_Locked;       // Show this when the squad is locked an the user is not a member of this squad.
var automated   DHGUIEditBox        eb_SquadName;
var automated   GUIImage            i_Background;

var localized string    KickText;
var localized string    PromoteText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    li_Members = DHGUIList(lb_Members.List);
    li_Members.bAllowEmptyItems = true;

    if (lb_Members.ContextMenu != none)
    {
        lb_Members.ContextMenu.OnOpen = MembersListContextMenuOpen;
        lb_Members.ContextMenu.OnClose = MembersListContextMenuClose;
        lb_Members.ContextMenu.OnSelect = MembersListContextMenuSelect;
    }
}

function bool OnClick(GUIComponent Sender)
{
    local DHPlayer PC;

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return false;
    }

    switch (Sender)
    {
        case b_CreateSquad:
            PC.ServerSquadCreate();
            return true;
        case b_JoinSquad:
            PC.ServerSquadJoin(PC.GetTeamNum(), SquadIndex);
            return true;
        case b_LeaveSquad:
            PC.ServerSquadLeave();
            return true;
        case b_LockSquad:
            if (PC.SquadReplicationInfo != none)
            {
                PC.ServerSquadLock(!PC.SquadReplicationInfo.IsSquadLocked(PC.GetTeamNum(), SquadIndex));
            }
            return true;
        default:
            break;
    }
}

function InternalOnShow()
{
    super.InternalOnShow();

    Timer();
}

function OnSquadNameEditBoxActivate()
{
    eb_SquadName.TextStr = l_SquadName.Caption;
    eb_SquadName.InternalActivate();

    l_SquadName.SetVisibility(false);

    bIsEditingName = true;
}

function OnSquadNameEditBoxDeactivate()
{
    eb_SquadName.TextStr = "";
    eb_SquadName.InternalDeactivate();

    l_SquadName.SetVisibility(true);

    FocusFirst(none);

    bIsEditingName = false;
}

function OnSquadNameEditBoxEnter()
{
    local DHPlayer PC;

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        l_SquadName.Caption = eb_SquadName.TextStr;

        PC.ServerSquadRename(eb_SquadName.TextStr);
    }

    OnSquadNameEditBoxDeactivate();
}

function bool MembersListContextMenuOpen(GUIContextMenu Sender)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo MyPRI, OtherPRI;

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return false;
    }

    MyPRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    OtherPRI = DHPlayerReplicationInfo(li_Members.GetObject());

    if (MyPRI == none || OtherPRI == none || MyPRI == OtherPRI || MyPRI.SquadIndex != SquadIndex || !MyPRI.IsSquadLeader())
    {
        return false;
    }

    Sender.ContextItems.Length = 0;
    Sender.AddItem(Repl(default.KickText, "{0}", OtherPRI.PlayerName));
    Sender.AddItem("-");
    Sender.AddItem(Repl(default.PromoteText, "{0}", OtherPRI.PlayerName));

    return true;
}

function bool MembersListContextMenuClose(GUIContextMenu Sender)
{
    return true;
}

function MembersListContextMenuSelect(GUIContextMenu Sender, int ClickIndex)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return;
    }

    if (PC.SquadReplicationInfo == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(li_Members.GetObject());

    Log(PRI);

    if (PRI == none)
    {
        return;
    }

    switch (ClickIndex)
    {
        case 0: // Kick
            PC.ServerSquadKick(PRI);
            break;
        case 2: // Promote
            PC.ServerSquadPromote(PRI);
            break;
    }
}

defaultproperties
{
    Begin Object Class=DHGUIButton Name=LockSquadButton
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.2
        WinHeight=0.1
        WinLeft=0.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_LockSquad=LockSquadButton

    Begin Object class=GUIImage Name=LockSquadImage
        WinWidth=0.1
        WinHeight=0.05
        WinLeft=0.05
        WinTop=0.025
        Image=texture'DH_GUI_tex.DeployMenu.lock'
        ImageColor=(R=255,G=255,B=255,A=255);
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
        bBoundToParent=true
        bScaleToParent=true
        RenderWeight=10.0
    End Object
    i_LockSquad=LockSquadImage

    Begin Object class=GUIImage Name=BackgroundImage
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        Image=texture'DH_GUI_tex.DeployMenu.squad_panel'
        ImageColor=(R=255,G=255,B=255,A=255);
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Stretched
        bBoundToParent=true
        bScaleToParent=true
    End Object
    i_Background=BackgroundImage

    Begin Object Class=GUIContextMenu Name=MembersListContextMenu
        OnSelect=DHGUISquadComponent.MembersListContextMenuSelect
        OnOpen=DHGUISquadComponent.MembersListContextMenuOpen
        OnClose=DHGUISquadComponent.MembersListContextMenuClose
    End Object

    Begin Object Class=DHGUIListBox Name=MembersList
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHLargeText"
        bVisibleWhenEmpty=false
        bSorted=false
        //OnChange=none
        WinWidth=0.9
        WinHeight=0.7
        WinLeft=0.05
        WinTop=0.15
        bVisible=false
        ContextMenu=GUIContextMenu'DH_Interface.DHGUISquadComponent.MembersListContextMenu'
    End Object
    lb_Members=MembersList

    Begin Object Class=DHGUIButton Name=CreateSquadButton
        Caption="Create Squad"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_CreateSquad=CreateSquadButton

    Begin Object Class=GUILabel Name=SquadNameLabel
        WinHeight=0.1
        WinWidth=1.0
        WinTop=0.0
        WinLeft=0.00
        TextAlign=TXTA_Center
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_SquadName=SquadNameLabel

    Begin Object Class=DHGUIEditBox Name=SquadNameEditBox
        Caption=""
        CaptionAlign=TXTA_Center
        StyleName="DHLargeEditBox"
        WinTop=0.0
        WinLeft=0.2
        WinHeight=0.1
        WinWidth=0.6
        TabOrder=0
        OnActivate=OnSquadNameEditBoxActivate
        OnDeactivate=OnSquadNameEditBoxDeactivate
        OnEnter=OnSquadNameEditBoxEnter
        MaxWidth=16
    End Object
    eb_SquadName=SquadNameEditBox

    Begin Object Class=DHGUIButton Name=LeaveSquadButton
        Caption="Leave Squad"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.1
        WinLeft=0.0
        WinTop=0.9
        OnClick=OnClick
    End Object
    b_LeaveSquad=LeaveSquadButton

    Begin Object Class=DHGUIButton Name=JoinSquadButton
        Caption="Join Squad"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.1
        WinLeft=0.0
        WinTop=0.9
        OnClick=OnClick
    End Object
    b_JoinSquad=JoinSquadButton

    OnShow=InternalOnShow

    KickText="Kick {0}"
    PromoteText="Promote {0} to leader"
}
