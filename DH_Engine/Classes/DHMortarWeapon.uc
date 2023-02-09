//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarWeapon extends DHWeapon
    abstract;

var     class<DHMortarVehicle>  VehicleClass;

// Deploying
var     bool    bDeploying;
var     name    DeployAnimation;
var     float   DeployRadius;
var     float   DeployAngleMaximum;

// Ammo
var     int     HighExplosiveMaximum;
var     int     HighExplosiveResupplyCount;
var     int     SmokeMaximum;
var     int     SmokeResupplyCount;

enum EDeployError
{
    DE_None,            // 0
    DE_BadStance,       // 1
    DE_Fatal,           // 2
    DE_Moving,          // 3
    DE_BadSurface,      // 4
    DE_NotEnoughRoom,   // 5
    DE_Leaning,         // 6
    DE_BadVolume,       // 7
};

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd;
}

// Implemented to force player to equip the mortar if it isn't already his current weapon
simulated function Tick(float DeltaTime)
{
    if (Instigator != none && Instigator.Weapon != self && Instigator.PendingWeapon != self && Instigator.IsLocallyControlled())
    {
        Instigator.SwitchWeapon(InventoryGroup);
    }
}

// Modified to add a hint when carrying a mortar
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(6, false);
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
    local rotator LockedViewRotation;

    if (!bDeploying)
    {
        P = DHPawn(Instigator);

        if (CanDeploy(P))
        {
            PlayAnim(DeployAnimation);
            bDeploying = true;
            P.bIsDeployingMortar = true;

            LockedViewRotation = P.Rotation;
            LockedViewRotation.Pitch = 0;
            P.SetLockViewRotation(true, LockedViewRotation); // makes the pawn lock view pitch & yaw
        }
    }
}

simulated function EDeployError GetDeployError(DHPawn P)
{
    local Actor        HitActor;
    local DHVolumeTest VolumeTest;
    local bool         bIsInNoArtyVolume;
    local vector       HitLocation, HitNormal, TraceEnd, TraceStart;
    local rotator      TraceRotation;

    // Can't deploy if we're busy, raising the weapon, on fire or somehow crawling
    // If we don't check state RaisingWeapon, it allows the player to almost instantaneously redeploy a mortar after undeploying
    if (P == none || P.Controller == none || IsBusy() || IsInState('RaisingWeapon') || P.bOnFire || P.bIsCrawling)
    {
        return DE_Fatal;
    }
    
    // Can't deploy if we're in water
    if (P.PhysicsVolume.bWaterVolume || P.PhysicsVolume.bPainCausing)
    {
        return DE_BadVolume;
    }

    // Can't deploy if we're not crouching
    if (!P.bIsCrouched)
    {
        return DE_BadStance;
    }

    // Can't deploy if we're moving
    if (P.Velocity != vect(0.0, 0.0, 0.0))
    {
        return DE_Moving;
    }

    // Can't deploy if we're leaning
    if (P.bLeaningLeft || P.bLeaningRight)
    {
        return DE_Leaning;
    }
    
    // Check we're standing on a level, static surface, by tracing straight downwards to see what we're standing on
    TraceStart = P.Location;
    TraceEnd = TraceStart - vect(0.0, 0.0, 128.0);
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

    // Can't deploy if we're not standing on a static surface
    if (HitActor == none || !HitActor.bStatic)
    {
        // "You cannot deploy your mortar on this surface"
        return DE_BadSurface;
    }
    // Can't deploy if the surface angle is too steep
    else if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) > DeployAngleMaximum)
    {
        // "You cannot deploy your mortar on this surface"
        return DE_BadSurface;
    }
    else
    {
        // Ok, we're standing on a level, static surface, but now check we also have a clear, level surface all around us
        // Trace in 8 directions around us in the X/Y plane, within our DeployRadius
        for (TraceRotation.Yaw = 0; TraceRotation.Yaw < 65535; TraceRotation.Yaw += 8192)
        {
            TraceEnd = P.Location + (DeployRadius * vector(TraceRotation));
            HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

            // Can't deploy if there's anything static around us
            if (HitActor != none && HitActor.bStatic)
            {
                // "You do not have enough room to deploy your mortar here"
                return DE_NotEnoughRoom;
            }

            // Now trace downwards from the end point of our previous trace, to make sure there's a level surface there
            TraceStart = TraceEnd;
            TraceEnd = TraceStart - vect(0.0, 0.0, 128.0);
            HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

            // Can't deploy if there isn't a static surface there
            if (HitActor == none || !HitActor.bStatic)
            {
                // "You cannot deploy your mortar on this surface"
                return DE_BadSurface;
            }
            // Can't deploy if the surface angle is too steep
            else if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) > DeployAngleMaximum)
            {
                // "You cannot deploy your mortar on this surface"
                return DE_BadSurface;
            }
        }
    }
    
    return DE_None;
}

