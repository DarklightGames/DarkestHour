//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROMountedTankMG extends ROMountedTankMG
      abstract;

// Reload stuff
var()   sound ReloadSound; // sound of this MG reloading
var     bool  bReloading;  // This MG is currently reloading
var     int   NumMags;     // Number of mags carried for this MG;

// MG collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon)
var class<DH_VehicleWeaponCollisionMeshActor> CollisionMeshActorClass; // specify a valid class in default props & the col static mesh will automatically be used
var DH_VehicleWeaponCollisionMeshActor        CollisionMeshActor;

// Stuff for fire effects - Ch!cKeN
var()   name                                    FireAttachBone;
var()   vector                                  FireEffectOffset;
var     class<VehicleDamagedEffect>             FireEffectClass;
var     VehicleDamagedEffect                    HullMGFireEffect;
var     bool                                    bOnFire;   // Set by Treadcraft base to notify when to start fire effects
var     float                                   BurnTime;

var     class<DamageType>   VehicleBurningDamType;
var     float               PlayerFireDamagePerSec;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire;
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        bReloading, NumMags;
}
//==============================================================================

// Matt: modified to handle new collision static mesh actor, if one has been specified
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (CollisionMeshActorClass != none)
    {
        CollisionMeshActor = Spawn(CollisionMeshActorClass, self); // vital that this VehicleWeapon owns the col mesh actor

        if (CollisionMeshActor != none)
        {
            // Remove all collision from this VehicleWeapon class (instead let col mesh actor handle collision detection)
            SetCollision(false, false); // bCollideActors & bBlockActors both false
            bBlockNonZeroExtentTraces = false;
            bBlockZeroExtentTraces = false;

            // Attach col mesh actor to our yaw bone, so the col mesh will rotate with the MG
            AttachToBone(CollisionMeshActor, YawBone);

            // Attach col mesh actor to our yaw bone, so the col mesh will rotate with the MG
            AttachToBone(CollisionMeshActor, YawBone);

            // The col mesh actor will be positioned on the yaw bone, so we want to reposition it to align with the MG
            SetRelativeLocation(Location - GetBoneCoords(YawBone).Origin);
        }
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (bOnFire && HullMGFireEffect == none)
    {
        // Lets randomise the fire start times to desync them with the driver and engine ones
        if (Level.TimeSeconds - BurnTime > 0.2)
        {
            if (FRand() < 0.1)
            {
                HullMGFireEffect = Spawn(FireEffectClass);
                AttachToBone(HullMGFireEffect, FireAttachBone);
                HullMGFireEffect.SetRelativeLocation(FireEffectOffset);
                HullMGFireEffect.UpdateDamagedEffect(true, 0, false, false);
            }

            BurnTime = Level.TimeSeconds;
        }
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (HullMGFireEffect != none)
    {
        HullMGFireEffect.Destroy();
    }
}

// Returns true if this weapon is ready to fire
simulated function bool ReadyToFire(bool bAltFire)
{
    //log("bReloading = "$bReloading);

    if (bReloading)
        return false;

    return super.ReadyToFire(bAltFire);
}

function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (!bReloading && !HasAmmo(0))
        HandleReload();
}

function HandleReload()
{
    if (NumMags > 0 && !bReloading)
    {
        bReloading = true;
        NumMags--;
        NetUpdateTime = Level.TimeSeconds - 1;
        SetTimer(GetSoundDuration(ReloadSound), false);
        PlaySound(ReloadSound, SLOT_None,1.5,, 25,, true);
    }
}

simulated function Timer()
{
   if (bReloading)
   {
        if (Role == ROLE_Authority)
        {
            bReloading = false;
            MainAmmoCharge[0] = InitialPrimaryAmmo;
            NetUpdateTime = Level.TimeSeconds - 1;
        }
   }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
    if (Role != ROLE_Authority || bForceCenterAim)
        return false;

    if (FireCountdown <= 0)
    {
        CalcWeaponFire(bAltFire);
        if (bCorrectAim)
            WeaponFireRotation = AdjustAim(bAltFire);

        if (bAltFire)
        {
            if (AltFireSpread > 0)
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*AltFireSpread);
        }
        else if (Spread > 0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*Spread);
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);
        if (bAltFire)
        {
            if (!ConsumeAmmo(2))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                return false;
            }
            FireCountdown = AltFireInterval;
            AltFire(C);
        }
        else
        {
            if (bMultipleRoundTypes)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    if (!ConsumeAmmo(0))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                }
            }
            else if (!ConsumeAmmo(0))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();
                return false;
            }

            FireCountdown = FireInterval;
            Fire(C);
        }
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

