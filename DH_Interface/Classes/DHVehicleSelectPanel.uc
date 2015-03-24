//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleSelectPanel extends DHDeployMenuPanel;

var automated ROGUIProportionalContainer    CrewPoolsContainer,
                                            NoCrewPoolsContainer;

var automated DHGUIListBox                  lb_CrewVehiclePools,
                                            lb_NoCrewVehiclePools;

var ROGUIListPlus                           li_CrewVehiclePools,
                                            li_NoCrewVehiclePools;

var array<int>                              CrewedVehiclePoolIndices,
                                            NonCrewedVehiclePoolIndices;

var byte                                    TeamNum;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    Log(self @ "InitComponent");

    // Change background from default if team == Axis
    Log("Players team is: " $ DHP.GetTeamNum());

    if (DHP.GetTeamNum() == Axis_Team_Index)
    {
        Background=Texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
    }
    else
    {
        Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG';
    }

    // Crew required vehicle pool container
    li_CrewVehiclePools = ROGUIListPlus(lb_CrewVehiclePools.List);
    CrewPoolsContainer.ManageComponent(lb_CrewVehiclePools);

    // None crew required vehicle pool container
    li_NoCrewVehiclePools = ROGUIListPlus(lb_NoCrewVehiclePools.List);
    NoCrewPoolsContainer.ManageComponent(lb_NoCrewVehiclePools);

    InitializeVehiclePools();
}

function ShowPanel(bool bShow)
{
    local DHSpawnPoint SP;

    super.ShowPanel(bShow);

    // We are showing this panel so we want to spawn as vehicle
    if (bShow && myDeployMenu != none)
    {
        myDeployMenu.Tab = TAB_Vehicle;

        // Check if SpawnPointIndex is valid
        if (DHGRI.IsSpawnPointIndexValid(MyDeployMenu.SpawnPointIndex, DHP.GetTeamNum()))
        {
            SP = DHGRI.GetSpawnPoint(MyDeployMenu.SpawnPointIndex);
        }

        // If spawnpoint index is type infantry, then nullify it and spawnvehicle
        if (SP != none && SP.Type == ESPT_Infantry)
        {
            MyDeployMenu.ChangeSpawnIndices(-1, MyDeployMenu.VehiclePoolIndex, -1);
        }
        else
        {
            // Just nullify SpawnVehicleIndex
            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, MyDeployMenu.VehiclePoolIndex, -1);
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
    if (DHP.GetTeamNum() != TeamNum)
    {
        // Team changed, we must re-build the list!
        InitializeVehiclePools();

        // Fix the background
        if (DHP.GetTeamNum() == Axis_Team_Index)
        {
            Background=Texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
        }
        else
        {
            Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG';
        }
    }

    UpdateVehiclePools();
}

function InitializeVehiclePools()
{
    local int i;

    li_CrewVehiclePools.Clear();
    li_NoCrewVehiclePools.Clear();

    CrewedVehiclePoolIndices.Length = 0;
    NonCrewedVehiclePoolIndices.Length = 0;

    if (DHGRI == none)
    {
        return;
    }

    for (i = 0; i < arraycount(DHGRI.VehiclePoolIsActives); ++i)
    {
        if (DHGRI.VehiclePoolVehicleClasses[i] == none)
        {
            continue;
        }

        if (DHGRI.VehiclePoolVehicleClasses[i].default.VehicleTeam != DHP.GetTeamNum())
        {
            // Do not display those not belonging to player's team
            continue;
        }

        if (DHGRI.VehiclePoolVehicleClasses[i].default.bMustBeTankCommander)
        {
            li_CrewVehiclePools.Add(DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString);
            li_CrewVehiclePools.SetExtraAtIndex(li_CrewVehiclePools.ItemCount - 1, "" $ i);
            CrewedVehiclePoolIndices[CrewedVehiclePoolIndices.Length] = i;
        }
        else
        {
            li_NoCrewVehiclePools.Add(DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString);
            li_NoCrewVehiclePools.SetExtraAtIndex(li_NoCrewVehiclePools.ItemCount - 1, "" $ i);
            NonCrewedVehiclePoolIndices[NonCrewedVehiclePoolIndices.Length] = i;
        }
    }

    TeamNum = DHP.GetTeamNum();
}

function UpdateVehiclePools()
{
    local int i, PoolIndex;
    local bool bNoPoolSet;

    if (MyDeployMenu.VehiclePoolIndex == -1)
    {
        bNoPoolSet = true;
    }

    // Loop for crewed vehicles
    for (i = 0; i < CrewedVehiclePoolIndices.Length; ++i)
    {
        PoolIndex = CrewedVehiclePoolIndices[i];

        li_CrewVehiclePools.SetItemAtIndex(i, FormatPoolString(PoolIndex));

        if (DHGRI.VehiclePoolIsActives[PoolIndex] == 0 ||
            DHGRI.VehiclePoolActiveCounts[PoolIndex] >= DHGRI.VehiclePoolMaxActives[PoolIndex] ||
            !myDeployMenu.bRoleIsCrew)
        {
            li_CrewVehiclePools.SetDisabledAtIndex(i, true); // Disabled
        }
        else
        {
            li_CrewVehiclePools.SetDisabledAtIndex(i, false); // Enabled

            if (bNoPoolSet)
            {
                MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, -1);
                bNoPoolSet = false;
            }
        }
    }

    // We found no active vehicle pool in the list
    if (bNoPoolSet)
    {
        li_CrewVehiclePools.SetIndex(-1);
    }

    // Loop for non-crewed vehicles
    for (i = 0; i < NonCrewedVehiclePoolIndices.Length; ++i)
    {
        PoolIndex = NonCrewedVehiclePoolIndices[i];

        li_NoCrewVehiclePools.SetItemAtIndex(i, FormatPoolString(PoolIndex));

        if (DHGRI.VehiclePoolIsActives[PoolIndex] == 0 ||
            DHGRI.VehiclePoolActiveCounts[PoolIndex] >= DHGRI.VehiclePoolMaxActives[PoolIndex])
        {
            li_NoCrewVehiclePools.SetDisabledAtIndex(i, true); // Disabled
        }
        else
        {
            li_NoCrewVehiclePools.SetDisabledAtIndex(i, false); // Enabled

            if (bNoPoolSet)
            {
                MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, -1);
                bNoPoolSet = false;
            }
        }
    }

    // We found no active vehicle pool in the list
    if (bNoPoolSet)
    {
        li_NoCrewVehiclePools.SetIndex(-1);
        MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, -1, -1);
        return;
    }

    // Lets disable the selection of the list that we don't have as active selected pool
    if (IsSelectedIndexCrewed())
    {
        li_NoCrewVehiclePools.SetIndex(-1);
    }
    else
    {
        li_CrewVehiclePools.SetIndex(-1);
    }
}

