//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleSelectPanel extends MidGamePanel;

var automated ROGUIProportionalContainer    PoolsContainer;

var automated DHGUIListBox                  lb_VehiclePools;
var ROGUIListPlus                           li_VehiclePools;

var float                                   VehiclePoolsUpdateTime;
var int                                     VehiclePoolIndex;
var array<int>                              VehiclePoolIndices;

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

    // Vehicle pool container
    li_VehiclePools = ROGUIListPlus(lb_VehiclePools.List);
    PoolsContainer.ManageComponent(lb_VehiclePools);

    // Initial setup of pools (show all pools for your team)
    InitializeVehiclePools();

    // Set initial counts
    Timer();
    SetTimer(0.1, true);

    bRendered = true;
}

function ShowPanel(bool bShow)
{
    super.ShowPanel(bShow);

    //We are showing this panel so we want to spawn as vehicle
    if (bShow && myDeployMenu != none)
    {
        myDeployMenu.bSpawningVehicle = true;
    }
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

        li_VehiclePools.Add(DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString);
        //Log("li_VehiclePools.SetExtraAtIndex(" $ li_VehiclePools.ItemCount - 1 $ ") =" @ i);

        li_VehiclePools.SetExtraAtIndex(li_VehiclePools.ItemCount - 1, "" $ i);

        VehiclePoolIndices[VehiclePoolIndices.Length] = i;
    }
}

function UpdateVehiclePools()
{
    local int i;

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        li_VehiclePools.SetItemAtIndex(i, FormatPoolString(VehiclePoolIndices[i]));

        if (DHGRI.VehiclePoolIsActives[VehiclePoolIndices[i]] == 0)
        {
            li_VehiclePools.SetDisabledAtIndex(i, true);
        }
        else if (DHGRI.VehiclePoolNextAvailableTimes[VehiclePoolIndices[i]] != 0)
        {
            li_VehiclePools.SetDisabledAtIndex(i, true);
        }
        else
        {
            li_VehiclePools.SetDisabledAtIndex(i, false); // Enabled
        }
    }
}

// Eventually this function will properly contruct a string with helpful info to player
function string FormatPoolString(int i)
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
    if (DHGRI.VehiclePoolNextAvailableTimes[i] == 0)
    {
        add = add @ "Ready";
    }
    else
    {
        add = add @ DHGRI.VehiclePoolNextAvailableTimes[i] @ "Before Ready";
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
        case lb_VehiclePools:
            PoolIndex = VehiclePoolIndices[lb_VehiclePools.List.Index];

            Log("------------------------------------------------------------------");
            Log("WTF IS THIS SHIT WORKING???   Index:" @ PoolIndex);
            Log("------------------------------------------------------------------");

            //Update pool index
            DHP.ServerChangeSpawn(DHP.SpawnPointIndex, PoolIndex);
            break;
    }
}

defaultproperties
{
    Background=Texture'DH_GUI_Tex.Menu.AlliesLoadout_BG'
    //OnPostDraw=OnPostDraw
    //OnKeyEvent=InternalOnKeyEvent
    //OnMessage=InternalOnMessage
    bNeverFocus=true

    VehiclePoolsUpdateTime=-1.0
    VehiclePoolIndex=-1

    // Pools Container
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=PoolsContainer_inst
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
    PoolsContainer=PoolsContainer_inst

    // Vehicle pool list box
    Begin Object Class=DHGuiListBox Name=PoolsLB
        SelectedStyleName="DHListSelectionStyle"
        OutlineStyleName="ItemOutline"
        bVisibleWhenEmpty=true
        bSorted=true
        //OnCreateComponent=Roles.InternalOnCreateComponent
        StyleName="DHSmallText"
        TabOrder=0
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_VehiclePools=PoolsLB
}
