//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGUISquadComponent extends GUIPanel;

var automated   DHGUIListBox        lb_Members;
var             DHGUIList           li_Members;
var automated   GUILabel            l_SquadName;
var automated   DHGUIButton         b_CreateSquad;
var automated   DHGUILargeEditBox   eb_SquadName;

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
            eb_SquadName.Caption = l_SquadName.bVisible;
        default:
            break;
    }
}

defaultproperties
{
    Begin Object Class=DHGUIListBox Name=MembersList
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHLargeText"
        bVisibleWhenEmpty=false
        bSorted=false
        //OnChange=InternalOnChange
        WinWidth=0.9
        WinHeight=0.8
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
    End Object
    eb_SquadName=SquadNameEditBox
}
