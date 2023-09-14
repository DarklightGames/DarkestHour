//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFilterEdit extends LargeWindow;

var automated GUISectionBackground sb_Options, sb_Mutators;
var automated moEditBox eb_Name;
var automated moComboBox cb_Stats, cb_WeaponStay, cb_Translocator, cb_Mutators;
// if _RO_
var automated moCheckBox ck_VACOnly;
// end if _RO_
var automated moCheckBox ck_Full, ck_Bots, ck_Empty, ck_Passworded;
var automated GUIButton b_Ok, b_Cancel;
var automated GUIMultiOptionListBox lb_Mutators;
var GUIMultiOptionList              li_Mutators;

var int             FilterIndex;
var BrowserFilters  FM;

var UT2K4_FilterListPage FLP;

var localized string ComboOpts[3];
var localized string MutOpts[3];

var array<CacheManager.MutatorRecord>           MutRecords;

var bool bInitialized;

function AddSystemMenu(){}

function InitComponent(GUIController MyC, GUIComponent MyO)
{
    local moComboBox CB;
    local int i;

    super.InitComponent(MyC, MyO);

    FLP = DHFilterListPage(ParentPage);

    sb_Options.ManageComponent(ck_Full);
    sb_Options.ManageComponent(ck_Empty);
    sb_Options.ManageComponent(ck_Passworded);
    sb_Options.ManageComponent(ck_Bots);
    sb_Options.ManageComponent(cb_Stats);
    sb_Options.ManageComponent(ck_VACOnly);
    RemoveComponent(cb_WeaponStay);
    RemoveComponent(cb_Translocator);
    sb_Options.ManageComponent(cb_Mutators);

    for (i = 0; i < 3; ++i)
    {
        cb_Stats.AddItem(ComboOpts[i]);
        cb_WeaponStay.AddItem(ComboOpts[i]);
        cb_Translocator.AddItem(ComboOpts[i]);
    }

    cb_Mutators.AddItem(MutOpts[0]);
    cb_Mutators.AddItem(MutOpts[1]);
    cb_Mutators.AddItem(MutOpts[2]);

    li_Mutators = lb_Mutators.List;

    sb_Mutators.ManageComponent(lb_Mutators);

    class'CacheManager'.static.GetMutatorList(MutRecords);

    for (i = 0; i < MutRecords.Length; ++i)
    {
        cb = moComboBox(li_Mutators.AddItem("DH_Interface.DHmoCombobox",,MutREcords[i].FriendlyName));
        cb.AddItem(ComboOpts[0]);
        cb.AddItem(ComboOpts[1]);
        cb.AddItem(ComboOpts[2]);
        cb.ReadOnly(true);
    }

    cb_Mutators.OnChange = MutChange;
    lb_Mutators.DisableMe();

}

event HandleParameters(string Param1, string Param2)
{
    local array<CustomFilter.AFilterRule> Rules;
    local MasterServerClient.QueryData  FilterItem;
    local int i;

    FilterIndex = int(Param1);
    eb_Name.SetComponentValue(Param2);

    if (Param2~="Default")
        eb_Name.DisableMe();
    else
        eb_Name.EnableMe();

    //Get the custom filter
    Rules = FLP.FM.GetFilterRules(FilterIndex);

    for (i = 0; i < Rules.Length; ++i)
    {
        FilterItem = Rules[i].FilterItem;
        if (FilterItem.Key~="currentplayers" && FilterItem.Value=="0" && FilterItem.QueryType==QT_GreaterThan)
            ck_Empty.Checked(true);

        if (FilterItem.Key~="password" && FilterItem.Value=="false" && FilterItem.QueryType==QT_Equals)
            ck_Passworded.Checked(true);

        if (FilterItem.Key~="freespace" && FilterItem.Value =="0" && FilterItem.QueryType==QT_GreaterThan)
            ck_Full.Checked(true);

        if (FilterItem.Key~="nobots" && FilterItem.Value=="true" && FilterItem.QueryType==QT_Equals)
            ck_Bots.Checked(true);

// if _RO_
        if (FilterItem.Key~="vacsecure" && FilterItem.Value=="true" && FilterItem.QueryType==QT_Equals)
            ck_VACOnly.Checked(true);
// end if _RO_

        if (FilterItem.Key~="stats") //(&& FilterITem.Value=="true")
        {
             if (FilterITem.Value~="true")
                cb_Stats.MyComboBox.SetIndex(1);
            else
                cb_Stats.MyComboBox.SetIndex(2);
        }

        if (FilterItem.Key~="weaponstay")
        {
             if (FilterItem.Value~="true")
                cb_WeaponStay.MyComboBox.SetIndex(1);
            else
                cb_WeaponStay.MyComboBox.SetIndex(2);
        }

        if (FilterItem.Key~="transloc")
        {
             if (FilterItem.Value~="true")
                cb_Translocator.MyComboBox.SetIndex(1);
            else
                cb_Translocator.MyComboBox.SetIndex(2);
        }

        if (FilterItem.Key~="nomutators" && FilterItem.Value=="true")
            cb_Mutators.MyComboBox.SetIndex(0);

        if (FilterItem.Key~="mutator")
        {
            cb_Mutators.MyComboBox.SetIndex(2);

            if (FilterITem.QueryType==QT_Equals)
                SetMutator(FilterItem.Value, 1);
            else if (FilterItem.QueryType==QT_NotEquals)
                SetMutator(FilterItem.Value,2);
        }
    }
}

