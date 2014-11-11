//===================================================================
// DH_ROMountedTankMG
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Base class for Darkest Hour mounted tank machine guns
//===================================================================
class DH_ROMountedTankMG extends ROMountedTankMG
      abstract;


// Stuff for fire effects - Ch!cKeN
var()   name                                    FireAttachBone;
var()   vector                                  FireEffectOffset;
var     class<VehicleDamagedEffect>             FireEffectClass;
var     VehicleDamagedEffect                    HullMGFireEffect;
var     bool                                    bOnFire;   // Set by Treadcraft base to notify when to start fire effects
var     float                                   BurnTime;

var     class<DamageType>   VehicleBurningDamType;
var     float               PlayerFireDamagePerSec;

var()   sound ReloadSound; // sound of this MG reloading
var     bool  bReloading;  // This MG is currently reloading
var     int   NumMags;     // Number of mags carried for this MG;

//==============================================================================
// replication
//==============================================================================
replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire;
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        bReloading, NumMags;
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
        PlaySound(ReloadSound, SLOT_none,1.5,, 25, ,true);
    }
}

simulated function Timer()
{
   if (bReloading)
   {
        if (Role == ROLE_Authority)
        {
            bReloading=false;
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

    if (NumMags < default.NumMags)
    {
        ++NumMags;

        bDidResupply = true;
    }

    return bDidResupply;
}

defaultproperties
{
     FireAttachBone="mg_pitch"
     FireEffectOffset=(X=10.000000,Z=5.000000)
     FireEffectClass=Class'ROEngine.VehicleDamagedEffect'
     VehicleBurningDamType=Class'DH_VehicleBurningDamType'
}
