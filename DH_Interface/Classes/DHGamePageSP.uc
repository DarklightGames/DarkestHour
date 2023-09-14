//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGamePageSP extends UT2K4GamePageSP;

const GAME_DIFFICULTY_INDEX = 3;

var globalconfig bool   bDidShowNoBotsWarning;
var localized string    NoBotsWarningText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local DHTab_MainSP              tab;
    local DHIAMultiColumnRulesPanel tab2;

    super(UT2K4MainPage).Initcomponent(MyController, MyOwner);

    class'DHInterfaceUtil'.static.SetROStyle(MyController, Controls);
    RuleInfo = new(none) class'Engine.PlayInfo';

    i = 1;
    p_Main = UT2K4Tab_MainBase(c_Tabs.AddTab(PanelCaption[i], PanelClass[i],, PanelHint[i++]));
    mcRules = DHIAMultiColumnRulesPanel(c_Tabs.AddTab(PanelCaption[i], PanelClass[i],, PanelHint[i++]));
    p_Mutators = UT2K4Tab_MutatorBase(c_Tabs.AddTab(PanelCaption[i], PanelClass[i],, PanelHint[i++]));
    tab = DHTab_MainSP(p_Main);

    if (tab != none)
    {
        tab.OnChangeDifficulty = InternalOnChangeDifficulty;
    }

    tab2 = DHIAMultiColumnRulesPanel(mcRules);

    if (tab2 != none)
    {
        tab2.OnDifficultyChanged = InternalOnDifficultyChanged;
    }

    b_Back = DHGameFooterSP(t_Footer).b_Back;
    b_Primary = DHGameFooterSP(t_Footer).b_Primary;
}

function InternalOnOpen()
{
    super.InternalOnOpen();

    if (!bDidShowNoBotsWarning)
    {
        Controller.ShowQuestionDialog(default.NoBotsWarningText, QBTN_OK, QBTN_OK);
        bDidShowNoBotsWarning = true;
        SaveConfig();
    }
}

function PrepareToPlay(out string GameURL, optional string OverrideMap)
{
    local int  i;
    local byte Value;

    super.PrepareToPlay(GameURL, OverrideMap);

    i = RuleInfo.FindIndex("BotMode");

    if (i != -1)
    {
        Value = byte(RuleInfo.Settings[i].Value) & 3;

        if (Value == 1)
        {
            GameURL $= "?bAutoNumBots=true";
        }
        else if (Value == 2)
        {
            GameURL $= p_BotConfig.Play();
        }
        else
        {
            i = RuleInfo.FindIndex("MinPlayers");

            if (i >= 0)
            {
                GameURL $= "?bAutoNumBots=false?NumBots=" $ RuleInfo.Settings[i].Value;
            }
        }
    }
    Log("Prepare to play GameURL=" @ GameURL);
}

function InternalOnChangeDifficulty(int index)
{
    local DHIAMultiColumnRulesPanel tab;
    local int i;
    local DHmoComboBox combo;

    tab = DHIAMultiColumnRulesPanel(mcRules);

    if (tab != none)
    {
        i = tab.FindComponentWithTag(GAME_DIFFICULTY_INDEX); // hax: game difficulty control is control #3

        if (i == -1)
        {
            return;
        }

        combo = DHmoComboBox(tab.li_Rules.Elements[i]);

        if (combo == none)
        {
            return;
        }

        combo.SetIndex(index);
    }
}

function InternalOnDifficultyChanged(int index, int tag)
{
    local DHTab_MainSP gametab;

    if (tag != GAME_DIFFICULTY_INDEX)
    {
        return;
    }

    gametab = DHTab_MainSP(p_Main);

    if (gametab != none)
    {
        gametab.SilentSetDifficulty(index);
        Log("difficulty changed.");
    }
}

defaultproperties
{
    PageCaption="Practice"
    Begin Object Class=DHGUITabControl Name=PageTabs
        bFillSpace=false
        bDockPanels=true
        TabHeight=0.06
        BackgroundStyleName="DHHeader"
        WinHeight=0.044
        RenderWeight=0.49
        TabOrder=3
        bAcceptsInput=true
        OnActivate=PageTabs.InternalOnActivate
        OnChange=DHGamePageSP.InternalOnChange
    End Object
    c_Tabs=DHGUITabControl'DH_Interface.DHGamePageSP.PageTabs'

    Begin Object Class=DHGUIHeader Name=GamePageHeader
        StyleName="DHTopper"
        WinHeight=32.0
        RenderWeight=0.3
    End Object
    t_Header=DHGUIHeader'DH_Interface.DHGamePageSP.GamePageHeader'

    Begin Object Class=DHGameFooterSP Name=SPFooter
        PrimaryCaption="Start Practice Game"
        Spacer=0.01
        TextIndent=5
        FontScale=FNS_Small
        StyleName="DHFooter"
        WinTop=0.95
        WinHeight=0.045
        RenderWeight=0.3
        TabOrder=8
        OnPreDraw=SPFooter.InternalOnPreDraw
    End Object
    t_Footer=DHGameFooterSP'DH_Interface.DHGamePageSP.SPFooter'

    Begin Object Class=GUIImage Name=BkChar
        Image=Texture'DH_GUI_Tex.Menu.menuBackground'
        ImageStyle=ISTY_Scaled
        X1=0
        Y1=0
        X2=1024
        Y2=1024
        WinHeight=1.0
        RenderWeight=0.02
    End Object
    i_bkChar=GUIImage'DH_Interface.DHGamePageSP.BkChar'

    PanelClass(0)="none"
    PanelClass(1)="DH_Interface.DHTab_MainSP"
    PanelClass(2)="DH_Interface.DHIAMultiColumnRulesPanel"
    PanelClass(3)="DH_Interface.DHTab_MutatorSP"
    PanelClass(4)="none"

    bDidShowNoBotsWarning=false
    NoBotsWarningText="Darkest Hour: Europe '44-'45 is focused solely on multi-player and, as a result, does NOT include support for bots in Practice mode."

    OnOpen=InternalOnOpen
}

