//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTab_MainSP extends UT2K4Tab_MainSP;

var automated       DHGUISectionBackground  sb_options2;
var automated       DHmoComboBox            co_Difficulty;
var array<float>    Difficulties;
var bool            bHideDifficultyControl;

delegate OnChangeDifficulty(int index);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super(UT2K4GameTabBase).InitComponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);

    if (lb_Maps != none)
    {
        li_Maps = lb_Maps.List;
    }

    if (li_Maps != none)
    {
        li_Maps.OnDblClick = MapListDblClick;
        li_Maps.bSorted = true;
        lb_Maps.NotifyContextSelect = HandleContextSelect;
    }

    lb_Maps.bBoundToParent = false;
    lb_Maps.bScaleToParent = false;
    sb_Selection.ManageComponent(lb_Maps);
    asb_Scroll.ManageComponent(lb_MapDesc);

    InitMapHandler();
    InitGameType();
    InitDifficulty();
}

function ShowPanel(bool bShow)
{
    super.ShowPanel(bShow);

    if (bHideDifficultyControl)
    {
        co_Difficulty.SetVisibility(false);
        sb_options2.SetVisibility(false);
    }
}

function InitGameType() // TODO: this is being called twice in single player (current game types gets logged twice), so find out why & probably avoid duplication
{
    local int i;
    local array<CacheManager.GameRecord> Games;
    local bool bReloadMaps;

    class'CacheManager'.static.GetGameTypeList(Games);

    for (i = 0; i < Games.Length; ++i)
    {
        if (Games[i].ClassName == "DH_Engine.DarkestHourGame")
        {
            CurrentGameType = Games[i];
            bReloadMaps = true;
            break;
        }
    }

    Log("Current game type =" @ CurrentGameType.ClassName);

    if (i == Games.Length)
    {
        return;
    }

    SetGameTypeCaption();

    if (bReloadMaps)
    {
        InitMaps();
    }

    i = li_Maps.FindIndexByValue(LastSelectedMap);

    if (i == -1)
    {
        i = 0;
    }

    li_Maps.SetIndex(i);
    li_Maps.Expand(i);
}

function CheckGameTutorial()
{
}

function MapListChange(GUIComponent Sender)
{
    local MaplistRecord.MapItem Item;

    if (!Controller.bCurMenuInitialized)
    {
        return;
    }

    if (Sender == lb_Maps)
    {
        if (li_Maps.IsValid())
        {
           // Puma 05-03-2004 - changed to the Anchor's Primary and Secondary
            EnableComponent(p_Anchor.b_Primary);
            EnableComponent(p_Anchor.b_Secondary);
        }

        class'MaplistRecord'.static.CreateMapItem(li_Maps.GetValue(), Item);

        LastSelectedMap = Item.FullURL;
        SaveConfig();
        ReadMapInfo(Item.MapName);
    }
}

function MaplistConfigClick(GUIComponent Sender)
{
    local DHMaplistEditor MaplistPage;

    MaplistEditorMenu = "DH_Interface.DHMaplistEditor";

    if (Controller.OpenMenu(MaplistEditorMenu))
    {
        MaplistPage = DHMaplistEditor(Controller.ActivePage);

        if (MaplistPage != none)
        {
            MaplistPage.MainPanel = self;
            MaplistPage.bOnlyShowOfficial = bOnlyShowOfficial;
            MaplistPage.bOnlyShowCustom = bOnlyShowCustom;
            MaplistPage.Initialize(MapHandler);
        }
    }
}

function InitDifficulty()
{
    local string        props;
    local array<string> splits;
    local int           i, count;

    props = class'DH_Engine.DarkestHourGame'.static.GetPropsExtra(0);
    count = Split(props, ";", splits);

    if (count <= 0 || count % 2 != 0)
    {
        return;
    }

    for (i = 0; i < count / 2; ++i)
    {
        Difficulties[i] = float(splits[i * 2]);
        co_Difficulty.AddItem(splits[(i * 2) + 1],, splits[i * 1]);
    }

    UpdateCurrentGameDifficulty();
}

function UpdateCurrentGameDifficulty()
{
    local float currentDifficulty;
    local int   i;

    currentDifficulty = class'DH_Engine.DarkestHourGame'.default.GameDifficulty;

    for (i = 0; i < Difficulties.Length; ++i)
    {
        if (currentDifficulty == Difficulties[i])
        {
            co_Difficulty.SilentSetIndex(i);

            return;
        }
    }

    Warn("Unable to set current GameDifficulty in difficulty combobox (difficulty not found)");
}

function OnNewDifficultySelect(GUIComponent Sender)
{
    if (Sender == co_Difficulty)
    {
        class'DH_Engine.DarkestHourGame'.default.GameDifficulty = Difficulties[co_Difficulty.GetIndex()];
        class'DH_Engine.DarkestHourGame'.static.StaticSaveConfig();
        OnChangeDifficulty(co_Difficulty.GetIndex());
    }
}

function SilentSetDifficulty(int index)
{
    co_Difficulty.SilentSetIndex(index);
}

