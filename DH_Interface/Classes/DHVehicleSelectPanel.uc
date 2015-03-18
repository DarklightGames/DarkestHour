//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleSelectPanel extends MidGamePanel;

var automated ROGUIProportionalContainer    CrewPoolsContainer,
                                            NoCrewPoolsContainer;

var automated DHGUIButton                   b_MenuButton;

var automated DHGUIListBox                  lb_CrewVehiclePools,
                                            lb_NoCrewVehiclePools;

var ROGUIListPlus                           li_CrewVehiclePools,
                                            li_NoCrewVehiclePools;

var float                                   VehiclePoolsUpdateTime; // This variable should be pointless as I only access GRI variables
                                                                    // the variables are only net transfered when they change, not each access request
                                                                    // so there is no need to have a delay, also I can always slow down timer if needed
var int                                     VehiclePoolIndex;
var array<int>                              CrewedVehiclePoolIndices,
                                            NonCrewedVehiclePoolIndices;

var DHGameReplicationInfo                   DHGRI;
var DHPlayer                                DHP;

var bool                                    bRendered;

//Deploy Menu Access
var DHDeployMenu                            myDeployMenu;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    DHP = DHPlayer(PlayerOwner());
    if (DHP == none || DHPlayerReplicationInfo(DHP.PlayerReplicationInfo) == none)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);
    if (DHGRI == none)
    {
        return;
    }

    // Assign myDeployMenu
    myDeployMenu = DHDeployMenu(PageOwner);

    // Change background from default if team == Axis
    if (DHP.PlayerReplicationInfo.Team.TeamIndex == Axis_Team_Index)
    {
        Background=Texture'DH_GUI_Tex.Menu.AxisLoadout_BG';
    }

    // Crew required vehicle pool container
    li_CrewVehiclePools = ROGUIListPlus(lb_CrewVehiclePools.List);
    CrewPoolsContainer.ManageComponent(lb_CrewVehiclePools);

    // None crew required vehicle pool container
    li_NoCrewVehiclePools = ROGUIListPlus(lb_NoCrewVehiclePools.List);
    NoCrewPoolsContainer.ManageComponent(lb_NoCrewVehiclePools);

    // Initial setup of pools (show all pools for your team)
    InitializeVehiclePools();
}