function SetMutator(string ClassName, int index)
{
    local int i,j;
    local string s;
    local moComboBox box;

    for (i = 0; i < MutRecords.Length; ++i)
    {
        j = Instr(MutRecords[i].ClassName,".");
        s = mid(MutRecords[i].ClassName,j+1);

        if (s ~= ClassName)
        {
            for (j = 0; j < li_Mutators.ItemCount; ++j)
            {
                Box = moComboBox(li_Mutators.GetItem(j));

                if (Box.Caption ~= MutRecords[i].FriendlyName)
                {
                    Box.SetIndex(Index);

                    return;
                }
            }
        }
    }
}

function MutChange(GUIComponent Sender)
{
    if (Sender==cb_Mutators)
    {
        if (cb_Mutators.GetIndex() < 2)
            lb_Mutators.DisableMe();
        else
            lb_Mutators.EnableMe();
    }
}

function bool CancelClick(GUIComponent Sender)
{
    Controller.CloseMenu(true);

    return true;
}

function CustomFilter.AFilterRule BuildRule(string Key, string Value, MasterServerClient.EQueryType qType)
{
    local CustomFilter.AFilterRule NewRule;

    NewRule.FilterItem.Key          = key;
    NewRule.FilterItem.Value        = value;
    NewRule.FilterItem.QueryType    = qtype;

    if (Key=="mutator")
        NewRule.FilterType = DT_Multiple;
    else
        NewRule.FilterType = DT_Unique;

    NewRule.ItemName = Key;

    return NewRule;
}

function bool OkClick(GUIComponent Server)
{
    local array<CustomFilter.AFilterRule> Rules;
    local int cnt,i;
    local moComboBox CB;

    cnt = 0;

    // Build Query lists
    if (ck_Empty.IsChecked())
        Rules[Cnt++] = BuildRule("currentplayers","0",QT_GreaterThan);

    if (ck_Full.IsChecked())
        Rules[Cnt++] = BuildRule("freespace","0",QT_GreaterThan);

    if (ck_Passworded.IsChecked())
        Rules[Cnt++] = BuildRule("password","false",QT_Equals);

    if (ck_Bots.IsChecked())
        Rules[Cnt++] = BuildRule("nobots","true", QT_Equals);

    if (ck_VACOnly.IsChecked())
        Rules[Cnt++] = BuildRule("vacsecure","true", QT_Equals);

    if (cb_Stats.GetIndex()==1)
        Rules[Cnt++] = BuildRule("stats","true", QT_Equals);
    else if (cb_Stats.GetIndex()==2)
        Rules[Cnt++] = BuildRule("stats","false", QT_Equals);

    if (cb_Mutators.GetIndex()==0)
        Rules[Cnt++] = BuildRule("nomutators","true", QT_Equals);

    else if (cb_Mutators.GetIndex()==2)
    {
        for (i = 0; i < li_Mutators.ItemCount; ++i)
        {
            CB = moComboBox(li_Mutators.GetItem(i));

            if (cb.GetIndex() == 1)
                Rules[Cnt++] = BuildRule("mutator",FindMutClassFromFriendly(cb.Caption),QT_Equals);
            else if (cb.GetIndex() == 2)
                Rules[Cnt++] = BuildRule("mutator",FindMutClassFromFriendly(cb.Caption),QT_NotEquals);
        }
    }

    FLP.FM.PostEdit(FilterIndex,eb_Name.GetComponentValue(),Rules);
    Controller.CloseMenu(true);
    FLP.InitFilterList();

    FLP.li_Filters.SetIndex(FLP.li_Filters.Find(eb_Name.GetComponentValue()));

    return true;
}

