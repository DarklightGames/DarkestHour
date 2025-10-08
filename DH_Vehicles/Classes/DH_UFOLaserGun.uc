//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOLaserGun extends DHVehicleMG;

//adding "coax MG" for "Primary MG", to have 2 types of attacks
var     name                AltFireAttachmentBone;   // optional bone to position coaxial MG projectiles & firing effects (defaults to WeaponFireAttachmentBone if not specified)
var     float               AltFireSpawnOffsetX;     // optional extra forward offset when spawning coaxial MG bullets, allowing them to clear potential collision with driver's head
var     EReloadState        AltReloadState;          // the stage of coaxial MG reload or readiness
var     array<ReloadStage>  AltReloadStages;         // stages for multi-part coaxial MG reload, including sounds, durations & HUD reload icon proportions
var     bool                bAltReloadPaused;        // a coaxial MG reload has started but was paused
var     bool                bNewOrResumedAltReload;  // tells Timer we're starting new coaxial MG reload or resuming paused reload, stopping it from advancing to next reload stage

// Smoke launcher  //not used atm
const   SMOKELAUNCHER_AMMO_INDEX = 4;                         // ammo index for smoke launcher fire
var     class<DHVehicleSmokeLauncher>   SmokeLauncherClass;   // class containing the properties of the smoke launcher
var     byte                NumSmokeLauncherRounds;           // no. of current smoke rounds
var     array<Vector>       SmokeLauncherFireOffset;          // positional offset(s) for spawning smoke projectiles - can be multiple for external launchers
var     byte                SmokeLauncherAdjustmentSetting;   // current setting for either the rotation or range setting of smoke launcher
var     EReloadState        SmokeLauncherReloadState;         // the stage of smoke launcher reload or readiness
var     bool                bSmokeLauncherReloadPaused;       // a smoke launcher reload has started but was paused, as no longer had a player in a valid reloading position
var     bool                bNewOrResumedSmokeLauncherReload; // tells Timer we're starting new smoke launcher reload or resuming paused reload, stopping it from advancing to next reload stage

