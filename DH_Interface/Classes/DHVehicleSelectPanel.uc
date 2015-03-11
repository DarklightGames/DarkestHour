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

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    // Vehicle pool container
    li_VehiclePools = ROGUIListPlus(lb_VehiclePools.List);
    PoolsContainer.ManageComponent(lb_VehiclePools);

    // Need a function that can set up the vehicle pool list
    // showing disabled ones also


    // Set initial counts
    Timer();
    SetTimer(0.1, true);
}

function Timer()
{
    //UpdateVehiclePools();

    //Need an updater function
}

function InitializeVehiclePools()
{


}

function UpdateVehiclePools()
{


}

/*
function UpdateVehiclePools()
{
    local int i, j;
    local string S;
    local DHPlayer C;
    local DHGameReplicationInfo DHGRI;
    local bool bIsEnabled;

    C = DHPlayer(PlayerOwner());

    if (C == none || DHPlayerReplicationInfo(C.PlayerReplicationInfo) == none)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(C.GameReplicationInfo);

    if (DHGRI == none)
    {
        return;
    }

    if (VehiclePoolsUpdateTime < DHGRI.VehiclePoolsUpdateTime)
    {
        //the vehicle pools were modified in such a way that requires
        //us to repopulate the list
        li_VehiclePools.Clear();

        VehiclePoolIndices.Length = 0;

        for (i = 0; i < arraycount(DHGRI.VehiclePoolIsActives); ++i)
        {
            if (DHGRI.VehiclePoolIsActives[i] == 0 ||
                DHGRI.VehiclePoolVehicleClasses[i].default.VehicleTeam != C.GetTeamNum())
            {
                //do not display inactive pools or those not belonging to player's team
                continue;
            }

            li_VehiclePools.Add(DHGRI.VehiclePoolVehicleClasses[i].default.VehicleNameString);

            Log("li_VehiclePools.SetExtraAtIndex(" $ li_VehiclePools.ItemCount - 1 $ ") =" @ i);

            li_VehiclePools.SetExtraAtIndex(li_VehiclePools.ItemCount - 1, "" $ i);

            VehiclePoolIndices[VehiclePoolIndices.Length] = i;
        }

        VehiclePoolsUpdateTime = DHGRI.VehiclePoolsUpdateTime;
    }

    for (i = 0; i < VehiclePoolIndices.Length; ++i)
    {
        j = VehiclePoolIndices[i];

        //build list entry string
        S = DHGRI.VehiclePoolVehicleClasses[j].default.VehicleNameString;

        if (!DHGRI.IsVehiclePoolInfinite(j))
        {
            //show vehicle spawns remaining if pool is not infinite
            S @= "[" $ DHGRI.VehiclePoolSpawnsRemainings[j] $ "]";
        }

        if (C.Level.TimeSeconds < DHGRI.VehiclePoolNextAvailableTimes[j])
        {
            //show countdown timer
            S @= "(" $ class'ROHud'.static.GetTimeString(DHGRI.VehiclePoolNextAvailableTimes[j] - C.Level.TimeSeconds) $ ")";

            bIsEnabled = false;
        }

        if (DHGRI.VehiclePoolSpawnsRemainings[j] == 0)
        {
            bIsEnabled = false;
        }

        li_VehiclePools.SetItemAtIndex(i, S);
        li_VehiclePools.SetExtraAtIndex(i, "" $ j);

        //TODO: this fucking shit fuction overrides out extra value, figure out a way around it
        //li_Roles.SetDisabledAtIndex(i, bIsEnabled);
    }
}
*/





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
        //OnChange=DHRoleSelectPanel.InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_VehiclePools=PoolsLB
}