function string FindMutClassFromFriendly(string friendly)
{
    local string cls;
    local int i, p;

    for (i = 0; i < MutRecords.Length; ++i)
    {
        if (MutRecords[i].FriendlyName ~= Friendly)
        {
            cls = MutRecords[i].ClassName;
            p = Instr(Cls,".");

            return Mid(cls, p + 1);
        }
    }

    return "";
}

function bool ebPreDraw(canvas Canvas)
{
    // Reposition
    eb_Name.WinTop = sb_Options.ActualTop() + 36.0;

    return true;
}

defaultproperties
{
    Begin Object Class=DHGUISectionBackground Name=sbOptions
        bFillClient=true
        Caption="Options..."
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.2
        BottomPadding=0.0025
        ImageOffset(0)=5.0
        ImageOffset(2)=15.0
        ImageOffset(3)=5.0
        NumColumns=2
        WinTop=0.057448
        WinLeft=0.036094
        WinWidth=0.929296
        WinHeight=0.375823
        OnPreDraw=sbOptions.InternalPreDraw
    End Object
    sb_Options=DHGUISectionBackground'DH_Interface.DHFilterEdit.sbOptions'
    Begin Object Class=DHGUISectionBackground Name=sbMutators
        bFillClient=true
        Caption="Custom Mutator Config"
        LeftPadding=0.0025
        RightPadding=0.0025
        TopPadding=0.0025
        BottomPadding=0.0025
        ImageOffset(0)=5.0
        ImageOffset(2)=15.0
        ImageOffset(3)=5.0
        WinTop=0.436614
        WinLeft=0.036094
        WinWidth=0.929296
        WinHeight=0.453948
        OnPreDraw=sbMutators.InternalPreDraw
    End Object
    sb_Mutators=DHGUISectionBackground'DH_Interface.DHFilterEdit.sbMutators'
    Begin Object Class=DHmoEditBox Name=ebName
        ComponentWidth=0.7
        Caption="Filter Name:"
        OnCreateComponent=ebName.InternalOnCreateComponent
        WinTop=0.124114
        WinLeft=0.184531
        WinWidth=0.654297
        TabOrder=0
        OnPreDraw=DHFilterEdit.ebPreDraw
    End Object
    eb_Name=DHmoEditBox'DH_Interface.DHFilterEdit.ebName'
    Begin Object Class=DHmoComboBox Name=cbStats
        bReadOnly=true
        ComponentWidth=0.55
        Caption="Stats Servers:"
        OnCreateComponent=cbStats.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=5
    End Object
    cb_Stats=DHmoComboBox'DH_Interface.DHFilterEdit.cbStats'
    Begin Object Class=DHmoComboBox Name=cbWeaponStay
        bReadOnly=true
        ComponentWidth=0.55
        Caption="Weapon Stay:"
        OnCreateComponent=cbWeaponStay.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=6
    End Object
    cb_WeaponStay=DHmoComboBox'DH_Interface.DHFilterEdit.cbWeaponStay'
    Begin Object Class=DHmoComboBox Name=cbTranslocator
        bReadOnly=true
        ComponentWidth=0.55
        Caption="Translocator:"
        OnCreateComponent=cbTranslocator.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=7
    End Object
    cb_Translocator=DHmoComboBox'DH_Interface.DHFilterEdit.cbTranslocator'
    Begin Object Class=DHmoComboBox Name=cbMutators
        bReadOnly=true
        ComponentWidth=0.55
        Caption="Mutators:"
        OnCreateComponent=cbMutators.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=8
    End Object
    cb_Mutators=DHmoComboBox'DH_Interface.DHFilterEdit.cbMutators'
    Begin Object Class=DHmoCheckBox Name=ckVACOnly
        ComponentWidth=0.1
        Caption="Valve Anti-Cheat Protected Only"
        OnCreateComponent=ckVACOnly.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=1
    End Object
    ck_VACOnly=DHmoCheckBox'DH_Interface.DHFilterEdit.ckVACOnly'
    Begin Object Class=DHmoCheckBox Name=ckFull
        ComponentWidth=0.1
        Caption="No Full Servers"
        OnCreateComponent=ckFull.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=1
    End Object
    ck_Full=DHmoCheckBox'DH_Interface.DHFilterEdit.ckFull'
    Begin Object Class=DHmoCheckBox Name=ckBots
        ComponentWidth=0.1
        Caption="No Bots"
        OnCreateComponent=ckBots.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=2
    End Object
    ck_Bots=DHmoCheckBox'DH_Interface.DHFilterEdit.ckBots'
    Begin Object Class=DHmoCheckBox Name=ckEmpty
        ComponentWidth=0.1
        Caption="No Empty Servers"
        OnCreateComponent=ckEmpty.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=3
    End Object
    ck_Empty=DHmoCheckBox'DH_Interface.DHFilterEdit.ckEmpty'
    Begin Object Class=DHmoCheckBox Name=ckPassworded
        ComponentWidth=0.1
        Caption="No Passworded Servers"
        OnCreateComponent=ckPassworded.InternalOnCreateComponent
        WinTop=0.25
        WinLeft=0.25
        TabOrder=4
    End Object
    ck_Passworded=DHmoCheckBox'DH_Interface.DHFilterEdit.ckPassworded'
    Begin Object Class=GUIButton Name=bOk
        Caption="OK"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.903612
        WinLeft=0.611564
        WinWidth=0.16875
        WinHeight=0.05
        OnClick=DHFilterEdit.OkClick
        OnKeyEvent=bOk.InternalOnKeyEvent
    End Object
    b_OK=GUIButton'DH_Interface.DHFilterEdit.bOk'
    Begin Object Class=GUIButton Name=bCancel
        Caption="Cancel"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.903507
        WinLeft=0.792814
        WinWidth=0.16875
        WinHeight=0.05
        OnClick=DHFilterEdit.CancelClick
        OnKeyEvent=bCancel.InternalOnKeyEvent
    End Object
    b_Cancel=GUIButton'DH_Interface.DHFilterEdit.bCancel'
    Begin Object Class=DHGUIMultiOptionListBox Name=lbMutators
        OnCreateComponent=lbMutators.InternalOnCreateComponent
        WinTop=0.103281
        WinLeft=0.262656
        WinWidth=0.343359
        WinHeight=0.766448
        TabOrder=9
    End Object
    lb_Mutators=DHGUIMultiOptionListBox'DH_Interface.DHFilterEdit.lbMutators'
    ComboOpts(0)="Does Not Matter"
    ComboOpts(1)="Must Be On"
    ComboOpts(2)="Must Be Off"
    MutOpts(0)="No Mutators"
    MutOpts(1)="Any Mutator"
    MutOpts(2)="Custom"
    Begin Object Class=DHGUIHeader Name=TitleBar
        bUseTextHeight=true
        StyleName="DHNoBox"
        WinTop=0.017
        WinHeight=0.05
        RenderWeight=0.1
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=true
        bNeverFocus=false
        ScalingType=SCALE_X
        OnMousePressed=FloatingWindow.FloatingMousePressed
        OnMouseRelease=FloatingWindow.FloatingMouseRelease
    End Object
    t_WindowTitle=DHGUIHeader'DH_Interface.DHFilterEdit.TitleBar'
    WindowName="Edit Filter Rules..."
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.98
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHFilterEdit.FloatingFrameBackground'
    WinTop=0.0
    WinLeft=0.0
    WinWidth=1.0
    WinHeight=1.0
}
