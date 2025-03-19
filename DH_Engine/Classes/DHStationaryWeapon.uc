//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Abstract class for all stationary weapons such as mortars, heavy machine-guns
// that can be carried by infantry and deployed.
//==============================================================================

class DHStationaryWeapon extends DHActorProxyWeapon
    abstract;

var     class<DHVehicle>    VehicleClass;
var     DHVehicleState      VehicleState;

// Deploying
var     bool    bDeploying;
var     name    DeployAnimation;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd;
}

simulated function DHActorProxy CreateProxyCursor()
{
    local DHVehicleProxy Cursor;

    Cursor = Spawn(class'DHVehicleProxy', Instigator);
    Cursor.SetVehicleClass(VehicleClass);

    return Cursor;
}

// Implemented to force player to equip the stationary weapon if it isn't already his current weapon
// TODO: not necessarily universal; some carried weapons may be small enough to be put away.
simulated function Tick(float DeltaTime)
{
    if (Instigator != none && Instigator.Weapon != self && Instigator.PendingWeapon != self && Instigator.IsLocallyControlled())
    {
        Instigator.SwitchWeapon(InventoryGroup);
    }
    else
    {
        super.Tick(DeltaTime);
    }
}

// Modified to add a hint when carrying a stationary weapon.
simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPlayer PC;

    super.BringUp(PrevWeapon);

    PC = DHPlayer(Instigator.Controller);

    if (PC != none)
    {
        PC.QueueHint(6, true);
    }
}

// Functions always returning false as carried mortar is too heavy & bulky to put away, or to sprint, crawl, or mantle with
simulated function bool WeaponCanSwitch()
{
    return false;
}

simulated function bool WeaponAllowSprint()
{
    return false;
}

simulated function bool WeaponAllowProneChange()
{
    return false;
}

simulated function bool WeaponAllowMantle()
{
    return false;
}

// Implemented so pressing the deploy key will attempt to deploy a carried mortar
exec simulated function Deploy()
{
    local DHPawn  P;
    local Rotator LockedViewRotation;

    if (bDeploying)
    {
        return;
    }

    P = DHPawn(Instigator);

    // BUG: player can drop the weapon while in this state, bricking the pawn's movement until it dies.
    // solution: don't let them drop the weapon while deploying.

    if (CanDeploy(P))
    {
        PlayAnim(DeployAnimation);
        bDeploying = true;
        P.bIsDeployingStationaryWeapon = true;

        P.SetLockViewRotation(true, P.Controller.Rotation); // makes the pawn lock view pitch & yaw
    }
}

// New function to check whether the player can deploy the mortar where they are, with explanatory screen messages if they can't
simulated function bool CanDeploy(DHPawn P)
{
    // TODO: re-add check for being stationary & crouched, with no leaning.

    return ProxyCursor != none && ProxyCursor.ProxyError.Type == ERROR_None;
}

// Modified to prevent player from changing stance while he is crouched & deploying the mortar
simulated function bool WeaponAllowCrouchChange()
{
    return !bDeploying && super.WeaponAllowCrouchChange();
}

// Modified so when the deploy animation ends, we update the DHPawn & notify the server that mortar is now deployed
simulated event AnimEnd(int Channel)
{
    local DHPawn P;

    if (bDeploying)
    {
        P = DHPawn(Instigator);

        if (P != none)
        {
            P.bIsDeployingStationaryWeapon = false;
            P.SetLockViewRotation(false);
        }

        ServerDeployEnd(ProxyCursor.GroundActor, ProxyCursor.Location, ProxyCursor.Rotation);
    }
}

function bool CanSpawnVehicle(Actor Owner, Vector Location, Rotator Rotation)
{
    local DHVehicleProxy TestProxy;
    local DHActorProxy.ActorProxyError Error;

    // Create a proxy to test placement logic on the server-side.
    TestProxy = Spawn(class'DHVehicleProxy', Instigator);

    if (TestProxy == none)
    {
        return false;
    }

    TestProxy.GroundActor = Owner;
    TestProxy.SetVehicleClass(VehicleClass);
    TestProxy.SetLocation(Location);
    TestProxy.SetRotation(Rotation);

    // HACK: We set this to true to signal to the error checker that we should
    // not raise errors when we are overlapping other proxies.
    TestProxy.bHidden = true;

    Error = TestProxy.GetPositionError();

    TestProxy.Destroy();

    return Error.Type == ERROR_None;
}

// New function to spawn the deployed mortar, which is a Vehicle actor, & to destroy this carried Weapon version of the mortar
function ServerDeployEnd(Actor Owner, Vector Location, Rotator Rotation)
{
    local DHVehicle Vehicle;
    
    if (!CanSpawnVehicle(Owner, Location, Rotation))
    {
        return;
    }

    Vehicle = Spawn(VehicleClass,,, ProxyCursor.Location, ProxyCursor.Rotation);

    if (Vehicle == none)
    {
        // Either failed to trace a location to spawn the mortar, or somehow failed to spawn it.
        GotoState('Idle');
        return;
    }

    // Set the team, otherwise the team wil default to the team defined vehicle class.
    Vehicle.SetTeamNum(Instigator.GetTeamNum());

    // Transfer saved vehicle state to the newly spawned vehicle.
    if (VehicleState != none)
    {
        Vehicle.SetVehicleState(VehicleState);
    }
    
    // Destroy the carried weapon, as it's now been replaced by the deployed weapon.
    Destroy();
}

// Functions emptied out as carried mortar weapons cannot be fired, ironsighted or reloaded:
simulated function Fire(float F);
simulated function AltFire(float F);
simulated function WeaponFire GetFireMode(byte Mode);
simulated event ClientStartFire(int Mode);
simulated event ClientStopFire(int Mode);
event ServerStartFire(byte Mode);
function ServerStopFire(byte Mode);
simulated function bool StartFire(int Mode) { return false; }
simulated event StopFire(int Mode);
simulated function ImmediateStopFire();
simulated function ROIronSights();
exec simulated function ROManualReload();

static function string GetInventoryName(bool bUseNativeItemNames)
{
    if (default.VehicleClass != none)
    {
        return default.VehicleClass.default.VehicleNameString;
    }

    return super.GetInventoryName(bUseNativeItemNames);
}

// TODO: use state instead.
function DropFrom(vector StartLocation)
{
    if (bDeploying)
    {
        return;
    }

    super.DropFrom(StartLocation);
}

defaultproperties
{
    InventoryGroup=9
    Priority=99 // super high value so this weapon is always ranked as best/preferred weapon to bring up
    bCanSway=false
    bCanResupplyWhenEmpty=false
    SelectAnim="Draw"
    PutDownAnim="putaway"
    DeployAnimation="Deploy"
    AIRating=1.0
    CurrentRating=1.0
    bCanThrow=true
    TraceDepthMeters=1.5
}
