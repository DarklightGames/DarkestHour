//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
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
var localized string    BanText;
var localized string    PromoteText;
var localized string    AssistantText;
var localized string    RescindAssistantText;
var localized string    VolunteerToAssistText;
var localized string    MergeRequestText;

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
    local DHSquadReplicationInfo SRI;
    local int Index;

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return false;
    }

    MyPRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    OtherPRI = DHPlayerReplicationInfo(li_Members.GetObject());
    SRI = PC.SquadReplicationInfo;

    if (MyPRI == none || OtherPRI == none || SRI == none || MyPRI == OtherPRI)
    {
        return false;
    }

    Sender.ContextItems.Length = 0;

    if (MyPRI.SquadIndex == SquadIndex)
    {
        if (MyPRI.IsSquadLeader())
        {
            // Kick & ban
            Sender.AddItem(Repl(default.KickText, "{0}", OtherPRI.PlayerName));
            Sender.AddItem(Repl(default.BanText, "{0}", OtherPRI.PlayerName));

            // Promote to leader
            Sender.AddItem("-");
            Sender.AddItem(Repl(default.PromoteText, "{0}", OtherPRI.PlayerName));

            // Assign and unassign assistant
            Sender.AddItem("-");

            if (OtherPRI.bIsSquadAssistant)
            {
                Sender.AddItem(Repl(default.RescindAssistantText, "{0}", OtherPRI.PlayerName));
            }
            else
            {
                Sender.AddItem(Repl(default.AssistantText, "{0}", OtherPRI.PlayerName));
            }
        }
        else
        {
            Index = li_Members.GetIndexByObject(li_Members.GetObject());

            if (Index == 0 && !SRI.HasAssistant(PC.GetTeamNum(), MyPRI.SquadIndex))
            {
                Sender.AddItem(Repl(default.VolunteerToAssistText, "{0}", OtherPRI.PlayerName));
            }
        }
    }
    else
    {
        // We have selected another squad.
        if (MyPRI.IsSquadLeader() && OtherPRI.IsSquadLeader())
        {
            // We have selected another squad's leader.
            Sender.AddItem(default.MergeRequestText);
        }
    }

    return Sender.ContextItems.Length > 0;
}

function bool MembersListContextMenuClose(GUIContextMenu Sender)
{
    return true;
}

function MembersListContextMenuSelect(GUIContextMenu Sender, int ClickIndex)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo MyPRI, PRI;

    PC = DHPlayer(PlayerOwner());

    if (PC == none || PC.SquadReplicationInfo == none)
    {
        return;
    }

    MyPRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    PRI = DHPlayerReplicationInfo(li_Members.GetObject());

    if (MyPRI == none || PRI == none)
    {
        return;
    }

    if (MyPRI.SquadIndex == SquadIndex)
    {
        if (MyPRI.IsSquadLeader())
        {
            switch (ClickIndex)
            {
                case 0: // Kick
                    PC.ServerSquadKick(PRI);
                    break;
                case 1: // Ban
                    PC.ServerSquadBan(PRI);
                    break;
                case 3: // Promote
                    PC.ServerSquadPromote(PRI);
                    break;
                case 5:
                    if (PRI.bIsSquadAssistant)
                    {
                        // Remove assistant
                        PC.ServerSquadMakeAssistant(none);
                    }
                    else
                    {
                        // Make assistant
                        PC.ServerSquadMakeAssistant(PRI);
                    }
                    break;
            }
        }
        else
        {
            // Non-squad leader menu.
            switch (ClickIndex)
            {
                case 0: // volunteer
                    PC.ServerSquadVolunteerToAssist();
                    break;
            }
        }
    }
    else
    {
        if (MyPRI.IsSquadLeader() && PRI.IsSquadLeader())
        {
            switch (ClickIndex)
            {
                case 0:
                    PC.ServerSendSquadMergeRequest(SquadIndex);
                    break;
            }
        }
    }
}

defaultproperties
{
    Begin Object Class=DHGUIButton Name=LockSquadButton
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.15
        WinHeight=0.075
        WinLeft=0.1
        WinTop=0.05
        OnClick=OnClick
    End Object
    b_LockSquad=LockSquadButton

    Begin Object class=GUIImage Name=LockSquadImage
        WinWidth=0.15
        WinHeight=0.075
        WinLeft=0.1
        WinTop=0.05
        Image=Texture'DH_InterfaceArt2_tex.Icons.lock'
        ImageColor=(R=255,G=255,B=255,A=255)
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
        Image=Texture'DH_GUI_tex.DeployMenu.squad_panel'
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
        SelectedStyleName="DHItemLargeOutline"
        StyleName="DHLargeText"
        bVisibleWhenEmpty=false
        bSorted=false
        //OnChange=none
        WinWidth=0.8
        WinHeight=0.7
        WinLeft=0.1
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
        WinTop=0.05
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
        WinHeight=0.15
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
        WinHeight=0.15
        WinLeft=0.0
        WinTop=0.80
        OnClick=OnClick
    End Object
    b_LeaveSquad=LeaveSquadButton

    Begin Object Class=DHGUIButton Name=JoinSquadButton
        Caption="Join Squad"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=1.0
        WinHeight=0.15
        WinLeft=0.0
        WinTop=0.80
        OnClick=OnClick
    End Object
    b_JoinSquad=JoinSquadButton

    OnShow=InternalOnShow

    KickText="Kick {0}"
    BanText="Ban {0}"
    PromoteText="Promote {0} to squad leader"
    AssistantText="Assign {0} as assistant"
    RescindAssistantText="Unassign {0} as assistant"
    VolunteerToAssistText="Volunteer as assistant"
    MergeRequestText="Request to merge squads"
}

