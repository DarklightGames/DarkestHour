//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUISquadComponent extends GUIPanel;

var int SquadIndex;
var bool bIsEditingName;
const SQUAD_INDEX_LOGI = 6;

var DHContextMenu_SquadMembers      MembersListContextMenuWrapper;

var automated   DHGUIListBox        lb_Members;
var             DHGUIList           li_Members;
var automated   GUILabel            l_SquadName;
var automated   DHGUIButton         b_CreateSquadInfantry;  // Creates a squad. Only show if squad slot is empty.
var automated   DHGUIButton         b_CreateSquadArmored;  // Creates a squad. Only show if squad slot is empty.
var automated   DHGUIButton         b_CreateSquadLogistics;  // Creates a squad. Only show if squad slot is empty.
var automated   DHGUIButton         b_JoinSquad;    // Joins the squad. Only show to non-members. Disable if squad is full or locked.
var automated   DHGUIButton         b_LeaveSquad;   // Leaves the squad. Only show to members of this squad.
var automated   DHGUIButton         b_LockSquad;    // Locks and unlocks the squad. Only show to squad leader.
var automated   GUIImage            i_LockSquad;
var automated   GUIImage            i_Locked;       // Show this when the squad is locked an the user is not a member of this squad.
var automated   GUIImage            i_NoRallyPoints;
var automated   GUIImage            i_SquadType;
var automated   DHGUIEditBox        eb_SquadName;
var automated   GUIImage            i_Background;

var Color DarkBackgroundColor;
var Color LightBackgroundColor;

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
        case b_CreateSquadInfantry:
            PC.ServerSquadCreate(class'DHSquadTypeInfantry', SquadIndex);
            return true;
        case b_CreateSquadArmored:
            PC.ServerSquadCreate(class'DHSquadTypeArmored', SquadIndex);
            return true;
        case b_CreateSquadLogistics:
            PC.ServerSquadCreate(class'DHSquadTypeLogistics', SquadIndex);
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
    Sender.ContextItems.Length = 0;

    if (MembersListContextMenuWrapper == none)
    {
        MembersListContextMenuWrapper = new class'DHContextMenu_SquadMembers';
    }

    if (MembersListContextMenuWrapper == none)
    {
        Warn("Failed to spawn squad context menu!");
        return false;
    }

    return MembersListContextMenuWrapper.OnOpen(Sender, self);
}

function bool MembersListContextMenuClose(GUIContextMenu Sender)
{
    return true;
}

function MembersListContextMenuSelect(GUIContextMenu Sender, int ClickIndex)
{
    if (MembersListContextMenuWrapper != none)
    {
        MembersListContextMenuWrapper.OnClick(Sender, self, ClickIndex);
    }
}

function UpdateBackgroundColor(DHPlayerReplicationInfo PRI)
{
    if (SquadIndex == PRI.SquadIndex)
    {
        i_Background.ImageColor = default.LightBackgroundColor;
    }
    else
    {
        i_Background.ImageColor = default.DarkBackgroundColor;
    }
}

