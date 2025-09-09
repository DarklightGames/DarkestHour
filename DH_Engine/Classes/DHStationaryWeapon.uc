//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Abstract class for all stationary weapons such as mortars, heavy machine-guns
// that can be carried by infantry and deployed.
//==============================================================================

class DHStationaryWeapon extends DHActorProxyWeapon
    abstract;

var         class<DHVehicle>    VehicleClass;
var private DHVehicleState      VehicleState;

var()       Material    HudAmmoIconMaterial;
var         int         HudAmmoCount;

// Deploying
var     bool    bDeploying;
var()   name    DeployAnimation;

var()   bool    bCanDeployWhileStanding;
var()   bool    bCanDeployWhileCrouched;
var()   bool    bCanDeployWhileCrawling;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd;
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        HudAmmoCount;
}

simulated state Deploying
{
    simulated function BeginState()
    {
        local DHPawn P;

        super.BeginState();

        P = DHPawn(Instigator);

        if (P != none)
        {
            P.bIsDeployingStationaryWeapon = true;
            P.SetLockViewRotation(true, P.Controller.Rotation); // makes the pawn lock view pitch & yaw
        }
    }

    simulated function EndState()
    {
        local DHPawn P;

        super.EndState();
        
        P = DHPawn(Instigator);

        if (P != none)
        {
            P.bIsDeployingStationaryWeapon = false;
            P.SetLockViewRotation(false);
        }

        ServerDeployEnd(ProxyCursor.GroundActor, ProxyCursor.Location, ProxyCursor.Rotation);
    }

    exec simulated function Deploy()
    {
        return;
    }

    // Modified to prevent player from changing stance while he is crouched & deploying the mortar
    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool CanThrow()
    {
        return false;
    }

Begin:
    PlayAnim(DeployAnimation);
    Sleep(GetAnimDuration(DeployAnimation));
    GotoState('Idle');
}

function DHVehicleState EnsureVehicleState()
{
    if (VehicleState == none)
    {
        VehicleState = Class'DHVehicleState'.static.GetDefaultVehicleState(VehicleClass);
    }

    return VehicleState;
}

function DHVehicleState GetVehicleState()
{
    return VehicleState;
}

function SetVehicleState(DHVehicleState State)
{
    VehicleState = State;

    if (VehicleState == none)
    {
        return;
    }

    UpdateHudAmmoCount();
}

function UpdateHudAmmoCount()
{
    if (VehicleState != none)
    {
        HudAmmoCount = VehicleState.GetTotalMainAmmoCharges();
    }
    else
    {
        HudAmmoCount = 0;
    }
}

function bool FillAmmo()
{
    local int i, j;
    local bool bDidResupply, bDidResupplyWeapon, bDidResupplyCannon;
    local int MainAmmoResupplyCount;
    local DHVehicleWeaponState VehicleWeaponState;
    local class<DHVehicleWeapon> VehicleWeaponClass;
    local class<DHVehicleCannon> VehicleCannonClass;

    if (VehicleClass == none)
    {
        return false;
    }

    EnsureVehicleState();

    if (Level.TimeSeconds <= LastResupplyTimestamp + ResupplyInterval)
    {
        return false;
    }

    for (i = 0; i < VehicleState.WeaponStates.Length; ++i)
    {
        bDidResupplyWeapon = false;

        if (VehicleState.WeaponStates[i] == none || VehicleClass.default.PassengerWeapons[i].WeaponPawnClass == none)
        {
            continue;
        }

        VehicleWeaponClass = class<DHVehicleWeapon>(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass);

        if (VehicleWeaponClass == none)
        {
            continue;
        }

        VehicleWeaponState = VehicleState.WeaponStates[i];

        if (VehicleWeaponState.NumMGMags < VehicleWeaponClass.default.NumMGMags)
        {
            ++VehicleWeaponState.NumMGMags;
            bDidResupplyWeapon = true;
        }

        if (ClassIsChildOf(VehicleWeaponClass, Class'DHVehicleCannon'))
        {
            VehicleCannonClass = class<DHVehicleCannon>(VehicleWeaponClass);
            MainAmmoResupplyCount = VehicleCannonClass.default.MainAmmoResupplyPerInterval;

            do
            {
                bDidResupplyCannon = false;
                for (j = 0; j < arraycount(VehicleWeaponState.MainAmmoCharge); ++j)
                {
                    if (MainAmmoResupplyCount > 0 && VehicleWeaponState.MainAmmoCharge[j] < VehicleCannonClass.static.GetMaxAmmo(j))
                    {
                        ++VehicleWeaponState.MainAmmoCharge[j];
                        --MainAmmoResupplyCount;
                        bDidResupplyCannon = true;
                        bDidResupplyWeapon = true;
                    }
                }
            }
            until (MainAmmoResupplyCount == 0 || bDidResupplyCannon == false);
        }

        if (bDidResupplyWeapon)
        {
            VehicleWeaponState.LastResupplyTimestamp = Level.TimeSeconds;
            bDidResupply = true;
        }
    }

    if (bDidResupply)
    {
        UpdateHudAmmoCount();
        LastResupplyTimestamp = Level.TimeSeconds;
    }

    return bDidResupply;
}

