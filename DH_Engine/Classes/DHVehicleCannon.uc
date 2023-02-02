//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleCannon extends DHVehicleWeapon
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DH_Vehicle_Reloads.uax

// Armor penetration
var     float               FrontArmorFactor, RightArmorFactor, LeftArmorFactor, RearArmorFactor;
var     float               FrontArmorSlope, RightArmorSlope, LeftArmorSlope, RearArmorSlope;
var     float               FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;
var     float               GunMantletArmorFactor;  // used for mantlet hits for casemate-style vehicles without a turret
var     float               GunMantletSlope;
var     bool                bHasAddedSideArmor;     // has side skirts that will make a hit by a HEAT projectile ineffective

// Cannon ammo (with variables for up to three cannon ammo types, including shot dispersion customized by round type)
var     byte                MainAmmoChargeExtra[3];  // current quantity of each round type (using byte for more efficient replication)
var     class<Projectile>   TertiaryProjectileClass; // new option for a 3rd type of cannon ammo
var localized array<string> ProjectileDescriptions;  // text for each round type to display on HUD
var localized array<string> nProjectileDescriptions; // "Native" or Technical name for projectile

var     int                 InitialTertiaryAmmo;     // starting load of tertiary round type
var     float               SecondarySpread;         // spread for secondary ammo type
var     float               TertiarySpread;
var     byte                LocalPendingAmmoIndex;   // next ammo type we want to load - a local version on net client or listen server, updated to ServerPendingAmmoIndex when needed
var     byte                ServerPendingAmmoIndex;  // on authority role this is authoritative setting for next ammo type to load; on client it records last setting updated to server
var     class<Projectile>   SavedProjectileClass;    // client & listen server record last ammo when in cannon, so if another player changes ammo, any local pending choice becomes invalid
var     int                 MaxPrimaryAmmo;          // max carrying capacity for this round type
var     int                 MaxSecondaryAmmo;
var     int                 MaxTertiaryAmmo;

// Firing effects
var     sound               CannonFireSound[3];      // sound of the cannon firing (selected randomly)
var     name                ShootLoweredAnim;        // firing animation if player is in a lowered or closed animation position, i.e. buttoned up or crouching
var     name                ShootIntermediateAnim;   // firing animation if player is in an intermediate animation position, i.e. between lowered/closed & raised/open positions
var     name                ShootRaisedAnim;         // firing animation if player is in a raised or open animation position, i.e. unbuttoned or standing
var     class<Emitter>      CannonDustEmitterClass;  // emitter class for dust kicked up by the cannon firing
var     Emitter             CannonDustEmitter;

// Coaxial MG
var     name                AltFireAttachmentBone;   // optional bone to position coaxial MG projectiles & firing effects (defaults to WeaponFireAttachmentBone if not specified)
var     float               AltFireSpawnOffsetX;     // optional extra forward offset when spawning coaxial MG bullets, allowing them to clear potential collision with driver's head
var     EReloadState        AltReloadState;          // the stage of coaxial MG reload or readiness
var     array<ReloadStage>  AltReloadStages;         // stages for multi-part coaxial MG reload, including sounds, durations & HUD reload icon proportions
var     bool                bAltReloadPaused;        // a coaxial MG reload has started but was paused
var     bool                bNewOrResumedAltReload;  // tells Timer we're starting new coaxial MG reload or resuming paused reload, stopping it from advancing to next reload stage

// Smoke launcher
const   SMOKELAUNCHER_AMMO_INDEX = 4;                         // ammo index for smoke launcher fire
var     class<DHVehicleSmokeLauncher>   SmokeLauncherClass;   // class containing the properties of the smoke launcher
var     byte                NumSmokeLauncherRounds;           // no. of current smoke rounds
var     array<vector>       SmokeLauncherFireOffset;          // positional offset(s) for spawning smoke projectiles - can be multiple for external launchers
var     byte                SmokeLauncherAdjustmentSetting;   // current setting for either the rotation or range setting of smoke launcher
var     EReloadState        SmokeLauncherReloadState;         // the stage of smoke launcher reload or readiness
var     bool                bSmokeLauncherReloadPaused;       // a smoke launcher reload has started but was paused, as no longer had a player in a valid reloading position
var     bool                bNewOrResumedSmokeLauncherReload; // tells Timer we're starting new smoke launcher reload or resuming paused reload, stopping it from advancing to next reload stage

// Aiming & movement
var     float               ManualRotationsPerSecond;  // turret/cannon rotation speed when turned by hand
var     float               PoweredRotationsPerSecond; // faster rotation speed with powered assistance (engine must be running)
var     array<int>          RangeSettings;             // for cannons with range adjustment
var     int                 AddedPitch;                // option for global adjustment to cannon's pitch aim

// Debugging & calibration
var     bool                bDebugPenetration;         // debug lines & text on screen, relating to turret hits & penetration calculations
var     bool                bLogDebugPenetration;      // similar debug log entries
var     bool                bDebugRangeManually;       // allows quick adjustment of added pitch at different range settings, using lean left/right keys
var     bool                bDebugRangeAutomatically;  // we are automatically calibrating pitch adjustment to hit a given range
var     int                 DebugPitchAdjustment;      // the current pitch adjustment setting being used by auto range calibration
var     int                 ClosestHighDebugPitch;     // pitch adjustments that have so far given closest shots above & below target during auto range calibration
var     int                 ClosestLowDebugPitch;
var     float               ClosestHighDebugHeight;    // height (in UU) above & below target from current closest recorded high & low shots during auto range calibration
var     float               ClosestLowDebugHeight;

// Gun wheels
enum ERotationType
{
    ROTATION_Yaw,
    ROTATION_Pitch
};

struct SGunWheel
{
    var ERotationType   RotationType;
    var name            BoneName;
    var float           Scale;
    var EAxis           RotationAxis;
};

var array<SGunWheel> GunWheels;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        MainAmmoChargeExtra, NumSmokeLauncherRounds, SmokeLauncherAdjustmentSetting;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerManualReload, ServerSetPendingAmmo, ServerFireSmokeLauncher, ServerAdjustSmokeLauncher;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********** ACTOR INITIALISATION & DESTRUCTION & KEY ENGINE EVENTS  ***********  //
///////////////////////////////////////////////////////////////////////////////////////

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
}

// Modified so client matches its pending ammo type to new ammo type received from server, avoiding need for server to separately replicate changed PendingAmmoIndex to client
// An ammo change means either a reload has started (so now ammo type is same as pending), or this actor just replicated to us & we're simply matching our initial values to current ammo,
// or another player has changed ammo since we were last in cannon (in which case any previous pending ammo we set is now redundant)
simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (ProjectileClass != SavedProjectileClass && ProjectileClass != none)
    {
        SavedProjectileClass = ProjectileClass;
        LocalPendingAmmoIndex = GetAmmoIndex();
        ServerPendingAmmoIndex = LocalPendingAmmoIndex; // this is a record of last setting updated to server, so match it up
    }
}