function bool IsSelectedIndexCrewed()
{
    local int i;

    for (i = 0; i < CrewedVehiclePoolIndices.Length; ++i)
    {
        if (MyDeployMenu.VehiclePoolIndex == CrewedVehiclePoolIndices[i])
        {
            return true;
        }
    }

    return false;
}

// Eventually this function will properly contruct a string with helpful info to player
function string FormatPoolString(int i)
{
    local string PoolString;;
    local float PoolRespawnTime;

    if (DHGRI.VehiclePoolVehicleClasses[i] != none)
    {
        PoolString = DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString;
    }
    else
    {
        PoolString = "ERROR";
    }

    // Add how many remaining
    if (DHGRI.VehiclePoolSpawnsRemainings[i] != 255)
    {
        PoolString @= "[" $ DHGRI.VehiclePoolSpawnsRemainings[i] $ "]";
    }

    // Add respawn time
    PoolRespawnTime = FMax(0.0, DHGRI.VehiclePoolNextAvailableTimes[i] - DHGRI.ElapsedTime);

    if (PoolRespawnTime > 0)
    {
        PoolString @= "(" $ GetTimeString(PoolRespawnTime) $ ")";
    }

    if (DHGRI.VehiclePoolMaxActives[i] == DHGRI.VehiclePoolActiveCounts[i])
    {
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
        case b_MenuButton:
            MyDeployMenu.HandleMenuButton();
            break;

        case lb_CrewVehiclePools:
            PoolIndex = CrewedVehiclePoolIndices[lb_CrewVehiclePools.List.Index];

            //Update pool index
            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, -1);
            break;

        case lb_NoCrewVehiclePools:
            PoolIndex = NonCrewedVehiclePoolIndices[lb_NoCrewVehiclePools.List.Index];

            //Update pool index
            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, PoolIndex, -1);
            break;
    }

    return true;
}

// Remove this when we add it to library
static function string GetTimeString(float Time)
{
    local string S;

    Time = FMax(0.0, Time);

    S = int(Time / 60) $ ":";

    Time = Time % 60;

    if (Time < 10)
        S = S $ "0" $ int(Time);
    else
        S = S $ int(Time);

    return S;
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG'
    OnPostDraw=OnPostDraw
    OnKeyEvent=InternalOnKeyEvent
    bNeverFocus=true

    // Crew Based Pools Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=PoolsContainer_Crew
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
    CrewPoolsContainer=PoolsContainer_Crew

    // Non Crew Based Pools Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=PoolsContainer_NonCrew
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHLoadout_Box'
        WinWidth=1.0
        WinHeight=0.67
        WinLeft=0.0
        WinTop=0.43
        TopPadding=0.03
        ImageOffset(0)=10
        ImageOffset(1)=10
        ImageOffset(2)=10
        ImageOffset(3)=10
    End Object
    NoCrewPoolsContainer=PoolsContainer_NonCrew

    // Vehicle pool list box
    Begin Object Class=DHGuiListBox Name=PoolsCrewLB
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
    lb_CrewVehiclePools=PoolsCrewLB

    // None crew vehicle pool list box
    Begin Object Class=DHGuiListBox Name=PoolsNoCrewLB
        OutlineStyleName="ItemOutline"              // When focused, the outline selection (text background)
        SectionStyleName="ListSection"              // Not sure
        SelectedStyleName="DHItemOutline"           // Style for items selected
        StyleName="DHSmallText"                     // Style for items not selected
        bVisibleWhenEmpty=true
        bSorted=true
        TabOrder=2
        OnClick=InternalOnClick
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_NoCrewVehiclePools=PoolsNoCrewLB

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
