//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleSelectPanel extends MidGamePanel;

var automated ROGUIProportionalContainer    CrewPoolsContainer,
                                            NoCrewPoolsContainer;

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
    super.ShowPanel(bShow);

    // We are showing this panel so we want to spawn as vehicle
    if (bShow && myDeployMenu != none)
    {
        myDeployMenu.bSpawningVehicle = true;

        // Clear DesiredSpawnPoint if it's infantry
        if (DHP.DesiredSpawnPoint != none && DHP.DesiredSpawnPoint.Type == ESPT_Infantry)
        {
            DHP.DesiredSpawnPoint = none;
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
        TabOrder=0
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
        TabOrder=0
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_NoCrewVehiclePools=PoolsNoCrewLB
}
