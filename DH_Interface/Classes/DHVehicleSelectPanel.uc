//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleSelectPanel extends DHDeployMenuPanel;

var automated ROGUIProportionalContainer    VehiclePoolsContainer;
var automated DHGUIListBox                  lb_VehiclePools;

var ROGUIListPlus                           li_VehiclePools;

// Colin: I would love to use the GetExtra in the GUIList class instead of this,
// but GetExtra is polluted with the "disabled" indicator
var array<int>                              VehiclePoolIndices;

var byte                                    TeamNum;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    if (PC.GetTeamNum() == AXIS_TEAM_INDEX)
    {
        Background = texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
    }
    else
    {
        Background = texture'DH_GUI_Tex.Menu.AlliesLoadout_BG';
    }

    li_VehiclePools = ROGUIListPlus(lb_VehiclePools.List);
    VehiclePoolsContainer.ManageComponent(lb_VehiclePools);

    InitializeVehiclePools();
}

/*
function ShowPanel(bool bShow)
{
    local DHSpawnPoint SP;

    super.ShowPanel(bShow);

    // We are showing this panel so we want to spawn as vehicle
    if (bShow && myDeployMenu != none)
    {
        MyDeployMenu.Tab = TAB_Vehicle;

        // Check if SpawnPointIndex is valid
        if (GRI.IsSpawnPointIndexValid(MyDeployMenu.SpawnPointIndex, PC.GetTeamNum()))
        {
            SP = GRI.SpawnPoints[MyDeployMenu.SpawnPointIndex];
        }

        // If spawnpoint index is type infantry, then nullify it and SpawnVehicle
        if (SP != none && SP.Type == ESPT_Infantry)
        {
            MyDeployMenu.ChangeSpawnIndices(255, MyDeployMenu.VehiclePoolIndex, 255);
        }
        else
        {
            // Just nullify SpawnVehicleIndex
            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, MyDeployMenu.VehiclePoolIndex, 255);
        }

        // Only update if we are rendering panel
        Timer();

        SetTimer(0.1, true);
    }
    else
    {
        SetTimer(0.0, false);
    }
}
*/

function bool OnPostDraw(Canvas C)
{
    super.OnPostDraw(C);

    // Hack to fix stupid bug that makes no sense
    if (b_MenuButton.bVisible && b_MenuButton.bHasFocus && b_MenuButton.MenuState != MSAT_Watched)
    {
        b_MenuButton.LoseFocus(b_MenuButton);
    }

    return true;
}

function Timer()
{
    // HACK: checks the saved TeamNum and re-initializes if the team changed.
    // Would be far better if we had some sort of event system to detect this
    if (PC.GetTeamNum() != TeamNum)
    {
        // Team changed, we must re-build the list!
        InitializeVehiclePools();

        // Fix the background
        if (PC.GetTeamNum() == AXIS_TEAM_INDEX)
        {
            Background = texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
        }
        else
        {
            Background = texture'DH_GUI_Tex.Menu.AlliesLoadout_BG';
        }
    }

    UpdateVehiclePools();
}

function InitializeVehiclePools()
{
    local int i, j;

    j = -1;

    li_VehiclePools.Clear();

    VehiclePoolIndices.Length = 0;

    if (GRI == none)
    {
        return;
    }

    li_VehiclePools.SortList();

    VehiclePoolIndices.Length = 0;

    for (i = 0; i < arraycount(GRI.VehiclePoolVehicleClasses); ++i)
    {
        if (GRI.VehiclePoolVehicleClasses[i] == none ||
            GRI.VehiclePoolVehicleClasses[i].default.VehicleTeam != PC.GetTeamNum())
        {
            continue;
        }

        if (PC != none && PC.VehiclePoolIndex == i)
        {
            j = li_VehiclePools.ItemCount;
        }

        li_VehiclePools.Add(GRI.VehiclePoolVehicleClasses[i].default.VehicleNameString);
        li_VehiclePools.SetExtraAtIndex(li_VehiclePools.ItemCount - 1, "" $ i);

        VehiclePoolIndices[VehiclePoolIndices.Length] = i;
    }

    li_VehiclePools.SortList();

    li_VehiclePools.SetIndex(j);

    TeamNum = PC.GetTeamNum();
}