// New function to check whether the player can deploy the mortar where they are, with explanatory screen messages if they can't
simulated function bool CanDeploy(DHPawn P)
{
    local EDeployError Error;

    Error = GetDeployError(P);

    // We can't deploy the mortar if we registered an error in any of the checks above
    // Display a screen message to the player saying why he can't deploy
    if (Error != DE_None)
    {
        P.ReceiveLocalizedMessage(class'DHMortarMessage', int(Error));

        return false;
    }

    // Passed all tests so mortar can be deployed
    return true;
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
            P.bIsDeployingMortar = false;
            P.SetLockViewRotation(false);
        }

        ServerDeployEnd();
    }
}

// New function to spawn the deployed mortar, which is a Vehicle actor, & to destroy this carried Weapon version of the mortar
function ServerDeployEnd()
{
    local DHMortarVehicle DeployedMortar;
    local vector          TraceStart, TraceEnd, HitLocation, HitNormal;
    local rotator         SpawnRotation;

    TraceStart = Instigator.Location + (vect(0.0, 0.0, 1.0) * Instigator.CollisionHeight);
    TraceEnd = TraceStart + vect(0.0, 0.0, -128.0);

    if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true) != none)
    {
        SpawnRotation.Yaw = Instigator.Rotation.Yaw;
        DeployedMortar = Spawn(VehicleClass, Instigator,, HitLocation, SpawnRotation);

        if (DeployedMortar != none)
        {
            DeployedMortar.SetTeamNum(VehicleClass.default.VehicleTeam);
            DeployedMortar.KDriverEnter(Instigator); // note we don't bother with the typical TryToDrive() here as we can always enter
            Destroy(); // destroy this carried weapon version of the mortar, as it's been replaced by the deployed Vehicle version

            return;
        }
    }

    GotoState('Idle'); // either failed to trace a location to spawn the mortar, or somehow failed to spawn it
}

// Modified to always return true so any HasAmmo() checks are effectively bypassed
simulated function bool HasAmmo()
{
    return true;
}

// Implemented to check the DHPawn's ResupplyMortarAmmunition() function when another player tries to give ammo to the mortar carrier
function bool ResupplyAmmo()
{
    local bool bResupplied;
    bResupplied = (Level.TimeSeconds > (LastResupplyTimestamp + ResupplyInterval))
        && DHPawn(Instigator) != none
        && DHPawn(Instigator).ResupplyMortarAmmunition();
    if (bResupplied)
    {
        LastResupplyTimestamp = Level.TimeSeconds;
    }
    return bResupplied;
}

// Emptied out as mortar uses a different system in ammo resupply area, based on DHPawn.ResupplyMortarAmmunition(), with check whether the resupply area can resupply mortars
function bool FillAmmo()
{
    return false;
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

// Modified to allow same InventoryGroup items
function bool HandlePickupQuery(Pickup Item)
{
    local int i;

    // If no passed item, prevent pick up & stops checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can carry another
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (AmmoClass[i] != none && AmmoCharge[i] < MaxAmmo(i) && WeaponPickup(Item).AmmoAmount[i] > 0)
            {
                AddAmmo(WeaponPickup(Item).AmmoAmount[i], i);

                // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
                Item.AnnouncePickup(Pawn(Owner));
                Item.SetRespawn();

                break;
            }
        }

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
    InventoryGroup=9
    Priority=99 // super high value so mortar is always ranked as best/preferred weapon to bring up
    bCanThrow=false
    bCanSway=false

    SelectAnim="Draw"
    PutDownAnim="putaway"
    DeployAnimation="Deploy"
    DeployRadius=32.0
    DeployAngleMaximum=0.349066

    AIRating=1.0
    CurrentRating=1.0
}
