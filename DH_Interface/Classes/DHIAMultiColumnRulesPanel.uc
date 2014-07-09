// *************************************************************************
//
//	***   DHIAMultiColumnRulesPanel   ***
//
// *************************************************************************

class DHIAMultiColumnRulesPanel extends IAMultiColumnRulesPanel;

var GUIController localController;
var automated GUISectionBackground sb_background;
delegate OnDifficultyChanged(int index, int tag);

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
    Controller.bCurMenuInitialized = False;

    switch (NewRule.RenderType)
    {
        case PIT_Check:
            ch = moCheckbox(li_Rules.AddItem("DH_Interface.DHmoCheckbox",,NewRule.DisplayName, True));
            if (ch == None)
                break;

            ch.Tag = Index;
            ch.bAutoSizeCaption = True;
            break;

        case PIT_Select:
            co = moCombobox(li_Rules.AddItem("DH_Interface.DHmoComboBox",,NewRule.DisplayName, True));
            if (co == None)
                break;

            co.ReadOnly(True);
            co.bAutoSizeCaption = True;
            co.Tag = Index;
            co.CaptionWidth=0.5;
            GamePI.SplitStringToArray(Range, NewRule.Data, ";");
            for (i = 0; i+1 < Range.Length; i += 2)
                co.AddItem(Range[i+1],,Range[i]);

            break;

        case PIT_Text:
        	if ( !Divide(NewRule.Data, ";", Width, Op) )
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
                    fl = moFloatEdit(li_Rules.AddItem("DH_Interface.DHmoFloatEdit",,NewRule.DisplayName, True));
                    if (fl == None) break;
                    fl.Tag = Index;
                    fl.bAutoSizeCaption = True;
                    fl.ComponentWidth = 0.25;
                    if (i != -1)
                        fl.Setup( float(Range[0]), float(Range[1]), fl.MyNumericEdit.Step);
                }

                else
                {
                    nu = moNumericEdit(li_Rules.AddItem("DH_Interface.DHmoNumericEdit",,NewRule.DisplayName, True));
                    if (nu == None) break;
                    nu.Tag = Index;
                    nu.bAutoSizeCaption = True;
                    nu.ComponentWidth = 0.25;
                    if (i != -1)
                        nu.Setup( int(Range[0]), int(Range[1]), nu.MyNumericEdit.Step);
                }
            }
            else if (NewRule.ArrayDim != -1)
            {
                bu = moButton(li_Rules.AddItem("DH_Interface.DHmoButton",,NewRule.DisplayName, True));
                if (bu == None) break;
                bu.Tag = Index;
                bu.bAutoSizeCaption = True;
	bu.ButtonStyleName="DHSmallTextButtonStyle";
                bu.ComponentWidth = 0.25;
                bu.OnChange = ArrayPropClicked;
            }

            else
            {
                ed = moEditbox(li_Rules.AddItem("DH_Interface.DHmoEditBox",,NewRule.DisplayName, True));
                if (ed == None) break;
                ed.Tag = Index;
                ed.bAutoSizeCaption = True;
                if (i != -1)
                    ed.MyEditBox.MaxWidth = i;
            }
            break;

        default:
            bu = moButton(li_Rules.AddItem("DH_Interface.DHmoButton",,NewRule.DisplayName, True));
            if (bu == None) break;
            bu.Tag = Index;
            bu.bAutoSizeCaption = True;
	bu.ButtonStyleName="DHSmallTextButtonStyle";
            bu.ComponentWidth = 0.25;
            bu.OnChange = CustomClicked;
    }

    Controller.bCurMenuInitialized = bTemp;
}

// ************************************************************************************************************************************************************************************

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    	localController = MyController;
    	Super.InitComponent(MyController, MyOwner);
    	RemoveComponent(b_Symbols);
    	sb_background.ManageComponent(ch_Advanced);
    	sb_background.ManageComponent(lb_Rules);
}

function UpdateSymbolButton()
{
	b_Symbols=None;
}

function InternalOnChange(GUIComponent Sender)
{
    	local DHmoComboBox combo;

    	if (GUIMultiOptionList(Sender) != None)
	{
		if (Controller.bCurMenuInitialized)
		{
		    combo = DHmoComboBox(GUIMultiOptionList(Sender).Get());
		    if (combo != none)
		        OnDifficultyChanged(combo.getIndex(), combo.tag);
		}
    	}
    	Super.InternalOnChange(Sender);
}

defaultproperties
{
     Begin Object Class=DHGUIProportionalContainer Name=myBackgroundGroup
         bNoCaption=True
         WinTop=0.036614
         WinLeft=0.025156
         WinWidth=0.949688
         WinHeight=0.900000
         OnPreDraw=myBackgroundGroup.InternalPreDraw
     End Object
     sb_Background=DHGUIProportionalContainer'DH_Interface.DHIAMultiColumnRulesPanel.myBackgroundGroup'

     Begin Object Class=DHmoCheckBox Name=AdvancedButton
         Caption="View Advanced Options"
         OnCreateComponent=AdvancedButton.InternalOnCreateComponent
         WinTop=0.948334
         WinLeft=0.000000
         WinWidth=0.350000
         WinHeight=0.040000
         RenderWeight=1.000000
         TabOrder=1
         bBoundToParent=True
         bScaleToParent=True
         OnChange=DHIAMultiColumnRulesPanel.InternalOnChange
     End Object
     ch_Advanced=DHmoCheckBox'DH_Interface.DHIAMultiColumnRulesPanel.AdvancedButton'

     i_bk=None

     Begin Object Class=DHGUIMultiOptionListBox Name=RuleListBox
         SelectedStyleName="DHListSelectionStyle"
         SectionStyleName="DHNoBox"
         bVisibleWhenEmpty=True
         OnCreateComponent=UT2K4PlayInfoPanel.ListBoxCreateComponent
         StyleName="DHNoBox"
         WinHeight=0.930009
         TabOrder=0
         bBoundToParent=True
         bScaleToParent=True
         OnChange=UT2K4PlayInfoPanel.InternalOnChange
     End Object
     lb_Rules=DHGUIMultiOptionListBox'DH_Interface.DHIAMultiColumnRulesPanel.RuleListBox'

}
