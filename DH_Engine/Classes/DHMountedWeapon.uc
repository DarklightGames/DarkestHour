//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Abstract class for all stationary weapons such as mortars, heavy machine-guns
// that can be carried by infantry and deployed.
//==============================================================================

class DHMountedWeapon extends DHActorProxyWeapon
    abstract;

// Construction classes here are meant to be used to toggle the mount being used.
// This method was chosen because different mounts will have different placement
// rules and mechanics (a role best suited for being handled in constructions).
var array<class<DHConstruction_Vehicle> >   ConstructionClasses;
var int                                     ConstructionClassIndex;
var private DHVehicleState                  VehicleState;

var array<DHWeaponBarrelBundle> WeaponBarrelBundles;

var()       Material    HudAmmoIconMaterial;
var         int         HudAmmoCount;

// Deploying
var     bool    bDeploying;
var()   name    DeployAnimation;

var()   bool    bCanDeployWhileStanding;
var()   bool    bCanDeployWhileCrouched;
var()   bool    bCanDeployWhileCrawling;

var()   bool    bShouldAlignToGround;

var     bool    bIsEncumbering; // When true, player cannot run, go prone or switch weapons

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd;
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        HudAmmoCount;
}

simulated function Destroyed()
{
    local int i;

    super.Destroyed();

    // Destroy barrel bundles.
    for (i = 0; i < WeaponBarrelBundles.Length; ++i)
    {
        if (WeaponBarrelBundles[i] != none)
        {
            WeaponBarrelBundles[i].Destroy();
        }
    }
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
            P.bIsDeployingMountedWeapon = true;
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
            P.bIsDeployingMountedWeapon = false;
            P.SetLockViewRotation(false);
        }

        ServerDeployEnd(ProxyCursor.GroundActor, ProxyCursor.Location, ProxyCursor.Rotation);
    }

    exec simulated function Deploy()
    {
        return;
    }

    // Modified to prevent player from changing stance while he is crouched & deploying the weapon
    simulated function bool CanThrow();
    simulated function bool WeaponAllowJump();
    simulated function bool WeaponAllowCrouchChange();
    simulated function bool WeaponAllowProneChange();
    simulated function bool WeaponCanSwitch();
    function DropFrom(vector StartLocation);
    
Begin:
    PlayAnim(DeployAnimation);
    Sleep(GetAnimDuration(DeployAnimation));
    GotoState('Idle');
}

function class<DHVehicle> GetVehicleClass()
{
    // TODO: this sucks.
    return ConstructionClasses[ConstructionClassIndex].default.VehicleClasses[0].VehicleClass;
}