// Modified to handle multi-stage coaxial MG or smoke launcher reload in the same way as cannon
// Higher ranked weapon (cannon then coax then launcher) reload takes precedence over other weapon reload & puts that on hold
simulated function Timer()
{
    local sound ReloadSound;

    // CANNON RELOAD
    if (ReloadState < RL_ReadyToFire && !bReloadPaused)
    {
        super.Timer(); // standard reload process for main weapon

        // If cannon just finished reloading & coaxial MG or smoke launcher isn't loaded, try to start/resume a reload
        // Note owning net client runs this independently from server & may resume a paused reload (but not start a new one)
        if (ReloadState >= RL_ReadyToFire)
        {
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

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************** FIRING ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle canister shot
function Fire(Controller C)
{
    local int ProjectilesToFire, i;

    // Special handling for canister shot
    if (class<DHCannonShellCanister>(ProjectileClass) != none)
    {
        ProjectilesToFire = class<DHCannonShellCanister>(ProjectileClass).default.NumberOfProjectilesPerShot;

        for (i = 1; i <= ProjectilesToFire; ++i)
        {
            SpawnProjectile(ProjectileClass, false);
            bSkipFiringEffects = true; // so after the 1st projectile spawns, we don't repeat the firing effects
        }

        bSkipFiringEffects = false; // reset
    }
    else
    {
        super.Fire(C);
    }
}

// Modified so if we're using bDebugRangeManually mode, we draw any tracer as full size to make it easier to see (instead of its usual MaximumDrawScale reduction)
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile    P;
    local DHShellTracer Tracer;

    P = super.SpawnProjectile(ProjClass, bAltFire);

    if (bDebugRangeManually && !bAltFire && DHAntiVehicleProjectile(P) != none)
    {
        Tracer = DHShellTracer(DHAntiVehicleProjectile(P).Corona);

        if (Tracer != none && Tracer.MaximumDrawScale < 1.0)
        {
            Tracer.MaximumDrawScale = 1.0;
        }
    }

    return P;
}

// Modified to handle any pitch adjustments for human players, & any secondary or tertiary projectile spread properties
function rotator GetProjectileFireRotation(optional bool bAltFire)
{
    local rotator FireRotation;
    local float   ProjectileSpread;

    // Get base firing direction, including any pitch adjustments for human players
    FireRotation = WeaponFireRotation;

    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRotation.Pitch += AddedPitch; // aim/pitch adjustment affecting all ranges (allows correction of cannons with non-centred aim points)

        if (!bAltFire)
        {
            if (bDebugRangeAutomatically) // we're in the middle of an automatic debug option to calibrate pitch adjustment for range
            {
                FireRotation.Pitch += DebugPitchAdjustment;
            }
            else if (RangeSettings.Length > 0) // range-specific pitch adjustment for gunsights with mechanically adjusted range setting
            {
                FireRotation.Pitch += ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
            }
        }
    }

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
        FireRotation = rotator(vector(FireRotation) + (VRand() * FRand() * ProjectileSpread));
    }

    return FireRotation;
}

// Modified (from ROTankCannon) to remove call to UpdateTracer (now we spawn either normal bullet OR tracer when we fire), & also to expand & improve cannon firing anims
// Now check against RaisedPositionIndex instead of bExposed (allows lowered commander in open turret to be exposed), to play relevant firing animation
// Also adds new option for 'intermediate' position with its own firing animation, e.g. some AT guns have open sight position, between optics (lowered) & raised head position
// And we avoid playing shoot animations altogether on a server, as they serve no purpose there
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    local DHVehicleCannonPawn CannonPawn;

    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        ++FlashCount;
        NetUpdateTime = Level.TimeSeconds - 1.0; // force quick net update as changed value of FlashCount triggers this function for all non-owning net clients (native code)
    }
    else
    {
        CalcWeaponFire(bWasAltFire); // net client calculates & records fire location & rotation, used to spawn EffectEmitter
    }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire && !bDebugRangeManually && !bDebugRangeAutomatically)
    {
        if (FlashEmitter != none)
        {
            FlashEmitter.Trigger(self, Instigator);
        }

        if ((EffectEmitterClass != none|| CannonDustEmitterClass != none) && EffectIsRelevant(Location, false))
        {
            if (EffectEmitterClass != none)
            {
                EffectEmitter = Spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);
            }

            if (CannonDustEmitterClass != none && Base != none)
            {
                CannonDustEmitter = Spawn(CannonDustEmitterClass, self,, Base.Location, Base.Rotation);
            }
        }

        CannonPawn = DHVehicleCannonPawn(Instigator);

        if (CannonPawn != none && CannonPawn.DriverPositionIndex >= CannonPawn.RaisedPositionIndex) // check against RaisedPositionIndex instead of whether position is bExposed
        {
            if (HasAnim(ShootRaisedAnim))
            {
                PlayAnim(ShootRaisedAnim);
            }
        }
        else if (CannonPawn != none && CannonPawn.DriverPositionIndex == CannonPawn.IntermediatePositionIndex)
        {
            if (HasAnim(ShootIntermediateAnim))
            {
                PlayAnim(ShootIntermediateAnim);
            }
        }
        else if (HasAnim(ShootLoweredAnim))
        {
            PlayAnim(ShootLoweredAnim);
        }
    }
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

// Modified to use random cannon fire sounds
simulated function sound GetFireSound()
{
    return CannonFireSound[Rand(3)];
}

// Modified to remove shake from coaxial MGs
simulated function ShakeView(bool bWasAltFire)
{
    if (!bWasAltFire && !bDebugRangeManually && !bDebugRangeAutomatically)
    {
        super.ShakeView(false);
    }
}

// New function to attempt to fire the turret smoke launcher - called from the keybound Deploy function in cannon pawn class & clientside firing checks are done here
simulated function AttemptFireSmokeLauncher()
{
    if (SmokeLauncherClass != none)
    {
        if (SmokeLauncherReloadState == RL_ReadyToFire && HasAmmo(SMOKELAUNCHER_AMMO_INDEX))
        {
            ServerFireSmokeLauncher();
        }
        else if (SmokeLauncherReloadState >= RL_ReadyToFire || bSmokeLauncherReloadPaused)
        {
            PlaySound(Sound'Inf_Weapons_Foley.Misc.dryfire_rifle', SLOT_None, 1.5,, 25.0,, true); // dry fire click for empty smoke launcher, unless it is reloading
        }
    }
}

// New serverside function to fire the turret smoke launcher & start a reload
// In effect, this is a cross between a normal weapon's native AttemptFire() event & the SpawnProjectile() function, which are all serverside
function ServerFireSmokeLauncher()
{
    local Projectile Projectile;
    local vector     FireLocation;
    local rotator    VehicleRotation, FireRotation;
    local int        LauncherIndex, i;
    local bool       bSpawnedProjectile;

    if (SmokeLauncherClass == none || SmokeLauncherReloadState != RL_ReadyToFire || Role != ROLE_Authority)
    {
        return;
    }

    // Spawn the smoke projectile(s)
    for (i = 0; i < SmokeLauncherClass.default.ProjectilesPerFire && HasAmmo(SMOKELAUNCHER_AMMO_INDEX); ++i)
    {
        // Get the launch location (passes back the LauncherIndex & VehicleRotation to use to calculate firing rotation)
        FireLocation = GetSmokeLauncherFireLocation(LauncherIndex, VehicleRotation);

        // Get the launch rotation, including any current rotation adjustment if launcher can be rotated to aim it
        // Rotation starts relative to vehicle, then we convert to world rotation, with random spread
        FireRotation = SmokeLauncherClass.static.GetFireRotation(LauncherIndex);

        if (SmokeLauncherClass.static.CanRotate() && SmokeLauncherAdjustmentSetting > 0)
        {
            FireRotation.Yaw += float(SmokeLauncherAdjustmentSetting) / float(SmokeLauncherClass.default.NumRotationSettings) * 65536;
        }

        FireRotation = rotator((vector(FireRotation) >> VehicleRotation) + (VRand() * FRand() * SmokeLauncherClass.default.Spread));

        // Spawn the smoke projectile
        Projectile = Spawn(SmokeLauncherClass.default.ProjectileClass, none,, FireLocation, FireRotation);

        if (Projectile != none)
        {
            bSpawnedProjectile = true;

            // If launcher is range adjustable, decrease the projectile's launch speed if the range setting is less than maximum
            if (SmokeLauncherClass.static.CanAdjustRange() && SmokeLauncherAdjustmentSetting < SmokeLauncherClass.static.GetMaxRangeSetting())
            {
                Projectile.Velocity *= SmokeLauncherClass.static.GetLaunchSpeedModifier(SmokeLauncherAdjustmentSetting);
            }

            ConsumeAmmo(SMOKELAUNCHER_AMMO_INDEX);
        }
    }

    // Play fire sound (we only want to do this once even if we fired more than one projectile)
    // And if possible, attempt to start a smoke launcher reload
    if (bSpawnedProjectile)
    {
        PlaySound(SmokeLauncherClass.default.FireSound, SLOT_None, 1.0);

        if (SmokeLauncherClass.default.bCanBeReloaded)
        {
            AttemptSmokeLauncherReload();
        }
    }
}

