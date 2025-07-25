//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleMG extends DHVehicleWeapon
    abstract;

var     bool    bMatchSkinToVehicle;  // option to automatically match MG skin zero to vehicle skin zero (e.g. for gunshield), avoiding need for separate MG pawn & MG classes
var     name    HUDOverlayReloadAnim; // reload animation to play if the MG uses a HUDOverlay

// Multiple barrels (used for compound weapons like the M45 Quadmount)
struct DHBarrel
{
    var     name                        MuzzleBone;             // bone name for this barrel
    var     WeaponAmbientEmitter        EffectEmitter;          // separate emitter for this barrel, for muzzle flash & ejected shell cases
    var     class<WeaponAmbientEmitter> EffectEmitterClass;     // class for the barrel firing effect emitters
};

var bool            bHasMultipleBarrels;
var byte            FiringBarrelIndex;        // barrel index that is due to fire next, so SpawnProjectile() can get location of barrel bone
var array<DHBarrel> Barrels;

// Modified to incrementally resupply MG mags (only resupplies spare mags; doesn't reload the MG)
function bool ResupplyAmmo()
{
    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval && NumMGMags < default.NumMGMags)
    {
        ++NumMGMags;

        // If MG is out of ammo & waiting to reload & we have a player, try to start a reload
        if (ReloadState == RL_Waiting && !HasAmmo(0) && WeaponPawn != none && WeaponPawn.Occupied())
        {
            AttemptReload();
        }

        LastResupplyTimestamp = Level.TimeSeconds;
        return true;
    }

    return false;
}

// Modified to give player a hint if he needs to unbutton to reload an externally mounted MG
simulated function AttemptReload()
{
    super.AttemptReload();

    if ((ReloadState == RL_Waiting || (bReloadPaused && ReloadState < RL_ReadyToFire)) && DHVehicleMGPawn(WeaponPawn) != none && WeaponPawn.IsLocallyControlled()
        && DHVehicleMGPawn(WeaponPawn).bMustUnbuttonToReload && !WeaponPawn.CanReload() && DHPlayer(WeaponPawn.Controller) != none)
    {
        DHPlayer(WeaponPawn.Controller).QueueHint(48, true);
    }
}

// Modified to play any HUD overlay reload animation, if necessary starting from the point where it was previously paused
simulated function StartReload(optional bool bResumingPausedReload)
{
    local float ReloadSecondsElapsed, TotalReloadDuration;
    local int   i;

    super.StartReload(bResumingPausedReload);

    // If weapon uses a HUD reload animation, play it
    if (WeaponPawn != none && WeaponPawn.HUDOverlay != none && WeaponPawn.HUDOverlay.HasAnim(HUDOverlayReloadAnim))
    {
        WeaponPawn.HUDOverlay.PlayAnim(HUDOverlayReloadAnim);

        // If we're resuming a paused reload that was part way through, move the animation to where it left off (add up previous stage durations)
        if (ReloadState > RL_ReloadingPart1)
        {
            for (i = 0; i < ReloadStages.Length; ++i)
            {
                if (i < ReloadState)
                {
                    ReloadSecondsElapsed += ReloadStages[i].Duration;
                }

                TotalReloadDuration += ReloadStages[i].Duration;
            }

            if (ReloadSecondsElapsed > 0.0)
            {
                WeaponPawn.HUDOverlay.SetAnimFrame(ReloadSecondsElapsed / TotalReloadDuration);
            }
        }
    }
}

// Modified to to stop any HUD reload animation
simulated function PauseReload()
{
    super.PauseReload();

    if (HUDOverlayReloadAnim != '' && WeaponPawn != none && WeaponPawn.HUDOverlay != none)
    {
        WeaponPawn.HUDOverlay.StopAnimating();
    }
}

// Modified to give net client player a hint if he needs to unbutton to start a new reload of an externally mounted MG
// Have to add this here as won't get this hint from AttemptReload() as client won't call that function if MG is waiting to start a reload
simulated function ClientSetReloadState(byte NewState)
{
    local DHPlayer PC;
    local bool bMustUnbuttonToReload;

    super.ClientSetReloadState(NewState);

    bMustUnbuttonToReload = DHVehicleMGPawn(WeaponPawn) != none && DHVehicleMGPawn(WeaponPawn).bMustUnbuttonToReload;

    if (ReloadState == RL_Waiting && bMustUnbuttonToReload && !WeaponPawn.CanReload())
    {
        PC = DHPlayer(WeaponPawn.Controller);

        if (PC != none)
        {
            PC.QueueHint(48, true);
        }
    }
}

