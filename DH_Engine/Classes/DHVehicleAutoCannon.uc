//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleAutoCannon extends DHVehicleCannon;

// Number of remaining magazines for different ammo types
var     byte        NumPrimaryMags;
var     byte        NumSecondaryMags;
var     byte        NumTertiaryMags;

// Ejected shell case emitter
var class<Emitter>  ShellCaseEmitterClass;
var     Emitter     ShellCaseEmitter;
var     name        ShellCaseEjectorBone;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        NumPrimaryMags, NumSecondaryMags, NumTertiaryMags;
}

// TODO: plans for future autocannon functionality, for more generic & sophisticated handling of multiple barrels, mixed ammo, etc
/*
struct Barrel
{
var     name        WeaponFireAttachmentBone;
var     byte        FireGroup;
var     Emitter     FlashEmitter;
var     Emitter     ShellCaseEmitter;
};

var     array<Barrel>   Barrels;
var     byte            CurrentBarrelIndex;

var     byte            NumFireGroups;
var     byte            CurrentFireGroup;
var     byte            AllBarrelsFireIndex;
var     bool            bCycleFireGroupEachFire;

var     class<Projectile>   MixedMagProjClassA;
var     class<Projectile>   MixedMagProjClassB;
var     byte                MixedMagProjBFrequency;

struct FireAnims
{
var     name    ShootLoweredAnim;
var     name    ShootIntermediateAnim;
var     name    ShootRaisedAnim;
};

var     array<FireAnims>   FireGroupAnims;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        CurrentFireGroup; // after initial replication, the client should be able to keep track itself
}
*/

// Modified to add ShellCaseEmitter
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellCaseEmitter != none)
    {
        ShellCaseEmitter.Destroy();
    }
}

// Modified to spawn an emitter for the ejected shell cases
// Note we can't simply add a MeshEmitter to FlashEmitterClass because that's attached to barrel bone & when it recoils it messes up the ejected shell case location
simulated function InitEffects()
{
    super.InitEffects();

    if (Level.NetMode != NM_DedicatedServer && ShellCaseEmitter == none)
    {
        ShellCaseEmitter = Spawn(ShellCaseEmitterClass);

        if (ShellCaseEmitter != none)
        {
            AttachToBone(ShellCaseEmitter, ShellCaseEjectorBone);
        }
    }
}

// Modified to alternate between AP & HE rounds if firing a mixed mag
// Assumes PrimaryProjectileClass is the mixed mag & the AP & HE rounds are the SecondaryProjectileClass & TertiaryProjectileClass
function Fire(Controller C)
{
    if (ProjectileClass == class'DHCannonShell_MixedMag')
    {
        if ((InitialPrimaryAmmo - MainAmmoChargeExtra[0]) % 2.0 == 0.0 && SecondaryProjectileClass != none)
        {
            SpawnProjectile(SecondaryProjectileClass, false);
        }
        else if (TertiaryProjectileClass != none)
        {
            SpawnProjectile(TertiaryProjectileClass, false);
        }
    }
    else
    {
        super.Fire(C);
    }
}

// Modified to trigger new shell case emitter every time we fire
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super.FlashMuzzleFlash(bWasAltFire);

    if (ShellCaseEmitter != none)
    {
        ShellCaseEmitter.Trigger(self, Instigator);
    }
}

// Modified to include magazines
function bool GiveInitialAmmo()
{
    local bool bSuppliedAmmo;

    bSuppliedAmmo = super.GiveInitialAmmo();

    if (NumPrimaryMags != default.NumPrimaryMags || NumSecondaryMags != default.NumSecondaryMags || NumTertiaryMags != default.NumTertiaryMags)
    {
        NumPrimaryMags = default.NumPrimaryMags;
        NumSecondaryMags = default.NumSecondaryMags;
        NumTertiaryMags = default.NumTertiaryMags;
        bSuppliedAmmo = true;
    }

    return bSuppliedAmmo;
}

// Modified to handle autocannon's multiple mag types
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (NumPrimaryMags < default.NumPrimaryMags)
    {
        ++NumPrimaryMags;
        bDidResupply = true;
    }

    if (NumSecondaryMags < default.NumSecondaryMags)
    {
        ++NumSecondaryMags;
        bDidResupply = true;
    }

    if (NumTertiaryMags < default.NumTertiaryMags)
    {
        ++NumTertiaryMags;
        bDidResupply = true;
    }

    // If cannon is waiting to reload & we have a player who doesn't use manual reloading (so must be out of ammo), then try to start a reload
    if (ReloadState == RL_Waiting && WeaponPawn != none && WeaponPawn.Occupied() && !PlayerUsesManualReloading() && bDidResupply)
    {
        AttemptReload();
    }

    return super.ResupplyAmmo();
}

// Modified to handle autocannon's multiple mag types
function ConsumeMag()
{
    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        NumPrimaryMags--;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        NumSecondaryMags--;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        NumTertiaryMags--;
    }
}

simulated function int PrimaryAmmoCount()
{
    local byte AmmoIndex;

    AmmoIndex = GetAmmoIndex();

    if (AmmoIndex < arraycount(MainAmmoChargeExtra))
    {
        switch (AmmoIndex)
        {
            case 0:
                return NumPrimaryMags;
            case 1:
                return NumSecondaryMags;
            case 2:
                return NumTertiaryMags;
        }
    }

    return 0;
}

// Modified to include an autocannon's multiple mag types
simulated function bool HasAmmoToReload(byte AmmoIndex)
{
    switch (AmmoIndex)
    {
        case 0:
            return NumPrimaryMags > 0;
        case 1:
            return NumSecondaryMags > 0;
        case 2:
            return NumTertiaryMags > 0;
        default:
            return super.HasAmmoToReload(AmmoIndex); // coaxial MG or smoke launcher
    }
}

defaultproperties
{
    bUsesMags=true
    Spread=0.003
    FlashEmitterClass=class'DH_Effects.DH20mmCannonFireEffect'
    EffectEmitterClass=none
    CannonDustEmitterClass=none
    AIInfo(0)=(RefireRate=0.99)

    // Sounds (HUDProportion overrides to better suit magazine reload)
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire01G'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire02G'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire03G'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_01')
    ReloadStages(1)=(Sound=Sound'DH_GerVehicleSounds2.Reloads.234_reload_02',HUDProportion=0.6)
    ReloadStages(2)=(Sound=Sound'DH_GerVehicleSounds2.Reloads.234_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_04',HUDProportion=0.4)

    // Screen shake
    ShakeRotMag=(Z=5.0)
    ShakeRotRate=(Z=100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=0.5)
    ShakeOffsetRate=(Z=10.0)
    ShakeOffsetTime=2.0
}