function ShowPanel(bool bShow)
{
    local DHSpawnPoint SP;

    super.ShowPanel(bShow);

    // We are showing this panel so we want to spawn as vehicle
    if (bShow && myDeployMenu != none)
    {
        myDeployMenu.bSpawningVehicle = true;

        // Check if SpawnPointIndex is valid
        if (DHGRI.IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.PlayerReplicationInfo.Team.TeamIndex))
        {
            SP = DHGRI.GetSpawnPoint(DHP.SpawnPointIndex);
        }

        // If spawnpoint index is type infantry, then nullify it and spawnvehicle
        if (SP != none && SP.Type == ESPT_Infantry)
        {
            DHP.ServerChangeSpawn(-1, DHP.VehiclePoolIndex, -1);
        }
        else
        {
            // Just nullify SpawnVehicleIndex
            DHP.ServerChangeSpawn(DHP.SpawnPointIndex, DHP.VehiclePoolIndex, -1);
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

// This function informs InternalOnChange not to run until we are done rendering
function bool OnPostDraw(Canvas C)
{
    super.OnPostDraw(C);

    // Hack to fix stupid bug that makes no sense
    if (b_MenuButton.bHasFocus && b_MenuButton.MenuState != MSAT_Watched)
    {
        b_MenuButton.LoseFocus(b_MenuButton);
    }

    bRendered = true;
    return true;
}

function Timer()
{
    UpdateVehiclePools();
}

function InitializeVehiclePools()
{
    local int i;

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
}

function UpdateVehiclePools()
{
    local int i, pi;
    local bool bNoPoolSet;
    local float PoolRespawnTime;

    if (DHP.VehiclePoolIndex == -1)
    {
        bNoPoolSet = true;
    }

    // Loop for crewed vehicles
    for (i = 0; i < CrewedVehiclePoolIndices.Length; ++i)
    {
        pi = CrewedVehiclePoolIndices[i];

        if (DHGRI.VehiclePoolVehicleClasses[pi].default.bMustBeTankCommander)
        {
            PoolRespawnTime = FMax(0.0, DHGRI.VehiclePoolNextAvailableTimes[pi] - DHGRI.ElapsedTime);

            li_CrewVehiclePools.SetItemAtIndex(i, FormatPoolString(pi, PoolRespawnTime));

            if (DHGRI.VehiclePoolIsActives[pi] == 0 ||
                PoolRespawnTime > 0.0 ||
                DHGRI.VehiclePoolActiveCounts[pi] >= DHGRI.VehiclePoolMaxActives[pi] ||
                !myDeployMenu.bRoleIsCrew)
            {
                li_CrewVehiclePools.SetDisabledAtIndex(i, true); // Disabled
            }
            else
            {
                li_CrewVehiclePools.SetDisabledAtIndex(i, false); // Enabled

                if (bNoPoolSet)
                {
                    DHP.ServerChangeSpawn(DHP.SpawnPointIndex, i, -1);
                    VehiclePoolIndex = i;
                    bNoPoolSet = false;
                }
            }
        }
    }

    // Loop for non-crewed vehicles
    for (i = 0; i < NonCrewedVehiclePoolIndices.Length; ++i)
    {
        pi = NonCrewedVehiclePoolIndices[i];

        if (!DHGRI.VehiclePoolVehicleClasses[pi].default.bMustBeTankCommander)
        {
            PoolRespawnTime = FMax(0.0, DHGRI.VehiclePoolNextAvailableTimes[pi] - DHGRI.ElapsedTime);

            li_NoCrewVehiclePools.SetItemAtIndex(i, FormatPoolString(pi, PoolRespawnTime));

            if (DHGRI.VehiclePoolIsActives[pi] == 0 ||
                PoolRespawnTime > 0.0 ||
                DHGRI.VehiclePoolActiveCounts[pi] >= DHGRI.VehiclePoolMaxActives[pi])
            {
                li_NoCrewVehiclePools.SetDisabledAtIndex(i, true); // Disabled
            }
            else
            {
                li_NoCrewVehiclePools.SetDisabledAtIndex(i, false); // Enabled

                if (bNoPoolSet)
                {
                    DHP.ServerChangeSpawn(DHP.SpawnPointIndex, i, -1);
                    VehiclePoolIndex = i;
                    bNoPoolSet = false;
                }
            }
        }
    }
}

// Eventually this function will properly contruct a string with helpful info to player
function string FormatPoolString(int i, float PoolRespawnTime)
{
    local string poolname, add;

    if (DHGRI.VehiclePoolVehicleClasses[i] != none)
    {
        poolname = DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString;
    }
    else
    {
        return "ERROR";
    }

    // Add active/max
    if (DHGRI.VehiclePoolMaxActives[i] == 255)
    {
        add = "" @ "No Max";
    }
    else
    {
        add = " [" $ DHGRI.VehiclePoolActiveCounts[i] $ "/" $ DHGRI.VehiclePoolMaxActives[i] $ "]";
    }

    // Add how many remaining
    if (DHGRI.VehiclePoolSpawnsRemainings[i] == 255)
    {
        add = add @ "No Limit";
    }
    else
    {
        add = add @ DHGRI.VehiclePoolSpawnsRemainings[i] @ "Remaining";
    }

    // Add respawn time
    if (PoolRespawnTime <= 0)
    {
        add = add @ "Ready";
    }
    else
    {
        add = add @ GetTimeString(PoolRespawnTime) @ "Before Ready";
    }

    // Add selected text
    if (VehiclePoolIndex == i)
    {
        add = add @ "Selected";
    }

    return poolname $ add;
}

function InternalOnChange(GUIComponent Sender)
{
    local int PoolIndex;

    if (!bRendered)
    {
        return;
    }

    switch (Sender)
    {
        case lb_CrewVehiclePools:
            PoolIndex = CrewedVehiclePoolIndices[lb_CrewVehiclePools.List.Index];
            VehiclePoolIndex = PoolIndex;

            //Update pool index
            DHP.ServerChangeSpawn(DHP.SpawnPointIndex, PoolIndex, -1);
            break;

        case lb_NoCrewVehiclePools:
            PoolIndex = NonCrewedVehiclePoolIndices[lb_NoCrewVehiclePools.List.Index];
            VehiclePoolIndex = PoolIndex;

            //Update pool index
            DHP.ServerChangeSpawn(DHP.SpawnPointIndex, PoolIndex, -1);
            break;
    }
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
    switch (sender)
    {
        case b_MenuButton:
            if (!MyDeployMenu.bShowingMenuOptions)
            {
                // Show menu options (hide panels & menu button)
                MyDeployMenu.bShowingMenuOptions = true;
                MyDeployMenu.MenuOptionsContainer.SetVisibility(true);
                MyDeployMenu.c_LoadoutArea.SetVisibility(false);
                MyDeployMenu.c_DeploymentMapArea.SetVisibility(false);
            }
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

    VehiclePoolsUpdateTime=-1.0
    VehiclePoolIndex=-1

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
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        bSorted=true
        StyleName="DHSmallText"
        TabOrder=1
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_CrewVehiclePools=PoolsCrewLB

    // None crew vehicle pool list box
    Begin Object Class=DHGuiListBox Name=PoolsNoCrewLB
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        bSorted=true
        StyleName="DHSmallText"
        TabOrder=2
        OnChange=InternalOnChange
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
}
