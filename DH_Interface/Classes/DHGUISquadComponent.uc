//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGUISquadComponent extends GUIPanel;

var int SquadIndex;

var automated   DHGUIListBox        lb_Members;
var             DHGUIList           li_Members;
var automated   GUILabel            l_SquadName;
var automated   DHGUIButton         b_CreateSquad;
var automated   DHGUIButton         b_JoinSquad;
var automated   DHGUIButton         b_LeaveSquad;
//var automated   DHGUIButton         b_LockSquad;
var automated   DHGUILargeEditBox   eb_SquadName;
var automated   GUIImage            i_Background;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    li_Members = DHGUIList(lb_Members.List);
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
        case eb_SquadName:
            l_SquadName.bVisible = false;
            eb_SquadName.Caption = l_SquadName.Caption;
        case b_JoinSquad:
            PC.ServerSquadJoin(PC.GetTeamNum(), SquadIndex);
            return true;
        case b_LeaveSquad:
            PC.ServerSquadLeave();
            return true;
//        case b_LockSquad:
//            PC.ServerSquadLock(!SRI.IsSquadLocked(PC.GetTeamNum(), SquadIndex));
//            return true;
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
    eb_SquadName.InternalActivate();
    eb_SquadName.Caption = l_SquadName.Caption;

    l_SquadName.SetVisibility(false);
}

function OnSquadNameEditBoxDeactivate()
{
    eb_SquadName.InternalDeactivate();

    l_SquadName.SetVisibility(true);
}

defaultproperties
{
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

    Begin Object Class=DHGUIListBox Name=MembersList
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHLargeText"
        bVisibleWhenEmpty=false
        bSorted=false
        //OnChange=InternalOnChange
        WinWidth=0.9
        WinHeight=0.7
        WinLeft=0.05
        WinTop=0.15
        bVisible=false
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

    Begin Object Class=DHGUILargeEditBox Name=SquadNameEditBox
        Caption=""
        CaptionAlign=TXTA_Center
        StyleName="DHMenuTextButtonStyle"
        //OnCreateComponent=IpEntryBox.InternalOnCreateComponent
        WinTop=0.0
        WinLeft=0.0
        WinHeight=0.1
        WinWidth=1.0
        TabOrder=0
        OnActivate=OnSquadNameEditBoxActivate
        OnDeactivate=OnSquadNameEditBoxDeactivate
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

    //OnHide=InternalOnHide
    OnShow=InternalOnShow
}