function DHVehicleState EnsureVehicleState()
{
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass();

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
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass();

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

        for (i = 0; i < WeaponBarrelBundles.Length; ++i)
        {
            if (WeaponBarrelBundles[i] != none &&
                WeaponBarrelBundles[i].ReplaceInactiveFailedBarrels() > 0)
            {
                bDidResupplyWeapon = true;
            }
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
    local DHMountedWeaponProxy Cursor;

    Cursor = Spawn(class'DHMountedWeaponProxy', Instigator);
    Cursor.SetConstructionClass(ConstructionClasses[ConstructionClassIndex]);

    return Cursor;
}

// Implemented to force player to equip the stationary weapon if it isn't already his current weapon
simulated function Tick(float DeltaTime)
{
    if (Instigator != none && Instigator.Weapon != self && Instigator.PendingWeapon != self && Instigator.IsLocallyControlled() && bIsEncumbering)
    {
        Instigator.SwitchWeapon(InventoryGroup);
    }
    else
    {
        super.Tick(DeltaTime);
    }

    if (CanConfirmPlacement())
    {
        Instigator.ReceiveLocalizedMessage(class'DHMountedWeaponControlsMessage', 0, Instigator.PlayerReplicationInfo, none, self);
    }

}

// Copied from ROWeapon as we don't want to use PutDown from superclass for MMGs and mortars
simulated function bool PutDown()
{
 	GotoState('LoweringWeapon');

	if (ROWeaponAttachment(ThirdPersonActor) != None)
	{
		ROWeaponAttachment(ThirdPersonActor).AmbientSound = None;
	}

    OldWeapon = None;
    return true; // return false if preventing weapon switch
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

simulated function bool WeaponAllowSprint()
{
    if (bIsEncumbering)
    {
        return false;
    }
    
    return super.WeaponAllowSprint();
}

simulated function bool WeaponAllowProneChange()
{
    if (bIsEncumbering)
    {
        return false;
    }

    return super.WeaponAllowProneChange();
}      
    
simulated function bool WeaponCanSwitch()
{
    if (bIsEncumbering)
    {
        return false;
    }
    
    return super.WeaponCanSwitch();
}

simulated function bool WeaponAllowMantle()
{
    if (bIsEncumbering)
    {   
        return false;
    }
    
    return super.WeaponAllowMantle();
}

// Modified to unhide cursor when player raised his weapon
simulated state RaisingWeapon
{
    simulated function EndState()
    {
        super.EndState();

        ProxyCursor.bHidden=false;
    }
}

// Implemented so pressing the deploy key will attempt to deploy a carried stationary weapon
exec simulated function Deploy()
{
    local DHPawn  P;

    P = DHPawn(Instigator);
    // BUG: player can drop the weapon while in this state, bricking the pawn's movement until it dies.
    // solution: don't let them drop the weapon while deploying.

    if (CanConfirmPlacement() && P.Physics != PHYS_Falling) // Don't allow player to deploy mmg when he is jumping 
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

    return super.CanConfirmPlacement();
}

function bool CanSpawnVehicle(Actor Owner, Vector Location, Rotator Rotation)
{
    local DHMountedWeaponProxy TestProxy;
    local DHActorProxy.ActorProxyError Error;

    // Create a proxy to test placement logic on the server-side.
    TestProxy = Spawn(class'DHMountedWeaponProxy', Instigator);

    if (TestProxy == none)
    {
        return false;
    }

    TestProxy.GroundActor = Owner;
    TestProxy.SetConstructionClass(ConstructionClasses[ConstructionClassIndex]);
    TestProxy.SetLocation(Location);
    TestProxy.SetRotation(Rotation);

    // HACK: We set this to true to signal to the error checker that we should
    // not raise errors when we are overlapping other proxies.
    TestProxy.bHidden = true;

    Error = TestProxy.GetPositionError();

    TestProxy.Destroy();

    return Error.Type == ERROR_None;
}

// New function to spawn the deployed stationary weapon, which is a Vehicle actor, & to destroy the carried weapon.
function ServerDeployEnd(Actor Owner, Vector Location, Rotator Rotation)
{
    local DHVehicle Vehicle;
    local class<DHVehicle> VehicleClass;
    local DHMountedMG MG;
    local int i;
    
    if (!CanSpawnVehicle(Owner, Location, Rotation))
    {
        Log("Can't spawn vehicle for some reason");

        return;
    }

    VehicleClass = GetVehicleClass();

    if (VehicleClass == none)
    {
        Log("Vehicle class is None");

        return;
    }

    Vehicle = Spawn(VehicleClass,,, ProxyCursor.Location, ProxyCursor.Rotation);

    if (Vehicle == none)
    {
        // Either failed to trace a location to spawn the stationary weapon, or somehow failed to spawn it.
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

    // Transfer the barrel bundle to the MG weapon.
    for (i = 0; i < Vehicle.WeaponPawns.Length; ++i)
    {
        if (Vehicle.WeaponPawns[i] == none)
        {
            continue;
        }

        MG = DHMountedMG(Vehicle.WeaponPawns[i].Gun);

        if (MG != none && WeaponBarrelBundles[i] != none)
        {
            MG.SetBarrelBundle(WeaponBarrelBundles[i]);
            WeaponBarrelBundles[i] = none;
        }
    }
    
    // Destroy the carried weapon, as it's now been replaced by the deployed weapon.
    Destroy();
}

// Functions emptied out as carried stationary weapons cannot be fired, ironsighted or reloaded:
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
    if (default.ConstructionClasses[0].default.VehicleClass != none)
    {
        return default.ConstructionClasses[0].default.VehicleClass.default.VehicleNameString;
    }

    return super.GetInventoryName(bUseNativeItemNames);
}

final function CycleVariant()
{
    local DHMountedWeaponProxy Proxy;

    Proxy = DHMountedWeaponProxy(ProxyCursor);

    if (Proxy != none && ConstructionClasses.Length > 1)
    {
        ConstructionClassIndex = ++ConstructionClassIndex % ConstructionClasses.Length;

        Proxy.SetConstructionClass(ConstructionClasses[ConstructionClassIndex]);

        ClientPlayClickSound();
    }
}

exec simulated function SwitchFireMode()
{
    CycleVariant();
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

protected simulated function bool ShouldAlignToGround()
{
    return bShouldAlignToGround;
}

// Display debug info for the barrel bundles.
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local int i;

    super.DisplayDebug(Canvas, YL, YPos);

    for (i = 0; i < WeaponBarrelBundles.Length; ++i)
    {
        YPos += YL;
        Canvas.SetPos(4, YPos);
        Canvas.DrawText("WeaponBarrelBundles[" $ i $ "] @ " $ WeaponBarrelBundles[i]);

        if (WeaponBarrelBundles[i] != none)
        {
            WeaponBarrelBundles[i].DisplayDebug(Canvas, YL, YPos);
        }
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
    bCanDeployWhileStanding=true
    bCanDeployWhileCrawling=true
    bShouldAlignToGround=true
    bIsEncumbering=true
}

