//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapVotingPage extends MapVotingPage;

var localized string                            lmsgMapOutOfBounds;

var automated moEditBox ed_Filter;
var automated GUIButton b_FilterClear;
var automated GUILabel  l_MapPreviewName;
var automated GUIImage  i_MapPreviewImage;

var automated GUIScrollTextBox lb_MapPreviewDesc;

var CacheManager.MapRecord LoadingMapRecord;


function InternalOnOpen()
{
    super.InternalOnOpen();

    // Fill the filter box in case a pattern is set
    ed_Filter.SetText(DHMapVoteMultiColumnList(lb_MapListBox.List).GetFilterPattern());
}

function bool AlignBK(Canvas C)
{
    i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
    i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
    i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
    i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();

    return false;
}

function bool UpdatePreview(GUIComponent Sender)
{
    local int MapIndex;
    local string mMapName;

    MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();
    // PlayerOwner().ClientMessage("Index: " @ Index);
    PlayerOwner().ClientMessage("MapIndex: " @ MapIndex);

    if (MapIndex > -1)
    {
        i_MapPreviewImage.Image = material(DynamicLoadObject(MVRI.MapList[MapIndex].MapName $ ".GUI.LoadingScreen", class'Material'));
        l_MapPreviewName.Caption = class'DHMapDatabase'.static.GetHumanReadableMapName(MVRI.MapList[MapIndex].MapName);

        mMapName = class'DHMapDatabase'.static.GetMapNameForCache(MVRI.MapList[MapIndex].MapName);
        LoadingMapRecord = class'CacheManager'.static.GetMapRecord(mMapName); //DH-Armored_La_Fueille_Advance

        lb_MapPreviewDesc.SetContent( LoadingMapRecord.Description );

        // lb_MapPreviewDesc.SetContent(lb_MapDesc);
        // i_MapPreview.SetVisibility( true);
    }
    return true;
}

function SendVote(GUIComponent Sender)
{
    local int MapIndex, GameConfigIndex;
    local DHGameReplicationInfo GRI;
    local int Min, Max;
    local DHMapDatabase MDB;
    local DHMapDatabase.SMapInfo MI;

    if (PlayerOwner() == none)
    {
        return;
    }

    MDB = DHPlayer(PlayerOwner()).MapDatabase;
    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    if (MVRI == none || GRI == none)
    {
        return;
    }

    if (Sender == lb_VoteCountListBox.List)
    {
        MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();

        if (MapIndex > -1)
        {
            GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();

            if (MDB.GetMapInfo(MVRI.MapList[MapIndex].MapName, MI))
            {
                class'DHMapDatabase'.static.GetMapSizePlayerCountRange(MI.Size, Min, Max);

                // Do a check if the current player count is in bounds of recommended range or if level has failed QA
                if (!GRI.IsPlayerCountInRange(Min, Max))
                {
                    PlayerOwner().ClientMessage(lmsgMapOutOfBounds);
                    return;
                }
            }

            if (MVRI.MapList[MapIndex].bEnabled || PlayerOwner().PlayerReplicationInfo.bAdmin)
            {
                UpdatePreview(Sender);
                // MVRI.SendMapVote(MapIndex,GameConfigIndex);
            }
            else
            {
                PlayerOwner().ClientMessage(lmsgMapDisabled);
            }
        }
    }
    else
    {
        MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();

        if (MapIndex > -1)
        {
            GameConfigIndex = int(co_GameType.GetExtra());

            if (MVRI.MapList[MapIndex].bEnabled || PlayerOwner().PlayerReplicationInfo.bAdmin)
            {
                if (MDB.GetMapInfo(MVRI.MapList[MapIndex].MapName, MI))
                {
                    // UpdatePreview(Sender, MapIndex);
                }
                // MVRI.SendMapVote(MapIndex,GameConfigIndex);
            }
            else
            {
                PlayerOwner().ClientMessage(lmsgMapDisabled);
            }
        }
    }
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    // Update map list on "key down" event
    if (State == 3)
    {
        DHMapVoteMultiColumnList(lb_MapListBox.List).SetFilterPattern(ed_Filter.GetText());
        return true;
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == b_FilterClear)
    {
        OnFilterClear();
        return true;
    }
    else if (Sender == lb_MapListBox)
    {
        UpdatePreview(Sender);
    }
}

delegate OnFilterClear()
{
    ed_Filter.SetText("");
    DHMapVoteMultiColumnList(lb_MapListBox.List).SetFilterPattern("");
}

