//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUISquadComponent extends GUIPanel;

var int SquadIndex;

var DHContextMenu_SquadMembers      MembersListContextMenuWrapper;

var automated   DHGUIListBox        lb_Members;
var             DHGUIList           li_Members;
var automated   GUILabel            l_SquadName;
var automated   DHGUIButton         b_CreateSquadInfantry;  // Creates a squad. Only show if squad slot is empty.
// var automated   DHGUIButton         b_CreateSquadArmored;  // Creates a squad. Only show if squad slot is empty.
// var automated   DHGUIButton         b_CreateSquadLogistics;  // Creates a squad. Only show if squad slot is empty.
var automated   DHGUIButton         b_JoinSquad;    // Joins the squad. Only show to non-members. Disable if squad is full or locked.
var automated   DHGUIButton         b_LeaveSquad;   // Leaves the squad. Only show to members of this squad.
var automated   DHGUIButton         b_LockSquad;    // Locks and unlocks the squad. Only show to squad leader.
var automated   GUIImage            i_LockSquad;
var automated   GUIImage            i_NoRallyPoints;
var automated   GUIImage            i_SquadType;
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
        // case b_CreateSquadArmored:
        //     PC.ServerSquadCreate(class'DHSquadTypeArmored', SquadIndex);
        //     return true;
        // case b_CreateSquadLogistics:
        //     PC.ServerSquadCreate(class'DHSquadTypeLogistics', SquadIndex);
        //     return true;
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
        WinWidth=0.10
        WinHeight=0.15
        WinLeft=0.08
        WinTop=0.85
        OnClick=OnClick
        bVisible=true
    End Object
    b_LockSquad=LockSquadButton

    Begin Object class=GUIImage Name=LockSquadImage
        WinWidth=0.10
        WinHeight=1.0
        WinLeft=0.10
        WinTop=0.80
        Image=Texture'DH_InterfaceArt2_tex.Icons.lock'
        ImageColor=(R=255,G=255,B=255,A=255)
        ImageRenderStyle=MSTY_Alpha
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
        bBoundToParent=true
        bScaleToParent=true
        RenderWeight=11.0
        bVisible=false
    End Object
    i_LockSquad=LockSquadImage

    Begin Object Class=GUIToolTip Name=NoRallyPointsImageTooltip
    End Object

    Begin Object class=GUIImage Name=NoRallyPointsImage
        // WinWidth=0.15
        // WinHeight=1.0
        // WinLeft=0.8
        // WinTop=0.05

        WinWidth=0.10
        WinHeight=1.0
        WinLeft=0.05
        WinTop=0.80

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
        WinHeight=1.0
        WinLeft=0.03
        WinTop=0.15
        Image=Texture'DH_InterfaceArt2_tex.Icons.binoculars'
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
        Hint="This class can have many classes."
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
        WinLeft=0.05
        WinWidth=0.93
        WinHeight=0.77
        WinTop=0.05
        bVisible=false
        ContextMenu=GUIContextMenu'DH_Interface.DHGUISquadComponent.MembersListContextMenu'
    End Object
    lb_Members=MembersList

    Begin Object Class=DHGUIButton Name=CreateSquadButtonInfantry
        CaptionAlign=TXTA_Right
        StyleName="DHSmallTextButtonStyle"
        Caption="Create"
        WinWidth=0.95
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_CreateSquadInfantry=CreateSquadButtonInfantry

    Begin Object Class=GUILabel Name=SquadNameLabel
        WinWidth=0.87
        WinHeight=1.0
        WinTop=0.00
        WinLeft=0.15
        TextAlign=TXTA_Left
        VertAlign=TXTA_Left
        TextColor=(R=255,G=255,B=255,A=255)
        Hint="            ";
    End Object
    l_SquadName=SquadNameLabel

    Begin Object Class=DHGUIButton Name=LeaveSquadButton
        Caption="Leave"
        CaptionAlign=TXTA_Right
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.4
        WinHeight=0.6
        WinLeft=0.55
        WinTop=0.6
        OnClick=OnClick
    End Object
    b_LeaveSquad=LeaveSquadButton

    Begin Object Class=DHGUIToolTip Name=JoinSquadButtonTooltip
        InitialDelay=0
        ExpirationSeconds=60
        bMultiLine=true
        // StyleName="DHMouseOver"  
    End Object

    Begin Object Class=DHGUIButton Name=JoinSquadButton
        CaptionAlign=TXTA_Right
        StyleName="DHSmallTextButtonStyle"
        Caption="Join"
        WinWidth=0.95
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        OnClick=OnClick
        ToolTip=JoinSquadButtonTooltip
        Hint="            ";
    End Object
    b_JoinSquad=JoinSquadButton

    OnShow=InternalOnShow
    
    DarkBackgroundColor=(R=128,G=128,B=128,A=255)
    LightBackgroundColor=(R=255,G=255,B=255,A=255)
}
