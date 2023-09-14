//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_ServerRulesPanel extends UT2K4Tab_ServerRulesPanel;

var GUIController localController;
var automated GUISectionBackground sb_background;

// **************************************************************************************************************************************************************************
// Add a new rule to the GUIMultiOptionList
function AddRule(PlayInfo.PlayInfoData NewRule, int Index)
{
    local bool bTemp;
    local string        Width, Op;
    local array<string> Range;
    local moComboBox    co;
    local moFloatEdit   fl;
    local moEditBox     ed;
    local moCheckbox    ch;
    local moNumericEdit nu;
    local moButton      bu;
    local int           i, pos;

    bTemp = Controller.bCurMenuInitialized;
    Controller.bCurMenuInitialized = false;

    switch (NewRule.RenderType)
    {
        case PIT_Check:
            ch = moCheckbox(li_Rules.AddItem("DH_Interface.DHmoCheckbox",,NewRule.DisplayName, true));
            if (ch == none)
                break;

            ch.Tag = Index;
            ch.bAutoSizeCaption = true;
            break;

        case PIT_Select:
            co = moCombobox(li_Rules.AddItem("DH_Interface.DHmoComboBox",,NewRule.DisplayName, true));
            if (co == none)
                break;

            co.ReadOnly(true);
            co.bAutoSizeCaption = true;
            co.Tag = Index;
            co.CaptionWidth = 0.5;
            GamePI.SplitStringToArray(Range, NewRule.Data, ";");
            for (i = 0; i+1 < Range.Length; i += 2)
                co.AddItem(Range[i+1],,Range[i]);

            break;

        case PIT_Text:
            if (!Divide(NewRule.Data, ";", Width, Op))
                Width = NewRule.Data;

            pos = InStr(Width, ",");
            if (pos != -1)
                Width = Left(Width, pos);

            if (Width != "")
                i = int(Width);
            else i = -1;
            GamePI.SplitStringToArray(Range, Op, ":");
            if (Range.Length > 1)
            {
                // Ranged data
                if (InStr(Range[0], ".") != -1)
                {
                    // float edit
                    fl = moFloatEdit(li_Rules.AddItem("DH_Interface.DHmoFloatEdit",,NewRule.DisplayName, true));
                    if (fl == none) break;
                    fl.Tag = Index;
                    fl.bAutoSizeCaption = true;
                    fl.ComponentWidth = 0.25;
                    if (i != -1)
                        fl.Setup(float(Range[0]), float(Range[1]), fl.MyNumericEdit.Step);
                }

                else
                {
                    nu = moNumericEdit(li_Rules.AddItem("DH_Interface.DHmoNumericEdit",,NewRule.DisplayName, true));
                    if (nu == none) break;
                    nu.Tag = Index;
                    nu.bAutoSizeCaption = true;
                    nu.ComponentWidth = 0.25;
                    if (i != -1)
                        nu.Setup(int(Range[0]), int(Range[1]), nu.MyNumericEdit.Step);
                }
            }
            else if (NewRule.ArrayDim != -1)
            {
                bu = moButton(li_Rules.AddItem("DH_Interface.DHmoButton",,NewRule.DisplayName, true));
                if (bu == none) break;
                bu.Tag = Index;
                bu.bAutoSizeCaption = true;
                bu.ComponentWidth = 0.25;
                bu.OnChange = ArrayPropClicked;
            }

            else
            {
                ed = moEditbox(li_Rules.AddItem("DH_Interface.DHmoEditBox",,NewRule.DisplayName, true));
                if (ed == none) break;
                ed.Tag = Index;
                ed.bAutoSizeCaption = true;
                if (i != -1)
                    ed.MyEditBox.MaxWidth = i;
            }
            break;

        default:
            bu = moButton(li_Rules.AddItem("DH_Interface.DHmoButton",,NewRule.DisplayName, true));
            if (bu == none) break;
            bu.Tag = Index;
            bu.bAutoSizeCaption = true;
            bu.ComponentWidth = 0.25;
            bu.OnChange = CustomClicked;
    }

    Controller.bCurMenuInitialized = bTemp;
}