defaultproperties
{
    Begin Object Class=DHGUISectionBackground Name=OptionsContainer
        bFillClient=true
        Caption="Options"
        WinTop=0.634726
        WinLeft=0.016993
        WinWidth=0.482149
        WinHeight=0.325816
        OnPreDraw=OptionsContainer.InternalPreDraw
    End Object
    sb_options2=DHGUISectionBackground'DH_Interface.DHTab_MainSP.OptionsContainer'

    Begin Object Class=DHmoComboBox Name=DifficultyCombo
        bReadOnly=true
        Caption="Difficulty"
        OnCreateComponent=DifficultyCombo.InternalOnCreateComponent
        WinTop=0.750547
        WinLeft=0.087169
        WinWidth=0.341797
        WinHeight=0.034236
        TabOrder=0
        OnChange=DHTab_MainSP.OnNewDifficultySelect
    End Object
    co_Difficulty=DHmoComboBox'DH_Interface.DHTab_MainSP.DifficultyCombo'

    Begin Object Class=DHGUISectionBackground Name=SelectionGroup
        bFillClient=true
        Caption="Map Selection"
        WinTop=0.018125
        WinLeft=0.016993
        WinWidth=0.482149
        WinHeight=0.6
        OnPreDraw=SelectionGroup.InternalPreDraw
    End Object
    sb_Selection=DHGUISectionBackground'DH_Interface.DHTab_MainSP.SelectionGroup'

    Begin Object Class=DHGUISectionBackground Name=PreviewGroup
        bFillClient=true
        Caption="Preview"
        WinTop=0.018125
        WinLeft=0.515743
        WinWidth=0.470899
        WinHeight=0.942417
        OnPreDraw=PreviewGroup.InternalPreDraw
    End Object
    sb_Preview=DHGUISectionBackground'DH_Interface.DHTab_MainSP.PreviewGroup'
    sb_Options=none

    Begin Object Class=DHGUINoBackground Name=ScrollSection
        bFillClient=true
        Caption="Map Description"
        WinTop=0.525219
        WinLeft=0.546118
        WinWidth=0.409888
        WinHeight=0.412304
        OnPreDraw=ScrollSection.InternalPreDraw
    End Object
    asb_Scroll=DHGUINoBackground'DH_Interface.DHTab_MainSP.ScrollSection'

    Begin Object Class=DHGUIScrollTextBox Name=MapDescription
        bNoTeletype=true
        CharDelay=0.0025
        EOLDelay=0.5
        OnCreateComponent=MapDescription.InternalOnCreateComponent
        FontScale=FNS_Small
        StyleName="DHSmallText"
        WinTop=0.628421
        WinLeft=0.561065
        WinWidth=0.379993
        WinHeight=0.26841
        bTabStop=false
        bNeverFocus=true
    End Object
    lb_MapDesc=DHGUIScrollTextBox'DH_Interface.DHTab_MainSP.MapDescription'

    Begin Object Class=DHGUITreeListBox Name=AvailableMaps
        bVisibleWhenEmpty=true
        OnCreateComponent=AvailableMaps.InternalOnCreateComponent
        WinTop=0.169272
        WinLeft=0.045671
        WinWidth=0.422481
        WinHeight=0.44987
        TabOrder=0
        OnChange=DHTab_MainSP.MapListChange
    End Object
    lb_Maps=DHGUITreeListBox'DH_Interface.DHTab_MainSP.AvailableMaps'

    Begin Object Class=DHmoButton Name=MaplistButton
        ButtonCaption="Maplist Configuration"
        OnCreateComponent=MaplistButton.InternalOnCreateComponent
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.828648
        WinLeft=0.095426
        WinWidth=0.334961
        TabOrder=2
        OnChange=DHTab_MainSP.MaplistConfigClick
    End Object
    b_Maplist=DHmoButton'DH_Interface.DHTab_MainSP.MaplistButton'
    b_Tutorial=none

    Begin Object Class=GUILabel Name=MapAuthorLabel
        Caption="Testing"
        TextAlign=TXTA_Center
        StyleName="DHSmallText"
        WinTop=0.405278
        WinLeft=0.522265
        WinWidth=0.453285
        WinHeight=0.032552
        RenderWeight=0.3
    End Object
    l_MapAuthor=GUILabel'DH_Interface.DHTab_MainSP.MapAuthorLabel'

    Begin Object Class=GUILabel Name=RecommendedPlayers
        Caption="Best for 4 to 8 players"
        TextAlign=TXTA_Center
        StyleName="DHSmallText"
        WinTop=0.474166
        WinLeft=0.521288
        WinWidth=0.445313
        WinHeight=0.032552
        RenderWeight=0.3
    End Object
    l_MapPlayers=GUILabel'DH_Interface.DHTab_MainSP.RecommendedPlayers'

    Begin Object Class=GUILabel Name=NoPreview
        Caption="No Preview Available"
        TextAlign=TXTA_Center
        TextColor=(B=0,G=255,R=247)
        TextFont="DHSmallFont"
        bTransparent=false
        bMultiLine=true
        VertAlign=TXTA_Center
        WinTop=0.107691
        WinLeft=0.562668
        WinWidth=0.372002
        WinHeight=0.35748
    End Object
    l_NoPreview=GUILabel'DH_Interface.DHTab_MainSP.NoPreview'

    LastSelectedMap="DH-Brecourt"
    ch_OfficialMapsOnly=none
}