// Modified so that the UI knows when we're out of ammo and can show the ammo icon greyed out.
simulated function int AmmoAmount(int Mode)
{
    return HudAmmoCount;
}

// Modified so HUD shows ammo count in the current vehicle state.
simulated function int GetHudAmmoCount()
{
    return HudAmmoCount;
}

simulated function Material GetHudAmmoIconMaterial()
{
    return HudAmmoIconMaterial;
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

    if (CanConfirmPlacement())
    {
        Instigator.ReceiveLocalizedMessage(class'DHStationaryWeaponControlsMessage', 0, Instigator.PlayerReplicationInfo, none, self);
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

// Implemented so pressing the deploy key will attempt to deploy a carried mortar
exec simulated function Deploy()
{
    local DHPawn  P;
    local Rotator LockedViewRotation;

    P = DHPawn(Instigator);

    // BUG: player can drop the weapon while in this state, bricking the pawn's movement until it dies.
    // solution: don't let them drop the weapon while deploying.

    if (CanConfirmPlacement())
    {
        GotoState('Deploying');
    }
}

simulated function bool CanConfirmPlacement()
{
    local DHPawn P;

    if (!IsInState('Idle'))
    {
        return false;
    }

    P = DHPawn(Instigator);

    if (P != none && (P.bLeanLeft || P.bLeanRight))
    {
        // Don't allow deploying while leaning.
        return false;
    }

    return super.CanConfirmPlacement();
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
 
public function bool ShouldShowProxyCursor()
{
    local DHPawn P;

    if (!super.ShouldShowProxyCursor())
    {
        return false;
    }

    P = DHPawn(Instigator);

    if (P == none)
    {
        return false;
    }

    if (P.bIsCrouched)
    {
        return bCanDeployWhileCrouched;
    }
    else if (P.bIsCrawling)
    {
        return bCanDeployWhileCrawling;
    }
    else
    {
        return bCanDeployWhileStanding;
    }
}

defaultproperties
{
    InventoryGroup=9
    Priority=99 // super high value so this weapon is always ranked as best/preferred weapon to bring up
    bCanSway=false
    bCanResupplyWhenEmpty=false
    SelectAnim="draw"
    PutDownAnim="putaway"
    DeployAnimation="deploy"
    SprintStartAnim="sprint_start"
    SprintEndAnim="sprint_end"
    SprintLoopAnim="sprint_middle"
    bUsesFreeAim=true
    AIRating=1.0
    CurrentRating=1.0
    bCanThrow=true
    TraceDepthMeters=1.25
    bCanRotateCursor=false
    bCanDeployWhileCrouched=true
}