// Modified to add option to automatically match MG skin to vehicle skin, e.g. for gunshield, avoiding need for separate MG pawn & MG classes just for camo variants
// Also to give Vehicle an 'MGun' reference to this actor
simulated function InitializeVehicleBase()
{
    if (DHVehicle(Base) != none)
    {
        DHVehicle(Base).MGun = self;
    }

    if (bMatchSkinToVehicle)
    {
        Skins[0] = Base.Skins[0];
    }

    super.InitializeVehicleBase();
}

// Modified to get the firing location for the barrel that is next to fire, if the MG has multiple barrels
function Vector GetProjectileFireLocation(class<Projectile> ProjClass)
{
    if (bHasMultipleBarrels && Barrels.Length > 0)
    {
        return GetBoneCoords(Barrels[FiringBarrelIndex].MuzzleBone).Origin + ((WeaponFireOffset * vect(1.0, 0.0, 0.0)) >> WeaponFireRotation);
    }
    
    return super.GetProjectileFireLocation(ProjClass);
}

// Modified to spawn & set up a separate BarrelEffectEmitter for each barrel
simulated function InitEffects()
{
    local int i;
    local WeaponAmbientEmitter Emitter;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    super.InitEffects();

    if (bHasMultipleBarrels)
    {
        for (i = 0; i < Barrels.Length; ++i)
        {
            if (Barrels[i].EffectEmitter == none && Barrels[i].EffectEmitterClass != none)
            {
                Emitter = Spawn(Barrels[i].EffectEmitterClass, self);

                if (Emitter == none)
                {
                    Warn("DHVehicleMG.InitEffects() - Failed to spawn BarrelEffectEmitter for barrel " $ string(i) $ " of " $ string(Barrels.Length) $ " barrels");
                    continue;
                }

                Barrels[i].EffectEmitter = Emitter;

                AttachToBone(Emitter, Barrels[i].MuzzleBone);

                Emitter.SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
            }
        }
    }
}

// Modified to handle multiple barrels firing
function Fire(Controller C)
{
    local int ShotsFired, TracerBarrelIndex;

    if (bHasMultipleBarrels)
    {
        // Work out which barrel (if any) is due to fire a tracer
        // With 4 barrels & 1 in 5 tracer loading, it effectively rotates through each barrel & skips a tracer every 5th volley
        ShotsFired = InitialPrimaryAmmo - PrimaryAmmoCount() - 1;
        TracerBarrelIndex = ShotsFired % TracerFrequency;

        // Spawn a projectile from each barrel
        for (FiringBarrelIndex = 0; FiringBarrelIndex < Barrels.Length; ++FiringBarrelIndex)
        {
            if (FiringBarrelIndex == TracerBarrelIndex) // spawn tracer bullet if this barrel is the one that's due to fire a tracer
            {
                SpawnProjectile(TracerProjectileClass, false);
            }
            else
            {
                SpawnProjectile(ProjectileClass, false);
            }

            bSkipFiringEffects = true; // so we don't repeat firing effects after the 1st projectile
        }

        bSkipFiringEffects = false; // reset
    }
    else
    {
        super.Fire(C);
    }
}

// Modified to destroy multiple barrel effect emitters.
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (Level.NetMode != NM_DedicatedServer)
    {
        DestroyBarrelEffects();
    }
}

simulated function DestroyBarrelEffects()
{
    local int i;

    for (i = 0; i < Barrels.Length; ++i)
    {
        if (Barrels[i].EffectEmitter != none)
        {
            Barrels[i].EffectEmitter.Destroy();
        }
    }
}

// Modified to pass damage on to vehicle base, same as a vehicle cannon
// TODO: should we just put this in the base class?
function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);

    if (Base != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            Base.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        Base.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

defaultproperties
{
    // Movement
    bInstantRotation=true
    RotationsPerSecond=0.25
    YawBone="mg_yaw"
    bLimitYaw=true
    PitchBone="mg_pitch"

    // Ammo & weapon fire
    bUsesMags=true
    Spread=0.002
    bUsesTracers=true
    WeaponFireAttachmentBone="mg_yaw"
    bDoOffsetTrace=true
    HudAltAmmoIcon=Texture'InterfaceArt_tex.mg42_ammo'
    AIInfo(0)=(bFireOnRelease=true,AimError=750.0,RefireRate=0.99)

    // Firing effects
    AmbientEffectEmitterClass=Class'TankMGEmitter'
    bAmbientFireSound=true
    AmbientSoundScaling=2.75
    FireForce="minifireb"
    bIsRepeatingFF=true

    // Reload (default is MG34 reload sounds as is used by most vehicles, even allies)
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden01',Duration=1.105)
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden02',Duration=2.413,HUDProportion=0.75)
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden03',Duration=1.843,HUDProportion=0.5)
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden04',Duration=1.314,HUDProportion=0.25)

    // Screen shake
    ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}