defaultproperties
{
    lmsgMapOutOfBounds="Please vote for a map suitable for the current player count. You can still vote for this map on the full list."
    lmsgMode(0)="Majority Wins"

    Begin Object class=DHMapVoteMultiColumnListBox Name=MapListBox
        WinWidth=0.5
        WinHeight=0.50
        WinLeft=0.02
        WinTop=0.371020
        bVisibleWhenEmpty=true
        StyleName="ServerBrowserGrid"
        bScaleToParent=true
        bBoundToParent=true
        FontScale=FNS_Small
        HeaderColumnPerc(0)=0.40 // Name
        HeaderColumnPerc(1)=0.20 // Allies
        HeaderColumnPerc(2)=0.20 // Type
        HeaderColumnPerc(3)=0.20 // Size
        OnClick=InternalOnClick
        OnChange=UpdatePreview
    End Object
    lb_MapListBox=DHMapVoteMultiColumnListBox'DH_Interface.DHMapVotingPage.MapListBox'

    Begin Object class=DHMapVoteCountMultiColumnListBox Name=VoteCountListBox
        HeaderColumnPerc(0)=0.4 // Nominated Maps
        HeaderColumnPerc(1)=0.3 // Votes
        HeaderColumnPerc(2)=0.3 // Size
        DefaultListClass="DH_Interface.DHMapVoteCountMultiColumnList"
        bVisibleWhenEmpty=true
        OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
        StyleName="ServerBrowserGrid"
        WinTop=0.077369
        WinLeft=0.02
        WinWidth=0.5
        WinHeight=0.26752
        bBoundToParent=true
        bScaleToParent=true
        OnRightClick=VoteCountListBox.InternalOnRightClick
    End Object
    lb_VoteCountListBox=DHMapVoteCountMultiColumnListBox'DH_Interface.DHMapVotingPage.VoteCountListBox'

    Begin Object Class=moComboBox Name=GameTypeCombo
        CaptionWidth=0.35
        Caption="Filter Game Type:"
        OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
        bScaleToParent=true
        bVisible=false
    End Object
    co_GameType=moComboBox'DH_Interface.DHMapVotingPage.GameTypeCombo'

    i_MapListBackground=none
    Begin Object Class=GUIImage Name=MapCountListBackground
        Image=Texture'InterfaceArt_tex.Menu.buttonGreyDark01'
        ImageStyle=ISTY_Stretched
        OnDraw=DHMapVotingPage.AlignBK
    End Object
    i_MapCountListBackground=GUIImage'DH_Interface.DHMapVotingPage.MapCountListBackground'


    Begin Object class=moEditBox Name=FilterEditbox
        WinWidth=0.41
        WinHeight=0.12
        WinLeft=0.02
        WinTop=0.90
        Caption="Search"
        CaptionWidth=0.074
        OnKeyEvent=InternalOnKeyEvent
        // TabOrder=0
        bScaleToParent=true
        bBoundToParent=true
    End Object
    ed_Filter=FilterEditbox

    Begin Object Class=GUIButton Name=FilterClearButton
        WinWidth=0.08
        WinHeight=0.04
        WinLeft=0.44
        WinTop=0.894
        Caption="Clear"
        FontScale=FNS_Small
        OnClick=InternalOnClick
        // TabOrder=1
        bStandardized=true
        bBoundToParent=true
        bScaleToParent=true
    End Object
    b_FilterClear=FilterClearButton

    Begin Object Class=GUILabel Name=MapPreviewName
        WinWidth=0.35
        WinHeight=0.1
        WinLeft=0.53
        WinTop=0.125
        TextAlign=TXTA_Left
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
        Caption="Map Preview"
    End Object
    l_MapPreviewName=MapPreviewName

    Begin Object Class=GUIImage Name=MapPreviewImage
		WinWidth=0.352002
		WinHeight=0.337480
		WinLeft=0.53
		WinTop=0.2
        ImageColor=(R=255,G=255,B=255,A=255)
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Normal
        RenderWeight=0.2
    End Object
    i_MapPreviewImage=MapPreviewImage

    Begin Object Class=DHGUIScrollTextBox Name=MapPreviewDesc
        bNoTeletype=true
        CharDelay=0.0025
        EOLDelay=0.5
        OnCreateComponent=MapPreviewDesc.InternalOnCreateComponent
        FontScale=FNS_Small
        StyleName="DHLargeText"
        WinWidth=0.358001
        WinHeight=0.31
        WinLeft=0.525
        WinTop=0.545
        bTabStop=false
        bNeverFocus=true
    End Object
    lb_MapPreviewDesc=MapPreviewDesc

    f_Chat=none
}