// Modified so a cannon with smoke launcher with range adjustment sets its initial range setting to maximum
// Also to make sure we have an AltFireAttachmentBone for a coaxial MG
// If our mesh doesn't have a dedicated alt fire bone, we just use the WeaponFireAttachmentBone for the cannon & offset heavily from that (as before)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (SmokeLauncherClass != none && SmokeLauncherClass.static.CanAdjustRange())
    {
        SmokeLauncherAdjustmentSetting = SmokeLauncherClass.static.GetMaxRangeSetting();
        default.SmokeLauncherAdjustmentSetting = SmokeLauncherAdjustmentSetting; // avoids unnecessary replication of SmokeLauncherAdjustmentSetting for subsequently spawned vehicles

    }

    if (AltFireProjectileClass != none && AltFireAttachmentBone == '')
    {
        AltFireAttachmentBone = WeaponFireAttachmentBone;
    }

    // Enforce that the starting projectile class is the primary one
    // to eliminate the possibility that these are set differently.
    ProjectileClass = PrimaryProjectileClass;

    // New system for firing animations on the cannons, keeping the barrel isolated from any other animations
    // such as the commander's camera movements etc.
    if (ShootAnimBoneName != '')
    {
        AnimBlendParams(ShootAnimChannel, 1.0, 0.0, 0.0, ShootAnimBoneName);
    }
}
// Modified to handle multi-stage coaxial MG or smoke launcher reload in the same way as cannon
// Higher ranked weapon (cannon then coax then launcher) reload takes precedence over other weapon reload & puts that on hold
simulated function Timer()
{
    local Sound ReloadSound;

    // CANNON RELOAD
    if (ReloadState < RL_ReadyToFire && !bReloadPaused)
    {
        super.Timer(); // standard reload process for main weapon

        // If cannon just finished reloading & coaxial MG or smoke launcher isn't loaded, try to start/resume a reload
        // Note owning net client runs this independently from server & may resume a paused reload (but not start a new one)
        if (ReloadState >= RL_ReadyToFire)
        {
            OnMainGunReloadFinished();

            if (AltReloadState != RL_ReadyToFire)
            {
                AttemptAltReload();
            }

            if (SmokeLauncherReloadState != RL_ReadyToFire && AltReloadState >= RL_ReadyToFire)
            {
                AttemptSmokeLauncherReload();
            }
        }
        // Or if cannon is reloading, pause any active coaxial MG or smoke launcher reload as the cannon reload takes precedence
        else if (!bReloadPaused)
        {
            if (AltReloadState < RL_ReadyToFire && !bAltReloadPaused)
            {
                PauseAltReload();
            }

            if (SmokeLauncherReloadState < RL_ReadyToFire && !bSmokeLauncherReloadPaused)
            {
                PauseSmokeLauncherReload();
            }
        }

        return;
    }

    // If we don't have a player in a position to reload, pause any the coax MG or smoke launcher reload
    // Just a fallback & shouldn't happen, as reload gets actively paused if player exits or moves to position where he can't continue reloading
    if (WeaponPawn == none || !WeaponPawn.Occupied() || !WeaponPawn.CanReload())
    {
        PauseAltReload();
        PauseSmokeLauncherReload();

        return;
    }

    // COAXIAL MG RELOAD
    if (AltReloadState < RL_ReadyToFire && !bAltReloadPaused)
    {
        // If we're starting a new coax MG reload or resuming a paused reload, we just reset that flag & don't advance the reload state
        if (bNewOrResumedAltReload)
        {
            bNewOrResumedAltReload = false;
        }
        // Otherwise it means we've just we've completed a reload stage, so we progress to next reload state
        else
        {
            AltReloadState = EReloadState(AltReloadState + 1);
        }

        // If we just completed the final reload stage, complete the coax MG reload
        if (AltReloadState >= AltReloadStages.Length)
        {
            AltReloadState = RL_ReadyToFire;

            if (Role == ROLE_Authority)
            {
                AltAmmoCharge = InitialAltAmmo;
            }

            // If smoke launcher isn't loaded, try to start/resume a reload
            // Note owning net client runs this independently from server & may resume a paused reload (but not start a new one)
            if (SmokeLauncherReloadState != RL_ReadyToFire)
            {
                AttemptSmokeLauncherReload();
            }
        }
        // Otherwise play the reloading sound for the next stage & set the next timer
        else
        {
            ReloadSound = AltReloadStages[AltReloadState].Sound;

            if (ReloadSound != none)
            {
                PlayOwnedSound(ReloadSound, SLOT_Misc, 0.5,, 10.0,, true); // reduce sound volume to avoid hearing reload at long ranges
            }

            if (AltReloadStages[AltReloadState].Duration > 0.0) // use reload duration if specified, otherwise get the sound duration
            {
                SetTimer(AltReloadStages[AltReloadState].Duration, false);
            }
            else
            {
                SetTimer(FMax(0.1, GetSoundDuration(ReloadSound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
            }

            // Pause any active smoke launcher reload as the coax MG reload takes precedence
            if (SmokeLauncherReloadState < RL_ReadyToFire && !bSmokeLauncherReloadPaused)
            {
                PauseSmokeLauncherReload();
            }
        }

        return;
    }

    // SMOKE LAUNCHER RELOAD
    if (SmokeLauncherReloadState < RL_ReadyToFire && !bSmokeLauncherReloadPaused && SmokeLauncherClass != none && SmokeLauncherClass.default.bCanBeReloaded)
    {
        // If we're starting a new smoke launcher reload or resuming a paused reload, we just reset that flag & don't advance the reload state
        if (bNewOrResumedSmokeLauncherReload)
        {
            bNewOrResumedSmokeLauncherReload = false;
        }
        // Otherwise it means we've just we've completed a reload stage, so we progress to next reload state
        else
        {
            SmokeLauncherReloadState = EReloadState(SmokeLauncherReloadState + 1);
        }

        // If we just completed the final reload stage, complete the smoke launcher reload
        if (SmokeLauncherReloadState >= SmokeLauncherClass.default.ReloadStages.Length)
        {
            SmokeLauncherReloadState = RL_ReadyToFire;
        }
        // Otherwise play the reloading sound for the next stage & set the next timer
        else
        {
            ReloadSound = SmokeLauncherClass.static.GetReloadStageSound(SmokeLauncherReloadState);

            if (ReloadSound != none)
            {
                PlayOwnedSound(ReloadSound, SLOT_Misc, 2.0,, 25.0,, true);
            }

            if (SmokeLauncherClass.static.GetReloadStageDuration(SmokeLauncherReloadState) > 0.0)
            {
                SetTimer(SmokeLauncherClass.static.GetReloadStageDuration(SmokeLauncherReloadState), false);
            }
            else
            {
                SetTimer(FMax(0.1, GetSoundDuration(ReloadSound)), false);
            }
        }
    }
}
// Modified to handle any pitch adjustments for human players, & any secondary or tertiary projectile spread properties
function Rotator GetProjectileFireRotation(optional bool bAltFire)
{
    local Rotator FireRotation;
    local float   ProjectileSpread;

    FireRotation = WeaponFireRotation;

    // Get projectile spread, with handling for secondary & tertiary projectile spread properties
    if (bAltFire)
    {
        ProjectileSpread = AltFireSpread;
    }
    else if (!bDebugRangeManually && !bDebugRangeAutomatically)
    {
        if (ProjectileClass == SecondaryProjectileClass && SecondarySpread > 0.0)
        {
            ProjectileSpread = SecondarySpread;
        }
        else if (ProjectileClass == TertiaryProjectileClass && TertiarySpread > 0.0)
        {
            ProjectileSpread = TertiarySpread;
        }
        else
        {
            ProjectileSpread = Spread;
        }
    }

    // Return direction to fire projectile, including any random spread
    if (ProjectileSpread > 0.0)
    {
        FireRotation = Rotator(Vector(FireRotation) + (VRand() * FRand() * ProjectileSpread));
    }

    return FireRotation;
}
// Modified to only spawn AmbientEffectEmitter if cannon has a coaxial MG (as we now specify a generic AmbientEffectEmitterClass, so no longer sufficient to check that)
// And to use the new AltFireAttachmentBone to position the coax MG emitter
simulated function InitEffects()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (FlashEmitterClass != none && FlashEmitter == none && WeaponFireAttachmentBone != '') // a WeaponFireAttachmentBone is now required
        {
            FlashEmitter = Spawn(FlashEmitterClass);

            if (FlashEmitter != none)
            {
                FlashEmitter.SetDrawScale(DrawScale);
                AttachToBone(FlashEmitter, WeaponFireAttachmentBone);
                FlashEmitter.SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
            }
        }

        if (AltFireProjectileClass != none && AmbientEffectEmitterClass != none && AmbientEffectEmitter == none && AltFireAttachmentBone != '')
        {
            AmbientEffectEmitter = Spawn(AmbientEffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

            if (AmbientEffectEmitter != none)
            {
                AttachToBone(AmbientEffectEmitter, AltFireAttachmentBone);
                AmbientEffectEmitter.SetRelativeLocation(AltFireOffset);
            }
        }
    }
}


// Modified to add coaxial MG
simulated function bool ReadyToFire(bool bAltFire)
{
    if (bAltFire && bMultiStageReload && AltReloadState != RL_ReadyToFire)
    {
        return false;
    }

    return super.ReadyToFire(bAltFire);
}
// Implemented to start a coaxial MG reload or resume a previously paused reload, using a multi-stage reload process like a cannon
simulated function AttemptAltReload()
{
    local EReloadState OldReloadState;

    // Try to start a new reload, as coax either just ran out of ammo (still in ready to fire state) or is waiting
    if (AltReloadState == RL_ReadyToFire || AltReloadState == RL_Waiting)
    {
        if (Role == ROLE_Authority)
        {
            OldReloadState = AltReloadState; // so we can tell if AltReloadState changes

            // Start a reload if we have a spare mag & the cannon is not reloading (that takes precedence & makes coax wait to reload)
            if (HasAmmoToReload(ALTFIRE_AMMO_INDEX) && ReloadState >= RL_ReadyToFire && WeaponPawn != none && WeaponPawn.CanReload())
            {
                StartAltReload();
            }
            // Otherwise make sure loading state is waiting (for a player or an ammo resupply or for cannon to finish reloading)
            else if (AltReloadState != RL_Waiting)
            {
                AltReloadState = RL_Waiting;
                bAltReloadPaused = false; // just make sure this isn't set, as only relevant to a started reload
            }

            // Server replicates any changed reload state to net client
            if (AltReloadState != OldReloadState)
            {
                PassReloadStateToClient();
            }
        }
    }
    // Coax has started reloading so try to progress/resume it providing cannon is not reloading
    // Note we musn't check we have a player here as net client may not yet have received weapon pawn's Controller if reload is starting/resuming on entering vehicle
    // But generally we can assume we do have a player because either server has triggered this to start new reload (& it will have checked for player if necessary),
    // or player has just entered vehicle & triggered this (so even if we don't yet have the Controller, he's in the entering/possession process)
    // In any event the timer makes sure we have a player anyway & the slight delay before timer gets called should mean we have the Controller by then
    else if (ReloadState >= RL_ReadyToFire && WeaponPawn != none && WeaponPawn.CanReload())
    {
        StartAltReload(true);
    }
    else if (!bAltReloadPaused)
    {
        PauseAltReload();
    }
}
// New function to start a new coaxial MG reload or resume a paused reload
simulated function StartAltReload(optional bool bResumingPausedReload)
{
    if (!bResumingPausedReload)
    {
        NumMGMags--;
        AltReloadState = RL_ReloadingPart1;
    }

    bNewOrResumedAltReload = true; // stops Timer() from moving on to next stage
    bAltReloadPaused = false;
    SetTimer(0.1, false); // 0.1 sec delay instead of 0.01 to allow bit longer for net client to receive Controller actor, so check for player doesn't fail due to network delay
}
// New function to pause a coaxial MG reload
simulated function PauseAltReload()
{
    bAltReloadPaused = true;

    if (ReloadState >= RL_ReadyToFire || bReloadPaused)
    {
        SetTimer(0.0, false); // clear any timer, but only if cannon is not reloading (if so, must leave timer running for that)
    }
}
// Modified to include any coaxial MG or smoke launcher reload
simulated function PauseAnyReloads()
{
    super.PauseAnyReloads();

    if (bMultiStageReload)
    {
        if (AltReloadState < RL_ReadyToFire && !bAltReloadPaused)
        {
            PauseAltReload();
        }

        if (SmokeLauncherReloadState < RL_ReadyToFire && !bSmokeLauncherReloadPaused)
        {
            PauseSmokeLauncherReload();
        }
    }
}

// Modified to pack cannon, coaxial MG & smoke launcher reload states into a single byte, for efficient replication to owning net client
function PassReloadStateToClient()
{
    local byte PackedReloadState;

    if (WeaponPawn != none && !WeaponPawn.IsLocallyControlled()) // dedicated server or non-owning listen server
    {
        if (SmokeLauncherClass != none && SmokeLauncherClass.default.bCanBeReloaded)
        {
            PackedReloadState += SmokeLauncherReloadState * 36;
        }

        if (AltFireProjectileClass != none)
        {
            PackedReloadState += AltReloadState * 6;
        }

        PackedReloadState += ReloadState;

        ClientSetReloadState(PackedReloadState);
    }
}
// Modified to unpack combined cannon, coaxial MG & smoke launcher reload states from a single replicated byte & to handle a passed smoke launcher reload
simulated function ClientSetReloadState(byte NewState)
{
    if (Role < ROLE_Authority)
    {
        // Unpack smoke launcher reload state from replicated byte & update its reload status
        // Then adjust replicated byte to leave just the cannon & coax MG  status
        // Note we only do this if vehicle has a smoke launcher, otherwise just the cannon & coax reload states will have been passed
        //if (SmokeLauncherClass != none && SmokeLauncherClass.default.bCanBeReloaded)
        //{
        //    SmokeLauncherReloadState = EReloadState(NewState / 36);
        //    NewState -= SmokeLauncherReloadState * 36;
        //}

        // Unpack coaxial MG reload state (if vehicle has one) from replicated byte & update its reload status
        // Then adjust replicated byte to leave just the cannon status
        if (AltFireProjectileClass != none)
        {
            AltReloadState = EReloadState(NewState / 6);
            NewState -= AltReloadState * 6;
        }

        // Now call the Super to handle any cannon reload, passing the unpacked NewState for the cannon's reload state
        super.ClientSetReloadState(NewState);

        if (AltFireProjectileClass != none)
        {
            // Coax MG is mid-reload, so try to progress it
            if (AltReloadState < RL_ReadyToFire)
            {
                AttemptAltReload();
            }
            // Coax isn't reloading (it's either ready to fire or waiting to start a reload)
            // So just just make sure it isn't set to paused, which is only relevant if it's mid-reload
            else if (bAltReloadPaused)
            {
                bAltReloadPaused = false;
            }
        }

        if (SmokeLauncherClass != none && SmokeLauncherClass.default.bCanBeReloaded)
        {
            // Smoke launcher is mid-reload, so try to progress it
            if (SmokeLauncherReloadState < RL_ReadyToFire)
            {
                AttemptSmokeLauncherReload();
            }
            // Smoke launcher isn't reloading (it's either ready to fire or waiting to start a reload)
            // So just just make sure it isn't set to paused, which is only relevant if it's mid-reload
            else if (bSmokeLauncherReloadPaused)
            {
                bAltReloadPaused = false;
            }
        }
    }
}
// Modified to include a coaxial MG
simulated function bool HasAmmoToReload(byte AmmoIndex)
{
    if (AmmoIndex == ALTFIRE_AMMO_INDEX) // coaxial MG
    {
         return NumMGMags > 0;
    }

    return HasAmmo(AmmoIndex); // normal cannon or smoke launcher
}

// Implemented to handle cannon's manual reloading option
simulated function bool PlayerUsesManualReloading()
{
    return Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading;
}





defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_UFO_anm.UFO_turret_ext'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh

    // Movement
    YawBone="Turret"
    YawStartConstraint=-8000.000000
    YawEndConstraint=8000.000000
    PitchBone="Turret_placement2"
    PitchUpLimit=10000
    PitchDownLimit=35000
    GunnerAttachmentBone="com_attachment"
    bLimitYaw = true
    RotationsPerSecond=1
    MaxPositiveYaw=8500
    MaxNegativeYaw=-8500
    CustomPitchUpLimit=10000
    CustomPitchDownLimit=35000

    // Ammo
    ProjectileClass=Class'DH_UFOLaserBulletYellow'
    InitialPrimaryAmmo=50
    NumMGMags=1500
    FireInterval=0.03
    TracerProjectileClass=Class'DH_UFOLaserBulletRed' //this one is anti-armor
    TracerFrequency=3

    // Weapon fire
    Spread=20.0  //extreme spread
    WeaponFireAttachmentBone="Barrel"
    AmbientEffectEmitterClass=Class'VehicleMGEmitter'
    FireSoundClass=Sound'DH_UFO_snd.UFO.UfoLaser'
    FireEndSound=none
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)


    // Reload
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadStages(0)=(Sound=none,Duration=1.0) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=0)
    ReloadStages(2)=(Sound=none,Duration=0)
    ReloadStages(3)=(Sound=none,Duration=1.63)

    AltReloadState=RL_ReadyToFire
    AltReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden01',Duration=1.105) // MG34 reload sound acts as generic belt-fed coax MG reload
    AltReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden02',Duration=0,HUDProportion=0.75)
    AltReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden03',Duration=0,HUDProportion=0.5)
    AltReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden04',Duration=1.314,HUDProportion=0.25)

    bAmbientAltFireSound=True
    AltFireInterval=0.020000
    AltFireSoundClass=Sound'DH_UFO_snd.UFO.UfoFireAlt'
    AltFireEndSound=Sound'DH_UFO_snd.UFO.UfoFireAlt_End'
    AltFireProjectileClass=Class'DH_UFOLaserBulletBlue'
    InitialAltAmmo=40
    NumAltMags=1500
}