defaultproperties
{
    Begin Object Class=DHGUIButton Name=LockSquadButton
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.15
        WinHeight=0.075
        WinLeft=0.78
        WinTop=0.89
        OnClick=OnClick
        bVisible=false
    End Object
    b_LockSquad=LockSquadButton

    Begin Object class=GUIImage Name=LockSquadImage
        WinWidth=0.15
        WinHeight=0.075
        WinLeft=0.78
        WinTop=0.89
        Image=Texture'DH_InterfaceArt2_tex.Icons.lock'
        ImageColor=(R=255,G=255,B=255,A=255)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
        bBoundToParent=true
        bScaleToParent=true
        RenderWeight=10.0
        bVisible=false
    End Object
    i_LockSquad=LockSquadImage

    Begin Object Class=GUIToolTip Name=NoRallyPointsImageTooltip
    End Object

    Begin Object class=GUIImage Name=NoRallyPointsImage
        WinWidth=0.15
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.05
        Image=Texture'DH_InterfaceArt2_tex.Icons.no_rally_point'
        ImageColor=(R=255,G=0,B=0,A=200)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
        bBoundToParent=true
        bScaleToParent=true
        bVisible=false
        RenderWeight=10.0
        bAcceptsInput=true
        ToolTip=NoRallyPointsImageTooltip
        Hint="This squad has had no rally points in a while. Deployment options may be limited!"
    End Object
    i_NoRallyPoints=NoRallyPointsImage

    Begin Object Class=GUIToolTip Name=SquadTypeImageTooltip
    End Object

    Begin Object class=GUIImage Name=SquadTypeImage
        WinWidth=0.10
        // WinHeight=0.075
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        Image=Texture'DH_InterfaceArt2_tex.Icons.no_rally_point'
        ImageColor=(R=192,G=192,B=192,A=200)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
        bBoundToParent=true
        bScaleToParent=true
        bVisible=false
        RenderWeight=10.0
        bAcceptsInput=true
        ToolTip=SquadTypeImageTooltip
        Hint="Infantry, Vehicle or Supply Squad."
    End Object
    i_SquadType=SquadTypeImage

    Begin Object class=GUIImage Name=BackgroundImage
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        Image=Texture'DH_GUI_tex.DeployMenu.squad_panel'
        ImageColor=(R=192,G=192,B=192,A=255)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Stretched
        bBoundToParent=true
        bScaleToParent=true
        bVisible=false
    End Object
    i_Background=BackgroundImage

    Begin Object Class=DHGUIContextMenu Name=MembersListContextMenu
        OnSelect=MembersListContextMenuSelect
        OnOpen=MembersListContextMenuOpen
        OnClose=MembersListContextMenuClose
    End Object

    Begin Object Class=DHGUIListBox Name=MembersList
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemLargeOutline"
        StyleName="DHLargeText"
        bVisibleWhenEmpty=false
        bSorted=false
        //OnChange=none
        WinWidth=0.0
        WinHeight=0.0
        WinLeft=0.0
        WinTop=0.0
        bVisible=false
        ContextMenu=GUIContextMenu'DH_Interface.DHGUISquadComponent.MembersListContextMenu'
    End Object
    lb_Members=MembersList

    Begin Object Class=DHGUIButton Name=CreateSquadButtonInfantry
        CaptionAlign=TXTA_Left
        StyleName="DHSmallTextButtonStyle"
        Caption="Join2"
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_CreateSquadInfantry=CreateSquadButtonInfantry

        Begin Object Class=DHGUIButton Name=CreateSquadButtonArmored
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        Caption="Arm"
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.3
        WinTop=0.0
        OnClick=OnClick
        bVisible=false
    End Object
    b_CreateSquadArmored=CreateSquadButtonArmored

        Begin Object Class=DHGUIButton Name=CreateSquadButtonLogistics
        CaptionAlign=TXTA_Right
        Caption="Logi"
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        OnClick=OnClick
        bVisible=false
    End Object
    b_CreateSquadLogistics=CreateSquadButtonLogistics

    Begin Object Class=GUILabel Name=SquadNameLabel
        WinWidth=0.65
        WinHeight=1.0
        WinTop=0.05
        WinLeft=0.1
        TextAlign=TXTA_Left
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
        WinLeft=0.1
        WinHeight=1.0
        WinWidth=0.65
        TabOrder=0
        OnActivate=OnSquadNameEditBoxActivate
        OnDeactivate=OnSquadNameEditBoxDeactivate
        OnEnter=OnSquadNameEditBoxEnter
        MaxWidth=20
        bVisible=false
    End Object
    eb_SquadName=SquadNameEditBox

    Begin Object Class=DHGUIButton Name=LeaveSquadButton
        Caption="Leave"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_LeaveSquad=LeaveSquadButton

    Begin Object Class=DHGUIButton Name=JoinSquadButton
        Caption="Join"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_JoinSquad=JoinSquadButton

    OnShow=InternalOnShow
    
    DarkBackgroundColor=(R=128,G=128,B=128,A=255)
    LightBackgroundColor=(R=255,G=255,B=255,A=255)
}