// ************************************************************************************************************************************************************************************

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
        localController = MyController;
        super(IAMultiColumnRulesPanel).InitComponent(MyController, MyOwner);
        RemoveComponent(b_Symbols);
        sb_background.ManageComponent(lb_Rules);
        sb_background.ManageComponent(nu_Port);
        sb_background.ManageComponent(ch_Webadmin);
        sb_background.ManageComponent(ch_LANServer);
        sb_background.ManageComponent(ch_Advanced);
}

function Refresh()
{
        super.Refresh();

        sb_background.ManageComponent(lb_Rules);
}

defaultproperties
{
    Begin Object Class=DHGUIProportionalContainer Name=myBackgroundGroup
        bNoCaption=true
        WinTop=0.036614
        WinLeft=0.025156
        WinWidth=0.949688
        WinHeight=0.9
        OnPreDraw=myBackgroundGroup.InternalPreDraw
    End Object
    sb_Background=DHGUIProportionalContainer'DH_Interface.DHTab_ServerRulesPanel.myBackgroundGroup'
    Begin Object Class=DHmoCheckBox Name=EnableWebadmin
        Caption="Enable WebAdmin"
        OnCreateComponent=EnableWebadmin.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.9
        WinLeft=0.55
        WinWidth=0.4
        WinHeight=0.04
        TabOrder=4
        OnChange=DHTab_ServerRulesPanel.Change
        OnLoadINI=DHTab_ServerRulesPanel.InternalOnLoadINI
    End Object
    ch_Webadmin=DHmoCheckBox'DH_Interface.DHTab_ServerRulesPanel.EnableWebadmin'
    Begin Object Class=DHmoCheckBox Name=LANServer
        Caption="LAN Server"
        OnCreateComponent=LANServer.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.95
        WinLeft=0.05
        WinWidth=0.4
        WinHeight=0.04
        TabOrder=3
        OnChange=DHTab_ServerRulesPanel.Change
        OnLoadINI=DHTab_ServerRulesPanel.InternalOnLoadINI
    End Object
    ch_LANServer=DHmoCheckBox'DH_Interface.DHTab_ServerRulesPanel.LANServer'
    Begin Object Class=DHmoNumericEdit Name=WebadminPort
        MinValue=1
        MaxValue=65536
        CaptionWidth=0.7
        ComponentWidth=0.3
        Caption="WebAdmin Port"
        OnCreateComponent=WebadminPort.InternalOnCreateComponent
        IniOption="@Internal"
        WinTop=0.95
        WinLeft=0.55
        WinWidth=0.4
        WinHeight=0.04
        TabOrder=5
        OnChange=DHTab_ServerRulesPanel.Change
        OnLoadINI=DHTab_ServerRulesPanel.InternalOnLoadINI
    End Object
    nu_Port=DHmoNumericEdit'DH_Interface.DHTab_ServerRulesPanel.WebadminPort'
    Begin Object Class=DHmoCheckBox Name=AdvancedButton
        Caption="View Advanced Options"
        OnCreateComponent=AdvancedButton.InternalOnCreateComponent
        WinTop=0.9
        WinLeft=0.05
        WinWidth=0.4
        WinHeight=0.04
        RenderWeight=1.0
        TabOrder=1
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_ServerRulesPanel.InternalOnChange
    End Object
    ch_Advanced=DHmoCheckBox'DH_Interface.DHTab_ServerRulesPanel.AdvancedButton'
    i_bk=none
    Begin Object Class=DHGUIMultiOptionListBox Name=RuleListBox
        SelectedStyleName="DHListSelectionStyle"
        bVisibleWhenEmpty=true
        OnCreateComponent=DHTab_ServerRulesPanel.ListBoxCreateComponent
        StyleName="DHNoBox"
        WinHeight=0.85
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHTab_ServerRulesPanel.InternalOnChange
    End Object
    lb_Rules=DHGUIMultiOptionListBox'DH_Interface.DHTab_ServerRulesPanel.RuleListBox'
}