// Fill the ammo up to the initial ammount
function bool GiveInitialAmmo()
{
    local bool bDidResupply;

    if (NumMags != default.NumMags)
    {
        bDidResupply = true;
    }

    MainAmmoCharge[0] = InitialPrimaryAmmo;
    MainAmmoCharge[1] = InitialSecondaryAmmo;
    AltAmmoCharge = InitialAltAmmo;
    NumMags = default.NumMags;

    return bDidResupply;
}

function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (MainAmmoCharge[0] < InitialPrimaryAmmo)
    {
        MainAmmoCharge[0] = InitialPrimaryAmmo;

        bDidResupply = true;
    }

    if (MainAmmoCharge[1] < InitialSecondaryAmmo)
    {
        MainAmmoCharge[1] = InitialSecondaryAmmo;

        bDidResupply = true;
    }

    if (AltAmmoCharge < InitialAltAmmo)
    {
        ++AltAmmoCharge;

        bDidResupply = true;
    }

    if (NumMags < default.NumMags)
    {
        ++NumMags;

        bDidResupply = true;
    }

    return bDidResupply;
}

simulated function int getNumMags()
{
    return NumMags;
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

/**
    Matt: shell's ProcessTouch now calls TD on VehicleWeapon instead of VehicleBase & for vehicle MG this is not counted as hit on vehicle itself
    But we can add any desired functionality here or in subclasses, e.g. shell could wreck MG
    Note that if calling a damage function & DamageType.bDelayedDamage, we need to call SetDelayedDamageInstigatorController(InstigatedBy.Controller) on the relevant pawn
*/

    // Matt: removed as shell & bullet's ProcessTouch now call TakeDamage directly on Driver if he was hit
    //  if (HitDriver(Hitlocation, Momentum))
//  {
//      ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
//  }
}

// Matt: had to re-state as a simulated function so can be called on net client by HitDriver/HitDriverArea, giving correct clientside effects for projectile hits
simulated function bool IsPointShot(vector Loc, vector Ray, float AdditionalScale, int Index)
{
    local  coords  C;
    local  vector  HeadLoc, B, M, Diff;
    local  float   t, DotMM, Distance;

    if (VehHitpoints[Index].PointBone == '')
    {
        return false;
    }

    C = GetBoneCoords(VehHitpoints[Index].PointBone);
    HeadLoc = C.Origin + (VehHitpoints[Index].PointHeight * VehHitpoints[Index].PointScale * AdditionalScale * C.XAxis);
    HeadLoc = HeadLoc + (VehHitpoints[Index].PointOffset >> rotator(C.Xaxis));

    // Express snipe trace line in terms of B + tM
    B = Loc;
    M = Ray * 150.0;

    // Find point-line squared distance
    Diff = HeadLoc - B;
    t = M dot Diff;

    if (t > 0.0)
    {
        DotMM = M dot M;

        if (t < DotMM)
        {
            t = t / DotMM;
            Diff = Diff - (t * M);
        }
        else
        {
            t = 1.0;
            Diff -= M;
        }
    }
    else
    {
        t = 0.0;
    }

    Distance = Sqrt(Diff dot Diff);

    return (Distance < (VehHitpoints[Index].PointRadius * VehHitpoints[Index].PointScale * AdditionalScale));
}

simulated function Destroyed() // Matt: added
{
    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.Destroy();
    }

    super.Destroyed();
}

defaultproperties
{
    FireAttachBone="mg_pitch"
    FireEffectOffset=(X=10.000000,Z=5.000000)
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    VehicleBurningDamType=class'DH_VehicleBurningDamType'
}