function UpdateVehiclePools()
{
    local int i;
    local bool bNoPoolSet;

    if (MyDeployMenu.VehiclePoolIndex == 255)
    {
        bNoPoolSet = true;
    }

    // Loop for  vehicles
    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
//        PoolIndex = VehiclePoolIndices[i];
//
//        li_VehiclePools.SetItemAtIndex(i, FormatPoolString(PoolIndex));
//
//        if (GRI.MaxTeamVehicles[PC.GetTeamNum()] <= 0 ||
//            GRI.GetVehiclePoolSpawnsRemaining(i) <= 0 ||
//            !GRI.IsVehiclePoolActive(PoolIndex) ||
//            GRI.VehiclePoolActiveCounts[PoolIndex] >= GRI.VehiclePoolMaxActives[PoolIndex] ||
//            (GRI.VehiclePoolVehicleClasses[PoolIndex].default.bMustBeTankCommander && !MyDeployMenu.bRoleIsCrew))
//        {
//            li_VehiclePools.SetDisabledAtIndex(i, true);
//        }
//        else
//        {
//            li_VehiclePools.SetDisabledAtIndex(i, false);
//
//            if (bNoPoolSet)
//            {
//                //MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, 255);
//
//                bNoPoolSet = false;
//            }
//        }
    }

    // We found no active vehicle pool in the list
    if (bNoPoolSet)
    {
        li_VehiclePools.SetIndex(-1);
    }
}

function string FormatPoolString(int i)
{
    local string PoolString;
    local int PoolRespawnTime;

    if (GRI.VehiclePoolVehicleClasses[i] != none)
    {
        PoolString = GRI.VehiclePoolVehicleClasses[i].default.VehicleNameString;
    }

    // Remaining spawns (if not infinite)
    if (GRI.GetVehiclePoolSpawnsRemaining(i) != 255)
    {
        PoolString @= "[" $ GRI.GetVehiclePoolSpawnsRemaining(i) $ "]";
    }

    // Respawn time
    PoolRespawnTime = Max(0.0, GRI.VehiclePoolNextAvailableTimes[i] - GRI.ElapsedTime);

    if (PoolRespawnTime > 0)
    {
        PoolString @= "(" $ class'DHLib'.static.GetDurationString(PoolRespawnTime, "m:ss") $ ")";
    }

    //TODO: have team max be indicated in another part of this control (ie. don't obfuscate meaning)
    if (GRI.MaxTeamVehicles[GRI.VehiclePoolVehicleClasses[i].default.VehicleTeam] <= 0 ||
        GRI.VehiclePoolActiveCounts[i] >= GRI.VehiclePoolMaxActives[i])
    {
        Log(GRI.VehiclePoolActiveCounts[i] @ GRI.VehiclePoolMaxActives[i]);

        // Indicate either pool or team max has been reached
        PoolString @= "*MAX*";
    }

    return PoolString;
}

//WTF IS THIS DOING?
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if (key == 0x1B)
    {
        return true;
    }

    return super.OnKeyEvent(key, state, delta);
}

function bool InternalOnClick(GUIComponent Sender)
{
    local int PoolIndex;

    switch (sender)
    {
        case lb_VehiclePools:
            if (lb_VehiclePools.List.Index >= 0 && lb_VehiclePools.List.Index < VehiclePoolIndices.Length)
            {
                PoolIndex = VehiclePoolIndices[lb_VehiclePools.List.Index];
                //MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, 255); // update pool index
            }
            break;
        default:
            break;
    }

    return true;
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG'
    OnPostDraw=OnPostDraw
    OnKeyEvent=InternalOnKeyEvent
    bNeverFocus=true

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=VehiclePoolsContainerObject
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.407
        WinLeft=0.0
        WinTop=0.0
        TopPadding=0.03
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    VehiclePoolsContainer=VehiclePoolsContainerObject

    // Vehicle pool list box
    Begin Object Class=DHGUIListBox Name=VehiclePoolsListBox
        OutlineStyleName="ItemOutline"              // When focused, the outline selection (text background)
        SectionStyleName="ListSection"              // Not sure
        SelectedStyleName="DHItemOutline"           // Style for items selected
        StyleName="DHSmallText"                     // Style for items not selected
        bVisibleWhenEmpty=true
        bSorted=true
        TabOrder=1
        OnClick=InternalOnClick
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_VehiclePools=VehiclePoolsListBox

    // Menu button
    Begin Object Class=DHGUIButton Name=MenuButton
        Caption="Menu"
        CaptionAlign=TXTA_Center
        RenderWeight=6.0
        StyleName="DHSmallTextButtonStyle"
        WinWidth=0.15
        WinHeight=0.035
        WinLeft=0.85
        WinTop=-0.035
        OnClick=InternalOnClick
    End Object
    b_MenuButton=MenuButton

    TeamNum=-1
}