// New function to calculate the firing location for a smoke launcher projectile
// Also used by the projectile to work out where to spawn the firing effect
// That's because the vehicle location can differ between server & net client, so client is better working out its own local location so effect looks right
simulated function vector GetSmokeLauncherFireLocation(optional out int LauncherIndex, optional out rotator VehicleRotation)
{
    // Get the world rotation of the turret, or the vehicle base (for vehicles without a turret)
    if (bHasTurret)
    {
        VehicleRotation = GetBoneRotation(YawBone);
    }
    else
    {
        VehicleRotation = Rotation;
    }

    // If external smoke launchers with multiple tubes, get the current tube index number
    // For a single internal launcher the index no. remains default zero
    if (SmokeLauncherClass.static.GetNumberOfLauncherTubes() > 1)
    {
        LauncherIndex = SmokeLauncherClass.static.GetNumberOfLauncherTubes() - NumSmokeLauncherRounds;
    }

    return Location + (SmokeLauncherFireOffset[LauncherIndex] >> VehicleRotation);
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** RANGE & OTHER SETTINGS  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified (from ROTankCannon) to network optimise by clientside check before replicating function call to server, & also playing click clientside, not replicating it back
// These functions now get called on both client & server, but only progress to server if it's a valid action (see modified LeanLeft & LeanRight execs in DHPlayer)
// Also adds debug options for easy tuning of gunsights in development mode
simulated function IncrementRange()
{
    // If bDebugRangeManually is enabled & gun not loaded, the range control buttons change the firing pitch adjustment to tune the range setting
    if (bDebugRangeManually)
    {
        if (ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
        {
            DebugModifyAddedPitch(1);

            return;
        }
    }
    // If bDebugSights is enabled & gun not loaded, the range control buttons adjust the centring of gunsight by changing cannon pawn's OverlayCorrectionX or Y
    else if (DHVehicleCannonPawn(WeaponPawn) != none && DHVehicleCannonPawn(WeaponPawn).bDebugSights
        && ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
    {
        DebugModifyOverlayCorrection(0.5);

        return;
    }

    // Normal range adjustment - first make sure it's a valid action
    if (CurrentRangeIndex < RangeSettings.Length - 1)
    {
        if (Role == ROLE_Authority)
        {
            CurrentRangeIndex++;
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            ROPlayer(Instigator.Controller).ServerLeanRight(true); // net client just calls the server function (after validity checks have been passed)
        }

        PlayClickSound();
    }
}

simulated function DecrementRange()
{
    if (bDebugRangeManually)
    {
        if (ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
        {
            DebugModifyAddedPitch(-1);

            return;
        }
    }
    else if (DHVehicleCannonPawn(WeaponPawn) != none && DHVehicleCannonPawn(WeaponPawn).bDebugSights
        && ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
    {
        DebugModifyOverlayCorrection(-0.5);

        return;
    }

    if (CurrentRangeIndex > 0)
    {
        if (Role == ROLE_Authority)
        {
            CurrentRangeIndex--;
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            ROPlayer(Instigator.Controller).ServerLeanLeft(true);
        }

        PlayClickSound();
    }
}

// Modified to return zero if there are no RangeSettings, e.g. for American cannons without adjustable sights
simulated function int GetRange()
{
    if (CurrentRangeIndex < RangeSettings.Length)
    {
        return RangeSettings[CurrentRangeIndex];
    }

    return 0;
}

// New clientside function to adjust either the rotation or range setting of smoke launcher
simulated function AdjustSmokeLauncher(bool bIncrease)
{
    local bool bValidAdjustment;

    if (SmokeLauncherClass == none)
    {
        return;
    }

    if (SmokeLauncherClass.static.CanRotate())
    {
        bValidAdjustment = true;
    }
    else if (SmokeLauncherClass.static.CanAdjustRange())
    {
        if (bIncrease)
        {
            bValidAdjustment = SmokeLauncherAdjustmentSetting < SmokeLauncherClass.static.GetMaxRangeSetting();
        }
        else
        {
            bValidAdjustment = SmokeLauncherAdjustmentSetting > 0;}
    }

    if (bValidAdjustment)
    {
        ServerAdjustSmokeLauncher(bIncrease);
        PlayClickSound();
    }
}

// New serverside function to adjust either the rotation or range setting of smoke launcher
function ServerAdjustSmokeLauncher(bool bIncrease)
{
    if (SmokeLauncherClass != none && Role == ROLE_Authority)
    {
        if (SmokeLauncherClass.static.CanRotate())
        {
            if (bIncrease)
            {
                if (SmokeLauncherAdjustmentSetting >= SmokeLauncherClass.default.NumRotationSettings - 1)
                {
                    SmokeLauncherAdjustmentSetting = 0;
                }
                else
                {
                    SmokeLauncherAdjustmentSetting++;
                }
            }
            else
            {
                if (SmokeLauncherAdjustmentSetting == 0)
                {
                    SmokeLauncherAdjustmentSetting = SmokeLauncherClass.default.NumRotationSettings - 1;
                }
                else if (SmokeLauncherAdjustmentSetting > 0)
                {
                    SmokeLauncherAdjustmentSetting--;
                }
            }
        }
        else if (SmokeLauncherClass.static.CanAdjustRange())
        {
            if (bIncrease)
            {
                if (SmokeLauncherAdjustmentSetting < SmokeLauncherClass.static.GetMaxRangeSetting())
                {
                    SmokeLauncherAdjustmentSetting++;
                }
            }
            else if (SmokeLauncherAdjustmentSetting > 0)
            {
                SmokeLauncherAdjustmentSetting--;
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************************* AMMO ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use extended ammo types
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo
        || AltAmmoCharge != InitialAltAmmo || NumMGMags != default.NumMGMags
        || (SmokeLauncherClass != none && NumSmokeLauncherRounds != SmokeLauncherClass.default.InitialAmmo))
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumMGMags = default.NumMGMags;

        if (SmokeLauncherClass != none)
        {
            NumSmokeLauncherRounds = SmokeLauncherClass.default.InitialAmmo;
        }

        return true;
    }

    return false;
}

// Modified to incrementally resupply all extended ammo types (only resupplies spare rounds & mags; doesn't reload the weapons)
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval)
    {
        if (!bUsesMags)
        {
            if (MainAmmoChargeExtra[0] < MaxPrimaryAmmo)
            {
                ++MainAmmoChargeExtra[0];
                bDidResupply = true;
            }

            if (MainAmmoChargeExtra[1] < MaxSecondaryAmmo)
            {
                ++MainAmmoChargeExtra[1];
                bDidResupply = true;
            }

            if (MainAmmoChargeExtra[2] < MaxTertiaryAmmo)
            {
                ++MainAmmoChargeExtra[2];
                bDidResupply = true;
            }

            // If cannon is waiting to reload & we have a player who doesn't use manual reloading (so must be out of ammo), then try to start a reload
            if (ReloadState == RL_Waiting && WeaponPawn != none && WeaponPawn.Occupied() && !PlayerUsesManualReloading() && bDidResupply)
            {
                AttemptReload();
            }
        }

        // Coaxial MG
        if (NumMGMags < default.NumMGMags)
        {
            ++NumMGMags;
            bDidResupply = true;

            // If coaxial MG is out of ammo & waiting to reload & we have a player, try to start a reload
            if (AltReloadState == RL_Waiting && !HasAmmo(ALTFIRE_AMMO_INDEX) && WeaponPawn != none && WeaponPawn.Occupied())
            {
                AttemptAltReload();
            }
        }

        // Smoke launcher
        if (SmokeLauncherClass != none && NumSmokeLauncherRounds < SmokeLauncherClass.default.InitialAmmo)
        {
            ++NumSmokeLauncherRounds;
            bDidResupply = true;

            // If smoke launcher is out of ammo & waiting to reload & we have a player, try to start a reload
            if (SmokeLauncherReloadState == RL_Waiting && WeaponPawn != none && WeaponPawn.Occupied())
            {
                AttemptSmokeLauncherReload();
            }
        }
    }

    if (bDidResupply)
    {
        LastResupplyTimestamp = Level.TimeSeconds;
    }

    return bDidResupply;
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

// New function to toggle pending ammo type (very different system from deprecated ROTankCannon)
// Only happens locally on net client & a changed ammo type is only passed to server on firing or manually reloading, & also plays a click sound (originally in SwitchFireMode)
simulated function ToggleRoundType()
{
    local int i;

    do
    {
        ++i;
        LocalPendingAmmoIndex = ++LocalPendingAmmoIndex % arraycount(MainAmmoChargeExtra); // cycles through ammo types 0/1/2 (loops back to 0 when reaches 3)

        // We have some of this pending ammo type, so lock that in & play a click
        // Note that if this is the 3rd loop it means we're back at the original ammo, so no switch was possible & no click is played
        if (i < arraycount(MainAmmoChargeExtra) && HasAmmoToReload(LocalPendingAmmoIndex))
        {
            PlayClickSound();
            break;
        }

    } until (i >= arraycount(MainAmmoChargeExtra))
}

// New function for net client to check whether it needs to update pending ammo type to server
// On a client, ServerPendingAmmoIndex is used to record the last setting updated to the server, so we know whether we need to update again
simulated function CheckUpdatePendingAmmo(optional bool bForceUpdate)
{
    if ((LocalPendingAmmoIndex != GetAmmoIndex() && LocalPendingAmmoIndex != ServerPendingAmmoIndex) || bForceUpdate)
    {
        ServerPendingAmmoIndex = LocalPendingAmmoIndex; // record latest setting sent to server
        ServerSetPendingAmmo(LocalPendingAmmoIndex);
    }
}

// New replicated client-to-server function to update server's pending ammo type, only passed when server needs it, i.e. to reload (usually after firing)
function ServerSetPendingAmmo(byte NewPendingAmmoIndex)
{
    ServerPendingAmmoIndex = NewPendingAmmoIndex;
}

// Modified to use extended ammo types
simulated function bool ConsumeAmmo(int AmmoIndex)
{
    if (AmmoIndex < 0 || AmmoIndex > SMOKELAUNCHER_AMMO_INDEX || !HasAmmo(AmmoIndex))
    {
        return false;
    }

    if (AmmoIndex == ALTFIRE_AMMO_INDEX)
    {
         AltAmmoCharge--;
    }
    else if (AmmoIndex == SMOKELAUNCHER_AMMO_INDEX)
    {
        NumSmokeLauncherRounds--;
    }
    else
    {
        MainAmmoChargeExtra[AmmoIndex]--;
    }

    return true;

}

// Modified to use extended ammo types
simulated function bool HasAmmo(int AmmoIndex)
{
    if (AmmoIndex == ALTFIRE_AMMO_INDEX)
    {
         return AltAmmoCharge > 0;
    }

    if (AmmoIndex == SMOKELAUNCHER_AMMO_INDEX)
    {
         return NumSmokeLauncherRounds > 0;
    }

    return AmmoIndex >= 0 && AmmoIndex < arraycount(MainAmmoChargeExtra) && MainAmmoChargeExtra[AmmoIndex] > 0;
}

// Modified to use extended ammo types
simulated function int PrimaryAmmoCount()
{
    local byte AmmoIndex;

    AmmoIndex = GetAmmoIndex();

    if (AmmoIndex < arraycount(MainAmmoChargeExtra))
    {
        return MainAmmoChargeExtra[AmmoIndex];
    }

    return 0;
}

// Modified to handle tertiary ammo type
simulated function byte GetAmmoIndex(optional bool bAltFire)
{
    if (ProjectileClass == TertiaryProjectileClass && !bAltFire)
    {
        return 2;
    }

    return super.GetAmmoIndex(bAltFire);
}

// Modified so bots use the cannon against vehicle targets & the coaxial MG against infantry targets (from ROTankCannon)
function byte BestMode()
{
    if (Instigator != none && Instigator.Controller != none && Vehicle(Instigator.Controller.Target) != none)
    {
        return 0;
    }

    return 2;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************************** RELOADING **********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New client-to-server replicated function allowing player to trigger a manual cannon reload
// Far simpler than version that was in ROTankCannon, as AttemptReload() is a generic function that handles what this function used to do
function ServerManualReload()
{
    if (ReloadState == RL_Waiting && PlayerUsesManualReloading())
    {
        AttemptReload();
    }
    else if (ReloadState == RL_ReadyToFire && ServerPendingAmmoIndex != GetAmmoIndex())
    {
        // Unload the currently loaded shell.
        AttemptReload();
    }
}

// Modified so before trying to start a new reload, we try to switch to any different ammo type selected by the player
// Or if we're out of the currently selected ammo, we try to automatically select a different type
simulated function AttemptReload()
{
    local int i;

    // Cannon needs to try to start a new reload & has a player to do it - authority role only
    // But first we must check whether we need to switch to a different ammo type
    if (Role == ROLE_Authority && (ReloadState == RL_ReadyToFire || ReloadState == RL_Waiting) && WeaponPawn != none && WeaponPawn.CanReload())
    {
        // Single player or owning listen server update the authoritative ServerPendingAmmoIndex from their local value before starting a reload
        if (Instigator != none && Instigator.IsLocallyControlled())
        {
            ServerPendingAmmoIndex = LocalPendingAmmoIndex;
        }

        // If we don't have any ammo of the pending type, try to automatically switch to another ammo type (unless player reloads & switches manually)
        // Note if server changes ammo, client's pending type gets matched in PostNetReceive() on receiving new ProjectileClass, so no need to replicate pending ammo directly
        if (!HasAmmoToReload(ServerPendingAmmoIndex) && !PlayerUsesManualReloading())
        {
            for (i = 0; i < 3; ++i)
            {
                if (HasAmmoToReload(i))
                {
                    ServerPendingAmmoIndex = i;

                    if (Instigator != none && Instigator.IsLocallyControlled())
                    {
                        LocalPendingAmmoIndex = i; // single player or owning listen server also match their local setting
                    }

                    break;
                }
            }
        }

        // If pending ammo type is different, switch to it now
        if (ServerPendingAmmoIndex != GetAmmoIndex())
        {
            switch (ServerPendingAmmoIndex)
            {
                case 0:
                    ProjectileClass = PrimaryProjectileClass;
                    break;
                case 1:
                    ProjectileClass = SecondaryProjectileClass;
                    break;
                case 2:
                    ProjectileClass = TertiaryProjectileClass;
                    break;
            }
        }
    }

    super.AttemptReload(); // now we've done that it's the usual attempt reload process
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

// New function to start a smoke launcher reload or resume a previously paused reload, using a multi-stage reload process like a cannon
simulated function AttemptSmokeLauncherReload()
{
    local EReloadState OldReloadState;

    if (SmokeLauncherClass == none || !SmokeLauncherClass.default.bCanBeReloaded)
    {
        return;
    }

    // Try to start a new reload, as smoke launcher either just fired (still in ready to fire state) or is waiting
    if (SmokeLauncherReloadState == RL_ReadyToFire || SmokeLauncherReloadState == RL_Waiting)
    {
        if (Role == ROLE_Authority)
        {
            OldReloadState = SmokeLauncherReloadState; // so we can tell if SmokeLauncherReloadState changes

            // Start a reload if we have spare ammo & the cannon & coaxial MG aren't reloading (they takes precedence & makes smoke launcher wait to reload)
            if (HasAmmoToReload(SMOKELAUNCHER_AMMO_INDEX) && ReloadState >= RL_ReadyToFire && AltReloadState >= RL_ReadyToFire && WeaponPawn != none && WeaponPawn.CanReload())
            {
                StartSmokeLauncherReload();
            }
            // Otherwise make sure loading state is waiting (for a player or an ammo resupply or for cannon or coax MG to finish reloading)
            else if (SmokeLauncherReloadState != RL_Waiting)
            {
                SmokeLauncherReloadState = RL_Waiting;
                bSmokeLauncherReloadPaused = false; // just make sure this isn't set, as only relevant to a started reload
            }

            // Server replicates any changed reload state to net client
            if (SmokeLauncherReloadState != OldReloadState)
            {
                PassReloadStateToClient();
            }
        }
    }
    // Smoke launcher has started reloading so try to progress/resume it providing cannon or coax MG is not reloading
    // Note we musn't check we have a player here as net client may not yet have received weapon pawn's Controller if reload is starting/resuming on entering vehicle
    // But generally we can assume we do have a player because either server has triggered this to start new reload (& it will have checked for player if necessary),
    // or player has just entered vehicle & triggered this (so even if we don't yet have the Controller, he's in the entering/possession process)
    // In any event the timer makes sure we have a player anyway & the slight delay before timer gets called should mean we have the Controller by then
    else if (ReloadState >= RL_ReadyToFire && AltReloadState >= RL_ReadyToFire && WeaponPawn != none && WeaponPawn.CanReload())
    {
        StartSmokeLauncherReload(true);
    }
    else if (!bSmokeLauncherReloadPaused)
    {
        PauseSmokeLauncherReload();
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

// New function to start a new smoke launcher reload or resume a paused reload
simulated function StartSmokeLauncherReload(optional bool bResumingPausedReload)
{
    if (!bResumingPausedReload)
    {
        SmokeLauncherReloadState = RL_ReloadingPart1;
    }

    bNewOrResumedSmokeLauncherReload = true; // stops Timer() from moving on to next stage
    bSmokeLauncherReloadPaused = false;
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

// New function to pause a smoke launcher reload
simulated function PauseSmokeLauncherReload()
{
    bSmokeLauncherReloadPaused = true;

    if ((ReloadState >= RL_ReadyToFire || bReloadPaused) && (AltReloadState >= RL_ReadyToFire || bAltReloadPaused))
    {
        SetTimer(0.0, false); // clear any timer, but only if cannon & coaxial MG are not reloading (if so, must leave timer running for that)
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
        if (SmokeLauncherClass != none && SmokeLauncherClass.default.bCanBeReloaded)
        {
            SmokeLauncherReloadState = EReloadState(NewState / 36);
            NewState -= SmokeLauncherReloadState * 36;
        }

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

// Modified for main reloading sound
simulated function PlayStageReloadSound()
{
    PlayOwnedSound(ReloadStages[ReloadState].Sound, SLOT_Misc, 0.5,, 10.0,, false); // reduce sound volume to avoid hearing reload at long ranges
}

// Modified to use extended ammo types
function FinishMagReload()
{
    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
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

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************  PENETRATION & DAMAGE  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New generic function to handle turret penetration calcs for any shell type
// Based on same function in DHArmoredVehicle, but some adjustments for turret, especially the need to factor in turret's independent traverse
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration)
{
    local DHArmoredVehicle AV;
    local vector  HitLocationRelativeOffset, HitSideAxis, ArmorNormal, X, Y, Z;
    local rotator TurretRelativeRotation, TurretNonRelativeRotation, ArmourSlopeRotator;
    local float   HitLocationAngle, AngleOfIncidence, ArmorThickness, ArmorSlope, ShatterChance;
    local float   OverMatchFactor, SlopeMultiplier, EffectiveArmorThickness, PenetrationRatio;
    local string  HitSide, OppositeSide, DebugString1, DebugString2, DebugString3;
    local bool    bProjectilePenetrated;

    AV = DHArmoredVehicle(Base);
    ProjectileDirection = Normal(ProjectileDirection); // should be passed as a normal but we need to be certain

    // Calculate the angle direction of hit relative to turret's facing direction, so we can work out out which side was hit (a 'top down 2D' angle calc)
    // Start by calculating the world rotation of the turret (ignoring any gun pitch as that isn't relevant to turret's rotation)
    // Then use that to get the offset of HitLocation from turret's centre, relative to turret's facing direction
    // Then convert to a rotator &, because it's relative, we can simply use the yaw element to give us the angle direction of hit, relative to turret
    // Must ignore relative height of hit (represented now by rotator's pitch) as isn't a factor in 'top down 2D' calc & would sometimes actually distort result
    if (bHasTurret)
    {
        TurretRelativeRotation.Yaw = CurrentAim.Yaw;
        TurretNonRelativeRotation = rotator(vector(TurretRelativeRotation) >> Rotation);
        GetAxes(TurretNonRelativeRotation, X, Y, Z);
        HitLocationRelativeOffset = (HitLocation - Location) << TurretNonRelativeRotation;
        HitLocationAngle = class'UUnits'.static.UnrealToDegrees(rotator(HitLocationRelativeOffset).Yaw);

        if (HitLocationAngle < 0.0)
        {
            HitLocationAngle += 360.0; // convert negative angles to 180 to 360 degree format
        }
    }

    // Assign settings based on which side we hit
    if (!bHasTurret)
    {
        HitSide = "mantlet"; // if vehicle has no turret we must have hit collision representing a gun mantlet or similar, so return penetration based on mantlet armor properties
    }
    else if (HitLocationAngle >= FrontLeftAngle || HitLocationAngle < FrontRightAngle) // frontal hit
    {
        HitSide = "front";
        OppositeSide = "rear";
        HitSideAxis = X;
    }
    else if (HitLocationAngle >= FrontRightAngle && HitLocationAngle < RearRightAngle) // right side hit
    {
        HitSide = "right";
        OppositeSide = "left";
        HitSideAxis = Y;
    }
    else if (HitLocationAngle >= RearRightAngle && HitLocationAngle < RearLeftAngle) // rear hit
    {
        HitSide = "rear";
        OppositeSide = "front";
        HitSideAxis = -X;
    }
    else if (HitLocationAngle >= RearLeftAngle && HitLocationAngle < FrontLeftAngle) // left side hit
    {
        HitSide = "left";
        OppositeSide = "right";
        HitSideAxis = -Y;
    }
    else // didn't hit any side !! (angles must be screwed up, so fix those)
    {
        Log("ERROR: turret angles not set up correctly for" @ Tag @ "(took hit from" @ HitLocationAngle @ "degrees & couldn't resolve which side that was");

        if ((bDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode()) && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "ERROR: turret angles not set up correctly for" @ Tag @ "(took hit from" @ HitLocationAngle @ "degrees & couldn't resolve which side that was");
        }

        if (AV != none)
        {
            AV.ResetTakeDamageVariables();
        }

        return false;
    }

    // Check for 'hit bug', where a projectile may pass through the 1st face of vehicle's collision & be detected as a hit on the opposite side (on the way out)
    // Calculate incoming angle of the shot, relative to perpendicular from the side we think we hit (ignoring armor slope for now; just a reality check on calculated side)
    // If the angle is too high it's impossible, so we do a crude fix by switching the hit to the opposite
    // Angle of over 90 degrees is theoretically impossible, but in reality vehicles aren't regular shaped boxes & it is possible for legitimate hits a bit over 90 degrees
    // So have softened the threshold to 120 degrees, which should still catch genuine hit bugs
    // Also modified to skip this check for deflected shots, which can ricochet onto another part of the vehicle at weird angles
    if (P.NumDeflections == 0 && bHasTurret)
    {
        AngleOfIncidence = class'UUnits'.static.RadiansToDegrees(Acos(-ProjectileDirection dot HitSideAxis));

        if (AngleOfIncidence > 120.0)
        {
            if ((bDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode()) && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit detection bug - switching from" @ HitSide @ "to" @ OppositeSide
                    @ "as angle of incidence to original side was" @ int(Round(AngleOfIncidence)) @ "degrees");
            }

            if (bLogDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode())
            {
                Log("Hit detection bug - switching from" @ HitSide @ "to" @ OppositeSide
                    @ "as angle of incidence to original side was" @ int(Round(AngleOfIncidence)) @ "degrees");
            }

            HitSide = OppositeSide;
            HitSideAxis = -HitSideAxis;
        }
    }

    // Now set the relevant armour properties to use, based on which side we hit
    if (HitSide == "mantlet")
    {
        ArmorThickness = GunMantletArmorFactor;
    }
    else if (HitSide ~= "front")
    {
        ArmorThickness = FrontArmorFactor;
        ArmorSlope = FrontArmorSlope;
    }
    else if (HitSide ~= "rear")
    {
        ArmorThickness = RearArmorFactor;
        ArmorSlope = RearArmorSlope;
    }
    else if (HitSide ~= "right" || HitSide ~= "left")
    {
        // No penetration if vehicle has extra side armor that stops HEAT projectiles, so exit here (after any debug options)
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT)
        {
            if (bDebugPenetration && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit turret" @ HitSide $ ": no penetration as extra side armor stops HEAT projectiles");
            }

            if (bLogDebugPenetration)
            {
                Log("Hit turret" @ HitSide $ ": no penetration as extra side armor stops HEAT projectiles");
            }

            if (AV != none)
            {
                AV.ResetTakeDamageVariables();
            }

            return false;
        }

        if (HitSide ~= "right")
        {
            ArmorThickness = RightArmorFactor;
            ArmorSlope = RightArmorSlope;
        }
        else
        {
            ArmorThickness = LeftArmorFactor;
            ArmorSlope = LeftArmorSlope;
        }
    }

    // Calculate the effective armor thickness, factoring in projectile's angle of incidence, & compare to projectile's penetration capability
    // We can skip these calcs if MaxArmorPenetration doesn't exceed ArmorThickness, because that means we can't ever penetrate
    // But if a debug option is enabled, we'll do the calcs as they get used in the debug
    if (MaxArmorPenetration > ArmorThickness || ((bDebugPenetration || bLogDebugPenetration) && P.NumDeflections == 0))
    {
        // Calculate the projectile's angle of incidence to the actual armor slope
        // Apply armor slope to HitSideAxis to get an ArmorNormal (a normal from the sloping face of the armor), then calculate an AOI relative to that
        if (bHasTurret)
        {
            ArmourSlopeRotator.Pitch = class'UUnits'.static.DegreesToUnreal(ArmorSlope);
            ArmorNormal = Normal(vector(ArmourSlopeRotator) >> rotator(HitSideAxis));
            AngleOfIncidence = class'UUnits'.static.RadiansToDegrees(Acos(-ProjectileDirection dot ArmorNormal));
        }
        else
        {
            AngleOfIncidence = GunMantletSlope;
        }

        // Get the armor's slope multiplier to calculate effective armor thickness
        OverMatchFactor = ArmorThickness / P.ShellDiameter;
        SlopeMultiplier = class'DHArmoredVehicle'.static.GetArmorSlopeMultiplier(P, AngleOfIncidence, OverMatchFactor);
        EffectiveArmorThickness = ArmorThickness * SlopeMultiplier;

        // Get the penetration ratio (penetration capability vs effective thickness)
        PenetrationRatio = MaxArmorPenetration / EffectiveArmorThickness;
    }

    // Check & record whether or not we penetrated the vehicle (including check if shattered on the armor)
    P.bRoundShattered = P.bShatterProne && PenetrationRatio >= 1.0 && class'DHArmoredVehicle'.static.CheckIfShatters(P, PenetrationRatio, OverMatchFactor, ShatterChance);
    bProjectilePenetrated = PenetrationRatio >= 1.0 && !P.bRoundShattered;

    // Set variables on the vehicle itself that are used in its TakeDamage()
    if (AV != none)
    {
        AV.bProjectilePenetrated = bProjectilePenetrated;
        AV.bTurretPenetration = bProjectilePenetrated;
        AV.bHEATPenetration = P.RoundType == RT_HEAT && bProjectilePenetrated;
        AV.bRearHullPenetration = false;
    }

    // Debugging options
    if ((bLogDebugPenetration || bDebugPenetration) && P.NumDeflections == 0)
    {
        DebugString1 = Caps("Hit turret" @ HitSide) $ ": penetrated =" @ Locs(bProjectilePenetrated && !P.bRoundShattered) $ ", hit location angle ="
            @ int(Round(HitLocationAngle)) @ "deg, armor =" @ int(Round(ArmorThickness * 10.0)) $ "mm @" @ int(Round(ArmorSlope)) @ "deg";

        DebugString2 = "Shot penetration =" @ int(Round(MaxArmorPenetration * 10.0)) $ "mm, effective armor =" @ int(Round(EffectiveArmorThickness * 10.0))
            $ "mm, shot AOI =" @ int(Round(AngleOfIncidence)) @ "deg, armor slope multiplier =" @ SlopeMultiplier;

        DebugString3 = "Penetration radio =" @ PenetrationRatio $ ", shatter chance =" @ (ShatterChance * 100) $ "%, shattered =" @ Locs(P.bRoundShattered);

        if (bLogDebugPenetration)
        {
            Log(DebugString1);
            Log(DebugString2);
            Log(DebugString3);
            Log("------------------------------------------------------------------------------------------------------");
        }

        if (bDebugPenetration)
        {
            if (Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, DebugString1);
                Level.Game.Broadcast(self, DebugString2);
                Level.Game.Broadcast(self, DebugString3);
            }

            if (Level.NetMode != NM_DedicatedServer)
            {
                ClearStayingDebugLines();
                DrawStayingDebugLine(HitLocation, HitLocation + (600.0 * ArmorNormal), 0, 0, 255); // blue line for ArmorNormal

                if (bProjectilePenetrated)
                {
                    DrawStayingDebugLine(HitLocation, HitLocation + (2000.0 * -ProjectileDirection), 0, 255, 0); // green line for penetration
                }
                else
                {
                    DrawStayingDebugLine(HitLocation, HitLocation + (2000.0 * -ProjectileDirection), 255, 0, 0); // red line if failed to penetrate
                }
            }
        }
    }

    // Finally return whether or not we penetrated the vehicle turret
    return bProjectilePenetrated;
}

// Modified as shell's ProcessTouch() now calls TakeDamage() on VehicleWeapon instead of directly on vehicle itself
// But for a cannon it's counted as a vehicle hit, so we call TD() on the vehicle (can also be subclassed for any custom handling of cannon hits)
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (Base != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            Base.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        Base.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to call StaticPrecache() on any smoke launcher class
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.SmokeLauncherClass != none)
    {
        default.SmokeLauncherClass.static.StaticPrecache(L);
    }
}

// Modified to add TertiaryProjectileClass
simulated function UpdatePrecacheStaticMeshes()
{
    super.UpdatePrecacheStaticMeshes();

    if (TertiaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    }
}

// Modified to add option to skin cannon mesh using CannonSkins array in Vehicle class (avoiding need for separate cannon pawn & cannon classes just for camo variants)
// Also to give Vehicle a 'Cannon' reference to this actor
simulated function InitializeVehicleBase()
{
    local DHVehicle V;
    local int       i;

    V = DHVehicle(Base);

    if (V != none)
    {
        V.Cannon = self;

        if (Level.NetMode != NM_DedicatedServer)
        {
            for (i = 0; i < V.CannonSkins.Length; ++i)
            {
                if (V.CannonSkins[i] != none)
                {
                    Skins[i] = V.CannonSkins[i];
                }
            }
        }
    }

    super.InitializeVehicleBase();
}

// Modified to use the new optional AltFireSpawnOffsetX for coaxial MG fire, instead of irrelevant WeaponFireOffset for cannon
// And to use the new AltFireAttachmentBone to get the location for coax MG fire
// Generally re-factored a little & removed redundant dual fire stuff
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local name   WeaponFireAttachBone;
    local vector CurrentFireOffset;

    // Get attachment bone & positional offset
    if (bWasAltFire)
    {
        WeaponFireAttachBone = AltFireAttachmentBone;
        CurrentFireOffset = AltFireOffset;
        CurrentFireOffset.X += AltFireSpawnOffsetX;
    }
    else
    {
        WeaponFireAttachBone = WeaponFireAttachmentBone;
        CurrentFireOffset.X = WeaponFireOffset;
    }

    // Calculate the world location & rotation to spawn a projectile
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);
    WeaponFireLocation = GetBoneCoords(WeaponFireAttachBone).Origin;

    if (CurrentFireOffset != vect(0.0, 0.0, 0.0)) // apply any positional offset
    {
        WeaponFireLocation += CurrentFireOffset >> WeaponFireRotation;
    }
}

// Modified to add CannonDustEmitter (from ROTankCannon) & any debug target wall
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (CannonDustEmitter != none)
    {
        CannonDustEmitter.Destroy();
    }

    if (bDebugRangeAutomatically)
    {
        DestroyDebugTargetWall();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***********************************  DEBUG  ***********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New debug function to change the cannon's pitch adjustment for the current, with screen display
function DebugModifyAddedPitch(int PitchAdjustment)
{
    local class<DHCannonShell> ShellClass;
    local int                  i;

    // Authority role modified the current pitch setting
    // Also reverts to full ammo as this is a debug mode & we may need to fire lots of rounds
    if (Role == ROLE_Authority)
    {
        GiveInitialAmmo();

        ShellClass = class<DHCannonShell>(ProjectileClass);

        // For cannons with mechanic range adjustment
        if (ShellClass != none && ShellClass.default.bMechanicalAiming)
        {
            for (i = 0; i < ShellClass.default.MechanicalRanges.Length; ++i)
            {
                if (ShellClass.default.MechanicalRanges[i].Range >= RangeSettings[CurrentRangeIndex])
                {
                    ShellClass.default.MechanicalRanges[i].RangeValue += PitchAdjustment;

                    Instigator.ClientMessage("New added pitch for range" @ RangeSettings[CurrentRangeIndex] @ DHVehicleCannonPawn(Instigator).RangeText
                        @ "(MechanicalRanges[" $ i $ "]) =" @ ShellClass.default.MechanicalRanges[i].RangeValue);

                    break;
                }
            }
        }
        // For cannons without any mechanical range adjustment, which only use the global AddedPitch aim correction, affecting all ranges
        else
        {
            AddedPitch += PitchAdjustment;
            Instigator.ClientMessage("New AddedPitch (all ranges) =" @ AddedPitch @ "    Original value =" @ default.AddedPitch @ "    Adjustment =" @ AddedPitch - default.AddedPitch);
        }
    }
    // Net client just passes the call up to the server
    else if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        if (PitchAdjustment > 0.0)
        {
            ROPlayer(Instigator.Controller).ServerLeanRight(true);
        }
        else
        {
            ROPlayer(Instigator.Controller).ServerLeanLeft(true);
        }
    }
}

// New debug function to begin automatically calibrating the range setting for the current range
function BeginAutoDebugRange()
{
    local DHDecoAttachment TargetWall;
    local vector           ViewLocation, WallLocation;
    local rotator          AimRotation, WallRotation;
    local float            RangeUU;

    if (class<DHCannonShell>(ProjectileClass) == none || !class<DHCannonShell>(ProjectileClass).default.bMechanicalAiming || WeaponPawn == none)
    {
        return;
    }

    // Calculate the target range in UU
    if (WeaponPawn.IsA('DHVehicleCannonPawn') && DHVehicleCannonPawn(WeaponPawn).RangeText ~= "metres")
    {
        RangeUU = class'DHUnits'.static.MetersToUnreal(Max(GetRange(), 10));
    }
    else
    {
        RangeUU = Max(GetRange(), 10) * 55.18654;
    }

    // Calculate required position for target wall & spawn it
    // We calculate our gunsight view position & aim exactly as it's done for our gunsight view (in cannon pawn's SpecialCalcFirstPersonView())
    AimRotation = GetBoneRotation(WeaponPawn.CameraBone);
    ViewLocation = GetBoneCoords(WeaponPawn.CameraBone).Origin + (WeaponPawn.DriverPositions[0].ViewLocation >> AimRotation);
    WallLocation = ViewLocation + (RangeUU * vector(AimRotation)) + (vect(0.0, -100000.0, 0.0) >> AimRotation);
    WallRotation = AimRotation;
    WallRotation.Yaw += 16384;
    TargetWall = Spawn(class'DHDecoAttachment',, 'DebugTargetWall', WallLocation, WallRotation);

    if (TargetWall != none)
    {
        // Set up appearance & collision properties for target wall
        TargetWall.SetStaticMesh(StaticMesh(DynamicLoadObject("DH_DebugTools.Misc.DebugPlaneAttachment", class'StaticMesh')));
        TargetWall.bOnlyDrawIfAttached = false;
        TargetWall.SetCollision(true, true);
        TargetWall.KSetBlockKarma(true);
        TargetWall.bWorldGeometry = true;
        TargetWall.SetCollisionSize(1.0, 1.0);
        TargetWall.SetDrawScale(10000.0);

        // Initialise the debug variables
        bDebugRangeAutomatically = true;
        DebugPitchAdjustment = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
        ClosestHighDebugHeight = 0.0;
        ClosestHighDebugPitch = 0;
        ClosestLowDebugHeight = 0.0;
        ClosestLowDebugPitch = 0;

        // Spawn the first debug shell
        CalcWeaponFire(false);
        SpawnProjectile(ProjectileClass, false);
    }
}

// New debug function used when automatically calibrating the range setting
// Called by the projectile when it hits the target wall, passing us the hit location, which we then use to adjust aim pitch & fire again
// We vertically bracket the ideal hit location with shots until we've recorded shots within 1 pitch unit of each other, then the closest is best result
function UpdateAutoDebugRange(Actor HitActor, vector HitLocation)
{
    local vector  ViewLocation, IdealHitLocation, HitNormal;
    local rotator AimRotation;
    local float   HitHeightAboveIdeal, DistanceSpread;
    local int     PitchSpread, FinalPitchAdjustment;
    local string  MessageText;

    if (bDebugRangeAutomatically && WeaponPawn != none)
    {
        // Our debug projectile hit the target wall
        if (HitActor != none && HitActor.Tag == 'DebugTargetWall')
        {
            // Trace our line of sight to get an ideal hit location on the target wall, then work out our projectile's hit height relative to that
            // We calculate our gunsight view position & aim exactly as it's done for our gunsight view (in cannon pawn's SpecialCalcFirstPersonView())
            AimRotation = GetBoneRotation(WeaponPawn.CameraBone);
            ViewLocation = GetBoneCoords(WeaponPawn.CameraBone).Origin + (WeaponPawn.DriverPositions[0].ViewLocation >> AimRotation);

            if (!HitActor.TraceThisActor(IdealHitLocation, HitNormal, ViewLocation + (999999.0 * vector(AimRotation)), ViewLocation))
            {
                HitHeightAboveIdeal = ((HitLocation - IdealHitLocation) << AimRotation).Z;

                // Shot was too high, so check whether it was the closest high shot we've fired
                if (HitHeightAboveIdeal > 0.0)
                {
                    if (HitHeightAboveIdeal < ClosestHighDebugHeight || ClosestHighDebugHeight == 0.0 || DebugPitchAdjustment < ClosestHighDebugPitch)
                    {
                        Log("Closest high shot: Added pitch =" @ DebugPitchAdjustment @ " Hit height relative to target =" @ HitHeightAboveIdeal);
                        ClosestHighDebugHeight = HitHeightAboveIdeal;
                        ClosestHighDebugPitch = DebugPitchAdjustment;
                    }
                }
                // Shot was too low, so check whether it was the closest low shot we've fired
                else if (HitHeightAboveIdeal > ClosestLowDebugHeight || ClosestLowDebugHeight == 0.0 || DebugPitchAdjustment > ClosestLowDebugPitch)
                {
                    Log("Closest low shot: Added pitch =" @ DebugPitchAdjustment @ " Hit height relative to target =" @ HitHeightAboveIdeal);
                    ClosestLowDebugHeight = HitHeightAboveIdeal;
                    ClosestLowDebugPitch = DebugPitchAdjustment;
                }

                // If we haven't yet recorded a closest high or low shot, adjust pitch by give a good chance of getting one with next shot
                if (ClosestHighDebugHeight == 0.0)
                {
                    DebugPitchAdjustment += Max(1, -ClosestLowDebugHeight / 5);
                }
                else if (ClosestLowDebugHeight == 0.0)
                {
                    DebugPitchAdjustment -= Max(1, ClosestHighDebugHeight / 5);
                }
                // Otherwise, if closest low & high shots are more than 1 pitch unit apart, calculate new pitch adjustment to try (pro-rata between closest low & high)
                else if (ClosestHighDebugPitch - ClosestLowDebugPitch > 1)
                {
                    DistanceSpread = ClosestHighDebugHeight - ClosestLowDebugHeight;
                    PitchSpread = ClosestHighDebugPitch - ClosestLowDebugPitch;
                    DebugPitchAdjustment = ClosestHighDebugPitch - (ClosestHighDebugHeight / DistanceSpread * PitchSpread);
                    DebugPitchAdjustment = Clamp(DebugPitchAdjustment, ClosestLowDebugPitch + 1, ClosestHighDebugPitch -1); // ensure new pitch is different to recorded low & high
                }
                // Or if we have a high & low shot within 1 pitch unit of each other, choose the closest & that's out best result - we're finished
                else
                {
                    if (Abs(ClosestHighDebugHeight) < Abs(ClosestLowDebugHeight))
                    {
                        FinalPitchAdjustment = ClosestHighDebugPitch;
                    }
                    else
                    {
                        FinalPitchAdjustment = ClosestLowDebugPitch;
                    }

                    class<DHCannonShell>(ProjectileClass).default.MechanicalRanges[CurrentRangeIndex].RangeValue = FinalPitchAdjustment;
                    bDebugRangeAutomatically = false;

                    MessageText = Tag @ ProjectileDescriptions[GetAmmoIndex()] $ ": Best pitch adjustment for RangeSettings["
                        $ CurrentRangeIndex $ "] of" @ GetRange() @ DHVehicleCannonPawn(Instigator).RangeText @ "=" @ FinalPitchAdjustment;
                }
            }
            // Somehow we couldn't trace the target wall, so we'd better exit debugging
            else
            {
                bDebugRangeAutomatically = false;
                MessageText = "SOMEHOW FAILED TO TRACE TARGET WALL SO EXITING AUTO RANGE CALIBRATION !!!";
            }
        }
        // Or if debug projectile didn't hit target wall - most likely the shot was too low & hit ground before wall, so raise pitch a little & we'll try again
        else
        {
            DebugPitchAdjustment += 1;
        }
    }

    if (MessageText != "")
    {
        WeaponPawn.ClientMessage(MessageText);
        Log(MessageText);
    }

    // Fire another debug projectile, using out new pitch adjustment
    if (bDebugRangeAutomatically && WeaponPawn != none)
    {
        SpawnProjectile(ProjectileClass, false);
    }
    // Or if auto range setting is over, destroy any target wall
    else if (HitActor != none && HitActor.Tag == 'DebugTargetWall')
    {
        HitActor.Destroy();
    }
    else
    {
        DestroyDebugTargetWall();
    }
}

simulated function DestroyDebugTargetWall()
{
    local DHDecoAttachment TargetWall;

    foreach AllActors(class'DHDecoAttachment', TargetWall, 'DebugTargetWall')
    {
        TargetWall.Destroy();
        break;
    }
}

// New debug functions to adjust the gunsight centring, by changing the cannon pawn's OverlayCorrectionX or OverlayCorrectionY, with screen display
// Because we only have 2 range buttons for 4 adjustment options, we adjust (plus or minus) X when in the 1st half of the reload & Y in the 2nd half
// Seems clumsy, but works pretty well - simply pause or slomo the reload in the relevant part you want to modify, then you can adjust away with the range keys
simulated function DebugModifyOverlayCorrection(float Adjustment)
{
    local DHVehicleCannonPawn CP;

    CP = DHVehicleCannonPawn(WeaponPawn);

    if (CP != none)
    {
        if (ReloadState < RL_ReloadingPart3)
        {
            CP.OverlayCorrectionX += Adjustment;
            CP.ClientMessage("New OverlayCorrectionX =" @ CP.OverlayCorrectionX @ " Original value =" @ CP.default.OverlayCorrectionX
                @ " Adjustment =" @ CP.OverlayCorrectionX - CP.default.OverlayCorrectionX);
        }
        else
        {
            CP.OverlayCorrectionY += Adjustment;
            CP.ClientMessage("New OverlayCorrectionY =" @ CP.OverlayCorrectionY @ " Original value =" @ CP.default.OverlayCorrectionY
                @ " Adjustment =" @ CP.OverlayCorrectionY - CP.default.OverlayCorrectionY);
        }
    }
}

// New function to update sight & aiming wheel rotation, called by cannon pawn when gun moves
simulated function UpdateGunWheels()
{
    local int i;
    local rotator BoneRotation;
    local int Value;

    for (i = 0; i < GunWheels.Length; ++i)
    {
        BoneRotation = rot(0, 0, 0);

        switch (GunWheels[i].RotationType)
        {
            case ROTATION_Yaw:
                Value = CurrentAim.Yaw * GunWheels[i].Scale;
                break;
            case ROTATION_Pitch:
                Value = CurrentAim.Pitch * GunWheels[i].Scale;
                break;
            default:
                break;
        }

        switch (GunWheels[i].RotationAxis)
        {
            case AXIS_X:
                BoneRotation.Roll = Value;
                break;
            case AXIS_Y:
                BoneRotation.Pitch = Value;
                break;
            case AXIS_Z:
                BoneRotation.Yaw = Value;
                break;
        }

        SetBoneRotation(GunWheels[i].BoneName, BoneRotation);
    }
}

defaultproperties
{
    // General
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update cannon mesh skeleton (wouldn't otherwise as server doesn't draw mesh)
    bHasTurret=true
    FireAttachBone="com_player"

    // Collision
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    // Turret/cannon movement & animation
    bUseTankTurretRotation=true
    YawBone="Turret"
    PitchBone="Gun"
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_attachment"
    ShootLoweredAnim="shoot_close"
    ShootRaisedAnim="shoot_open"

    // Ammo
    bMultipleRoundTypes=true
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"
    AltFireInterval=0.12 // just a fallback default
    AltFireSpread=0.002
    bUsesTracers=true
    bAltFireTracersOnly=true
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'

    // Weapon fire
    bPrimaryIgnoreFireCountdown=true
    WeaponFireAttachmentBone="Barrel"
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    CannonDustEmitterClass=class'ROEffects.TankCannonDust'
    FireForce="Explosion05"
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true // assumed for a cannon & hard coded into functionality
    AIInfo(0)=(AimError=0.0,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,AimError=750.0,RefireRate=0.99,WarnTargetPct=0.9)

    // Reload
    ReloadState=RL_ReadyToFire
    ReloadStages(0)=(HUDProportion=1.0)
    ReloadStages(1)=(HUDProportion=0.75)
    ReloadStages(2)=(HUDProportion=0.5)
    ReloadStages(3)=(HUDProportion=0.25)
    AltReloadState=RL_ReadyToFire
    AltReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden01',Duration=1.105) // MG34 reload sound acts as generic belt-fed coax MG reload
    AltReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden02',Duration=2.413,HUDProportion=0.75)
    AltReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden03',Duration=1.843,HUDProportion=0.5)
    AltReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden04',Duration=1.314,HUDProportion=0.25)
    SmokeLauncherReloadState=RL_ReadyToFire

    // Sounds
    FireSoundVolume=512.0
    FireSoundRadius=4000.0
    // Match alt fire (coaxial MG) ambient sound volume & radius to a hull MG, so they sound the same (change AltFireSoundScaling to adjust volume)
    // Also, as alt sound values are now the same as normal sound values, it stops a server swapping these values back & forth, which used to happen every time coax fired & stopped
    // So this avoids lots of unnecessary replication (only alt fire uses ambient sound, no there's never any need to change the ambient sound settings)
    AltFireSoundVolume=255.0
    AltFireSoundRadius=272.7
    AltFireSoundScaling=2.75
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750.0

    // Screen shake
    ShakeRotMag=(X=0.0,Y=0.0,Z=50.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=1.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=100.0)
    ShakeOffsetTime=10.0

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bDoOffsetTrace=false
    bAmbientAltFireSound=true
}
