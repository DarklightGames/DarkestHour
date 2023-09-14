//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleWeapon extends ROVehicleWeapon
    abstract;

// Vehicle weapon & weapon pawn
var     DHVehicleWeaponPawn WeaponPawn;         // convenient reference to VehicleWeaponPawn actor
var     vector              WeaponAttachOffset; // optional positional offset when attaching VehicleWeapon to the hull
var     bool                bHasTurret;         // this weapon is in a fully rotating turret

// Clientside flags to do set up when key actors are received, to fix problems caused by replication timing issues
var     bool                bInitializedVehicleBase;          // done set up after receiving the (vehicle) Base actor
var     bool                bInitializedVehicleAndWeaponPawn; // done set up after receiving both the (vehicle) Base & VehicleWeaponPawn actors

// Turret/MG collision static mesh - new DHCollisionMeshActor allows us to use a collision static mesh with VehicleWeapon
struct SCollisionStaticMesh
{
    var StaticMesh CollisionStaticMesh;
    var name AttachBone;    // If '', use YawBone.
    var bool bWontStopBullet;
    var bool bWontStopBlastDamage;
};

var     array<SCollisionStaticMesh> CollisionStaticMeshes;
var     array<DHCollisionMeshActor> CollisionMeshActors;

// Weapon fire
var     bool                bUsesMags;          // main weapon uses magazines or similar (e.g. ammo belts), not single shot shells
var     bool                bIsArtillery;       // report our hits to be tracked on artillery targets // TODO: put this in vehicle itself?
var     bool                bSkipFiringEffects; // stops SpawnProjectile() playing firing effects; used to prevent multiple effects for weapons that fire multiple projectiles

var     float       ResupplyInterval;
var     int         LastResupplyTimestamp;

// MG weapon (hull mounted or coaxial)
const   ALTFIRE_AMMO_INDEX = 3;                    // ammo index for alt fire (coaxial MG)
var     byte                NumMGMags;             // number of mags/belts for an MG (using byte for more efficient replication)
var     class<Projectile>   TracerProjectileClass; // replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so old name was misleading
var     byte                TracerFrequency;       // how often a tracer is loaded in, as in 1 in X (deprecates mTracerInterval & mLastTracerTime)

// Reloading
struct ReloadStage
{
    var     sound   Sound;         // part reload sound to play at this stage (set to 'none' if using a HUD reload animation that plays sounds via anim notifies)
    var     float   Duration;      // optional Timer duration for reload stage - if omitted or zero, Timer uses duration of part reload sound for the stage
    var     float   HUDProportion; // proportion of HUD reload indicator (the red bar) to show for this stage (0.0 to 1.0) - allows easy subclassing without overriding functions
};

enum EReloadState
{
    RL_ReloadingPart1,
    RL_ReloadingPart2,
    RL_ReloadingPart3,
    RL_ReloadingPart4,
    RL_ReadyToFire,
    RL_Waiting, // put waiting at end as ReloadStages array then matches ReloadState numbering, & also "ReloadState < RL_ReadyToFire" conveniently signifies weapon is reloading
};

var     bool                bMultiStageReload;    // this weapon uses a multi-stage reload process, that can be paused & resumed
var     EReloadState        ReloadState;          // the stage of weapon reload or readiness
var     array<ReloadStage>  ReloadStages;         // stages for multi-part reload, including sounds, durations & HUD reload icon proportions
var     bool                bReloadPaused;        // a reload has started but was paused, as no longer had a player in a valid reloading position
var     bool                bNewOrResumedReload;  // tells Timer we're starting new reload or resuming paused reload, stopping it from advancing to next reload stage

// Hatch fire effects - Ch!cKeN
var     DHTurretFireEffect          TurretFireEffect;
var     class<DHTurretFireEffect>   FireEffectClass;
var     name                        FireAttachBone;
var     vector                      FireEffectOffset;
var     float                       FireEffectScale;

struct SRangeTableRecord
{
    var float Mils;     // Pitch, in mils.
    var float Range;    // Range, in meters.
    var float TTI;      // Time-to-impact in seconds
};

var array<SRangeTableRecord> RangeTable;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        NumMGMags;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientSetReloadState;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************* ACTOR INITIALISATION & KEY ENGINE EVENTS ******************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to attach any collision static mesh actor
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    AttachCollisionMeshes();
}

simulated function AttachCollisionMeshes()
{
    local name AttachBone;
    local int i;
    local DHCollisionMeshActor CMA;

    for (i = 0; i < CollisionStaticMeshes.Length; ++i)
    {
        // Default is to attach to yaw bone, so col mesh turns sideways with the weapon
        // But there's an option to attach to pitch bone instead, so col mesh rotates up & down with the weapon, e.g. for gun mantlet
        if (CollisionStaticMeshes[i].AttachBone == '')
        {
            AttachBone = YawBone;
        }
        else
        {
            AttachBone = CollisionStaticMeshes[i].AttachBone;
        }

        CMA = class'DHCollisionMeshActor'.static.AttachCollisionMesh(self, CollisionStaticMeshes[i].CollisionStaticMesh, AttachBone);

        if (CMA != none)
        {
            CMA.bWontStopBullet = CollisionStaticMeshes[i].bWontStopBullet;
            CMA.bWontStopBlastDamage = CollisionStaticMeshes[i].bWontStopBlastDamage;

            CollisionMeshActors[CollisionMeshActors.Length] = CMA;

            // Remove all collision from this VehicleWeapon class (instead let col mesh actor handle collision detection)
            SetCollision(false, false);
            bBlockZeroExtentTraces = false;
            bBlockNonZeroExtentTraces = false;
            bBlockHitPointTraces = false;
            bProjTarget = false;

            bCanAutoTraceSelect = false;
            bAutoTraceNotify = false;
        }
    }
}

// Modified to stop us entering state 'ProjectileFireMode', which is deprecated as unnecessary in DH & should never be entered
// Fire functions now work out of state, so projectile fire is effectively the default, non-state condition for all DHVehicleWeapon
simulated function PostNetBeginPlay()
{
    InitEffects();
    MaxRange();
}

// No longer use Tick, as hatch fire effects & manual/powered turret are now triggered on net client from Vehicle's PostNetReceive()
// Let's disable Tick altogether to save unnecessary processing
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Modified to call set up functionality that requires the Vehicle actor (just after vehicle spawns via replication)
// This controls common and sometimes critical problems caused by unpredictability of when & in which order a net client receives replicated actor references
// Functionality is moved to series of InitializeX functions, for clarity & to allow easy subclassing for anything that is vehicle-specific
simulated function PostNetReceive()
{
    // Initialize anything we need to do from the Vehicle actor, or in that actor
    if (!bInitializedVehicleBase)
    {
        if (Base != none)
        {
            bInitializedVehicleBase = true;
            InitializeVehicleBase();
        }
    }
    // Fail-safe so if we somehow lose our Base reference after initializing, we unset our flags & are then ready to re-initialize when we receive Base again
    else if (Base == none)
    {
        bInitializedVehicleBase = false;
        bInitializedVehicleAndWeaponPawn = false;
    }
}

// Implemented here to handle multi-stage reload
simulated function Timer()
{
    if (ReloadState >= RL_ReadyToFire || bReloadPaused)
    {
        return;
    }

    // If we don't have a player in a position to reload, pause the reload
    // Just a fallback & shouldn't happen, as reload gets actively paused if player exits or moves to position where he can't continue reloading
    if (WeaponPawn == none || !WeaponPawn.Occupied() || !WeaponPawn.CanReload())
    {
        PauseReload();

        return;
    }

    // If we're starting a new reload or resuming a paused reload, we just reset that flag & don't advance the reload state
    if (bNewOrResumedReload)
    {
        bNewOrResumedReload = false;
    }
    // Otherwise it means we've just we've completed a reload stage, so we progress to next reload state
    else
    {
        ReloadState = EReloadState(ReloadState + 1);
    }

    // If we just completed the final reload stage, complete the reload
    if (ReloadState >= ReloadStages.Length)
    {
        ReloadState = RL_ReadyToFire;

        if (bUsesMags && Role == ROLE_Authority)
        {
            FinishMagReload();
        }
    }
    // Otherwise play the reloading sound for the next stage & set the next timer
    else
    {
        if (ReloadStages[ReloadState].Sound != none)
        {
            PlayStageReloadSound(); // note there may not be a sound as some MGs use a HUD reload animation that plays its own sound through anim notifies
        }

        if (ReloadStages[ReloadState].Duration > 0.0) // use reload duration if specified, otherwise get the sound duration
        {
            SetTimer(ReloadStages[ReloadState].Duration, false);
        }
        else
        {
            SetTimer(FMax(0.1, GetSoundDuration(ReloadStages[ReloadState].Sound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************** FIRING ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle DH's extended ammo system & re-factored to reduce lots of code repetition & make some functionality improvement
// Random projectile spread is moved to SpawnProjectile() as that allows weapons that fire more than one projectile to calculate random spread for each one
event bool AttemptFire(Controller C, bool bAltFire)
{
    local byte  AmmoIndex;

    if (Role < ROLE_Authority)
    {
        return false;
    }

    // Exit if trying to fire a mag-fed auto weapon before it's time for the next shot
    if (FireCountdown > 0.0 && (bAltFire || bUsesMags))
    {
        return false;
    }

    // Stop firing if weapon not ready to fire, or if player has moved to ineligible firing position while holding down fire button
    if (!ReadyToFire(bAltFire) || (WeaponPawn != none && !WeaponPawn.CanFire()))
    {
         if (WeaponPawn != none)
         {
             WeaponPawn.VehicleCeaseFire(bAltFire);
         }

         return false;
    }

    // Calculate & record weapon's firing location & rotation
    CalcWeaponFire(bAltFire);

    if (bCorrectAim && Instigator != none && !Instigator.IsHumanControlled()) // added human controlled check as in this class AdjustAim() is only relevant to bots
    {
        WeaponFireRotation = AdjustAim(bAltFire);
    }

    // Decrement our round count (note we've already done a 'have ammo' check in the earlier ReadyToFire() check, so we don't need to check that ConsumeAmmo() returns true)
    AmmoIndex = GetAmmoIndex(bAltFire);
    ConsumeAmmo(AmmoIndex);

    // Cannon's coaxial MG fire
    if (bAltFire)
    {
        AltFire(C);
        FireCountdown = AltFireInterval;
    }
    // Main weapon fire
    else
    {
        Fire(C);

        if (bUsesMags)
        {
            FireCountdown = FireInterval;
        }
    }

    if (WeaponPawn != none)
    {
        WeaponPawn.MakeNoise(1.0);
    }

    // Cease fire & try to start a reload, if weapon doesn't use mags or just fired the last round in a mag
    if ((!bAltFire && !bUsesMags) || !HasAmmo(AmmoIndex))
    {
        if (WeaponPawn != none)
        {
            WeaponPawn.VehicleCeaseFire(bAltFire);
        }

        if (bAltFire)
        {
            AttemptAltReload();
        }
        else if (PlayerUsesManualReloading() && bMultiStageReload)
        {
            ReloadState = RL_Waiting; // player reloads manually, so just wait for key press
            PassReloadStateToClient();
        }
        else
        {
            AttemptReload();
        }
    }

    return true;
}

// Fire functions moved out of state 'ProjectileFireMode', which is deprecated as unnecessary in DH
// Projectile fire is now effectively the default, non-state condition for all DHVehicleWeapon
// Modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
// Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly then it's time to fire a tracer
// Also added a fix for bug where listen server host watching another player fire didn't see the firing effects from any AmbientEffectEmitter
function Fire(Controller C)
{
    if (bUsesTracers && !bAltFireTracersOnly && ((InitialPrimaryAmmo - PrimaryAmmoCount() - 1) % TracerFrequency == 0.0) && TracerProjectileClass != none)
    {
        SpawnProjectile(TracerProjectileClass, false);
    }
    else if (ProjectileClass != none)
    {
        SpawnProjectile(ProjectileClass, false);
    }

    if (Level.NetMode == NM_ListenServer && AmbientEffectEmitter != none && !bAmbientEmitterAltFireOnly && !(Instigator != none && Instigator.IsLocallyControlled()))
    {
        AmbientEffectEmitter.SetEmitterStatus(true); // non-owning listen server doesn't get OwnerEffects() & no native code handles this emitter (unlike a non-owning net client)
    }
}

function AltFire(Controller C)
{
    if (bUsesTracers && ((InitialAltAmmo - AltAmmoCharge - 1) % TracerFrequency == 0.0) && TracerProjectileClass != none)
    {
        SpawnProjectile(TracerProjectileClass, true);
    }
    else if (AltFireProjectileClass != none)
    {
        SpawnProjectile(AltFireProjectileClass, true);
    }

    if (Level.NetMode == NM_ListenServer && AmbientEffectEmitter != none && bAmbientEmitterAltFireOnly && !(Instigator != none && Instigator.IsLocallyControlled()))
    {
        AmbientEffectEmitter.SetEmitterStatus(true); // non-owning listen server doesn't get OwnerEffects() & no native code handles this emitter (unlike a non-owning net client)
    }
}

// Modified to calculate weapon's firing location & direction, including any random spread, instead of doing it in AttemptFire()
// Advantages are that spread can be applied separately for each projectile for weapons that fire multiple projectiles,
// and also WeaponFireRotation is preserved as the direction the weapon is aimed (spread is only relevant to one specific projectile, not the weapon's aim)
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;

    P = Spawn(ProjClass, none,, GetProjectileFireLocation(ProjClass), GetProjectileFireRotation(bAltFire));

    if (P != none)
    {
        if (bIsArtillery && P.IsA('DHBallisticProjectile'))
        {
            DHBallisticProjectile(P).VehicleWeapon = self;
        }

        // Play firing effect & sound (unless flagged not to because we're firing multiple projectiles & only want to do this once)
        if (!bSkipFiringEffects)
        {
            FlashMuzzleFlash(bAltFire);

            if (bAltFire)
            {
                if (bAmbientAltFireSound)
                {
                    AmbientSound = AltFireSoundClass;
                    SoundVolume = AltFireSoundVolume;
                    SoundRadius = AltFireSoundRadius;
                    AmbientSoundScaling = AltFireSoundScaling;
                }
                else
                {
                    PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0,, AltFireSoundRadius,, false);
                }
            }
            else
            {
                if (bAmbientFireSound)
                {
                    AmbientSound = FireSoundClass;
                }
                else
                {
                    PlayOwnedSound(GetFireSound(), SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
                }
            }
        }
    }

    return P;
}

// New function to calculate the firing location for a projectile (allows easy subclassing)
function vector GetProjectileFireLocation(class<Projectile> ProjClass)
{
    local vector Extent, HitLocation, HitNormal;

    // bDoOffsetTrace option to make sure we don't try to spawn projectile inside weapon's own vehicle (re-factored from VehicleWeapon to simplify)
    // Traces from outside vehicle's collision back towards planned spawn location, & if it hits our vehicle we adjust spawn location
    // TODO: probably remove bDoOffsetTrace functionality as seems to serve no purpose & when applied as standard for hull MGs it just makes bullets spawn too far forward
    // The problem is TraceThisActor ignores collision static meshes & so traces pretty innacurate hits on the vehicle's crude collision box(es)
    if (bDoOffsetTrace && ProjClass != none && WeaponPawn.VehicleBase != none)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
        Extent.Z = ProjClass.default.CollisionHeight;

        if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation,
                WeaponFireLocation + (vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5)), Extent))
        {
            return HitLocation;
        }
        else
        {
            return WeaponFireLocation + (vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1));
        }
    }

    return WeaponFireLocation;
}

simulated function rotator GetWeaponFireRotation()
{
    return rotator(vector(CurrentAim) >> Rotation);
}

// New function to calculate the firing direction for a projectile, including any random spread (allows easy subclassing)
function rotator GetProjectileFireRotation(optional bool bAltFire)
{
    local float ProjectileSpread;

    if (bAltFire)
    {
        ProjectileSpread = AltFireSpread;
    }
    else
    {
        ProjectileSpread = Spread;
    }

    if (ProjectileSpread > 0.0)
    {
        return rotator(vector(WeaponFireRotation) + (VRand() * FRand() * ProjectileSpread));
    }

    return WeaponFireRotation;
}

// Modified to prevent firing if weapon uses a multi-stage reload & is not loaded, & to only apply FireCountdown check to automatic weapons
simulated function ClientStartFire(Controller C, bool bAltFire)
{
    if (bMultiStageReload && ReloadState != RL_ReadyToFire && !bAltFire) // multi-stage reload weapon can't fire unless loaded
    {
        return;
    }

    if (FireCountdown > 0.0 && (bUsesMags || bAltFire)) // automatic weapon can't fire unless fire interval has elapsed between shots
    {
        return;
    }

    bIsAltFire = bAltFire;

    if (bIsRepeatingFF)
    {
        if (bIsAltFire)
        {
            ClientPlayForceFeedback(AltFireForce);
        }
        else
        {
            ClientPlayForceFeedback(FireForce);
        }
    }

    OwnerEffects();
}

// Modified to add generic support for weapons that use magazines or similar, to add generic support for different fire sounds,
// to stop 'phantom' coaxial firing effects (flash & tracers) from continuing if player has moved to ineligible firing position while holding down fire button,
// and to enable MG muzzle flash (AmbientEffectEmitter) for listen server host firing own weapon, which the original code misses out
simulated function OwnerEffects()
{
    if (Role < ROLE_Authority)
    {
        // Stop the firing effects if shouldn't be able to fire, or if player moves to ineligible firing position while holding down fire button
        if (!ReadyToFire(bIsAltFire) || (WeaponPawn != none && !WeaponPawn.CanFire()))
        {
            if (WeaponPawn != none)
            {
                WeaponPawn.ClientOnlyVehicleCeaseFire(bIsAltFire);
            }

            return;
        }

        // Cannon's coaxial MG
        if (bIsAltFire)
        {
            SoundVolume = AltFireSoundVolume; // bAmbientAltFireSound is now assumed
            SoundRadius = AltFireSoundRadius;
            AmbientSoundScaling = AltFireSoundScaling;

            FireCountdown = AltFireInterval;
        }
        // Main weapon
        else
        {
            if (!bAmbientFireSound)
            {
                PlaySound(GetFireSound(), SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
            }

            if (bUsesMags)
            {
                FireCountdown = FireInterval;
            }
            // After firing a non-automatic weapon, i.e. a normal cannon, server will begin a reload & replicate that to net client (providing we have some ammo)
            // But there's a slight replication delay, so we'll set client to state waiting, otherwise player can press fire again very quickly & get repeat phantom firing effects
            else if (ReloadState == RL_ReadyToFire && bMultiStageReload)
            {
                ReloadState = RL_Waiting;
            }
        }

        FlashMuzzleFlash(bIsAltFire);
    }

    if (Level.NetMode != NM_DedicatedServer) // added this check as effects have no relevance on server
    {
        ShakeView(bIsAltFire);

        if ((bIsAltFire || !bAmbientEmitterAltFireOnly) && AmbientEffectEmitter != none)
        {
            AmbientEffectEmitter.SetEmitterStatus(true); // consolidated here instead of having it in 3 places for 3 net modes (owning listen server now included, so fixes bug)
        }

        if (!bIsRepeatingFF)
        {
            if (bIsAltFire)
            {
                ClientPlayForceFeedback(AltFireForce);
            }
            else
            {
                ClientPlayForceFeedback(FireForce);
            }
        }
    }
}

// Modified to skip over the Super in ROVehicleWeapon to avoid calling UpdateTracer()
// That function is deprecated (& emptied out below) & we now spawn either a normal bullet OR a tracer bullet when we fire
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super(VehicleWeapon).FlashMuzzleFlash(bWasAltFire);
}

simulated function UpdateTracer()
{
}

// Modified to avoid resetting FlashCount immediately, instead briefly entering a new state 'ServerCeaseFire', to use state timing to introduce a slight delay
// This gives time for the changed value of FlashCount to be replicated to non-owning net clients, triggering 3rd person firing effects in their FlashMuzzleFlash()
// This is needed as our slightly modified cease fire process (to optimise replication) means CeaseFire() gets called on the server as soon as the only/last shot is fired
// Also removed similar reset of HitCount as that is only relevant to instant fire weapons, which aren't used in DH (makes no difference but it's tidier)
function CeaseFire(Controller C, bool bWasAltFire)
{
//  FlashCount = 0;
//  HitCount = 0;

    if (AmbientEffectEmitter != none)
    {
        AmbientEffectEmitter.SetEmitterStatus(false);
    }

    if (bAmbientFireSound || bAmbientAltFireSound)
    {
        if (AmbientSound != none)
        {
            if (AmbientSound == FireSoundClass && FireEndSound != none)
            {
                PlaySound(FireEndSound, SLOT_None, SoundVolume / 255.0 * AmbientSoundScaling,, SoundRadius);
            }
            else if (AmbientSound == AltFireSoundClass && AltFireEndSound != none)
            {
                PlaySound(AltFireEndSound, SLOT_None, AltFireSoundVolume / 255.0 * AltFireSoundScaling,, AltFireSoundRadius);
            }
        }

        AmbientSound = none;
        SoundVolume = default.SoundVolume;
        SoundRadius = default.SoundRadius;
        AmbientSoundScaling = default.AmbientSoundScaling;
    }

    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        GotoState('ServerCeaseFire');
    }
}

// New state to add slight delay before resetting FlashCount, giving time for last changed value of FlashCount to be replicated to non-owning net clients
// Meaning FlashCount triggers 3rd person firing effects in their FlashMuzzleFlash(), before the reset zero value gets replicated to them (which stops any firing effects)
// If Fire() or AltFire() are called in the meantime, we exit this state early & resume firing (in that situation there's no need to reset FlashCount)
// The 0.1 second delay is arbitrary, but should give sufficient time, while not being a noticeable delay
// Note that the delay in the original system was essentially random & caused by its network inefficiency
// The server called ClientCeaseFire() on owning client, which in return called VehicleCeaseFire() on server - both know they need to cease fire so was unnecessary
// It did create delay but timing was from 2-way replication between server & owning client, which is random to other clients & no better than arbitrary time delay, maybe worse
state ServerCeaseFire
{
    function Fire(Controller C)
    {
        global.Fire(C);

        GotoState('');
    }

    function AltFire(Controller C)
    {
        global.AltFire(C);

        GotoState('');
    }

Begin:
    Sleep(0.1);
    FlashCount = 0;
    GotoState('');
}

// New helper function to get the main weapon firing sound (allows easy subclassing)
simulated function sound GetFireSound()
{
    return FireSoundClass;
}

// New function to play dry-fire effects if trying to fire weapon when empty
simulated function DryFireEffects(optional bool bAltFire)
{
    ShakeView(bAltFire);
    PlaySound(Sound'Inf_Weapons_Foley.Misc.dryfire_rifle', SLOT_None, 1.5,, 25.0,, true);
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************************* AMMO ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to include MG mags/belts
function bool GiveInitialAmmo()
{
    if (MainAmmoCharge[0] != InitialPrimaryAmmo || MainAmmoCharge[1] != InitialSecondaryAmmo || AltAmmoCharge != InitialAltAmmo || NumMGMags != default.NumMGMags)
    {
        MainAmmoCharge[0] = InitialPrimaryAmmo;
        MainAmmoCharge[1] = InitialSecondaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumMGMags = default.NumMGMags;

        return true;
    }

    return false;
}

// New function (in VehicleWeapon class) to use DH's new incremental resupply system - implement functionality in subclasses
function bool ResupplyAmmo()
{
    return false;
}

// Modified to prevent firing if weapon uses a multi-stage reload & is not loaded
simulated function bool ReadyToFire(bool bAltFire)
{
    if (!bAltFire && bMultiStageReload && ReloadState != RL_ReadyToFire)
    {
        return false;
    }

    return HasAmmo(GetAmmoIndex(bAltFire));
}

// New function to get numeric fire mode from current projectile class
simulated function byte GetAmmoIndex(optional bool bAltFire)
{
    if (bAltFire)
    {
        return ALTFIRE_AMMO_INDEX;
    }

    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        return 0;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        return 1;
    }

    return 255;
}

// Modified to handle MG magazines
simulated function int GetNumMags()
{
    return NumMGMags;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************************** RELOADING **********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to try to start a new reload or resume any paused reload
simulated function AttemptReload()
{
    local EReloadState OldReloadState;

    if (!bMultiStageReload)
    {
        return;
    }

    // Try to start a new reload, as either just fired & needs to load (still in ready to fire state) or is waiting to reload - authority role only
    if (ReloadState == RL_ReadyToFire || ReloadState == RL_Waiting)
    {
        if (Role == ROLE_Authority)
        {
            OldReloadState = ReloadState; // so we can tell if ReloadState changes

            // Start a reload if we have some ammo & player is in a position to reload
            if (HasAmmoToReload(GetAmmoIndex()) && WeaponPawn != none && WeaponPawn.CanReload())
            {
                StartReload();
            }
            // Otherwise make sure loading state is waiting (for a player in reloading position or a resupply)
            else
            {
                ReloadState = RL_Waiting;
                bReloadPaused = false; // just make sure this isn't set, as only relevant to a started reload
            }

            // Server replicates any changed reload state to net client
            if (ReloadState != OldReloadState)
            {
                PassReloadStateToClient();
            }
        }
    }
    // Weapon has started reloading so try to progress/resume it if player is in a position to reload
    // Note we musn't check we have a player here as net client may not yet have received weapon pawn's Controller if reload is starting/resuming on entering vehicle
    // But generally we can assume we do have a player because either server has triggered this to start new reload (& it will have checked for player if necessary),
    // or player has just entered vehicle & triggered this (so even if we don't yet have the Controller, he's in the entering/possession process)
    // In any event the timer makes sure we have a player anyway & the slight delay before timer gets called should mean we have the Controller by then
    else if (WeaponPawn != none && WeaponPawn.CanReload())
    {
        StartReload(true);
    }
    else if (!bReloadPaused)
    {
        PauseReload();
    }
}

// New function to start a new reload or resume a paused reload
simulated function StartReload(optional bool bResumingPausedReload)
{
    if (!bResumingPausedReload)
    {
        if (bUsesMags)
        {
            ConsumeMag(); // remove 1 spare mag
        }

        ReloadState = RL_ReloadingPart1;
    }

    bNewOrResumedReload = true; // stops Timer() from moving on to next stage
    bReloadPaused = false;
    SetTimer(0.1, false); // 0.1 sec delay instead of 0.01 to allow bit longer for net client to receive Controller actor, so check for player doesn't fail due to network delay
}

// New function to pause a reload
simulated function PauseReload()
{
    bReloadPaused = true;
    SetTimer(0.0, false); // clear any timer
}

// New helper function to pause any vehicle weapon reloads that are in progress when the player exits
// Can be subclassed to handle different types of vehicle weapons
simulated function PauseAnyReloads()
{
    if (ReloadState < RL_ReadyToFire && !bReloadPaused && bMultiStageReload)
    {
        PauseReload();
    }
}

// New function for a server to replicate weapon's reload state to the owning net client
// Can be subclassed for handling of more complex reload info, e.g. combined reload states of a cannon & coaxial MG (alt fire)
function PassReloadStateToClient()
{
    if (WeaponPawn != none && !WeaponPawn.IsLocallyControlled()) // dedicated server or non-owning listen server
    {
        ClientSetReloadState(ReloadState);
    }
}

// New function for net client to receive reload state from server & to start or resume a clientside reload timer if the state requires it
// Uses byte instead of enum for passed NewState parameter, which adds flexibility, e.g. cannon subclass can pack cannon & coaxial MG states together
simulated function ClientSetReloadState(byte NewState)
{
    if (Role < ROLE_Authority)
    {
        ReloadState = EReloadState(NewState);

        // If reload has started, try to progress it
        if (ReloadState < RL_ReadyToFire)
        {
            AttemptReload();
        }
        // Weapon isn't reloading (it's either ready to fire or waiting to start a reload)
        // So just just make sure it isn't set to paused, which is only relevant if it's mid-reload
        else if (bReloadPaused)
        {
            bReloadPaused = false;
        }
    }
}

// New function to start or resume an alt fire reload process - implement functionality in subclasses as required, e.g. cannon's coaxial MG
simulated function AttemptAltReload()
{
}

// New helper function to play reloading sound for current reloading stage (separate function allows easy subclassing)
// Using PlayOwnedSound() to avoid broadcasting over network to owning net client as it will play locally there anyway
simulated function PlayStageReloadSound()
{
    PlayOwnedSound(ReloadStages[ReloadState].Sound, SLOT_Misc, 1.0,, 25.0,, true); //reduced volume to 1.0 as do not want players outside tank to hear
}

// New helper function to remove 1 spare mag, used when we begin a new mag reload (a separate function to allow easy subclassing)
function ConsumeMag()
{
    NumMGMags--;
}

// New helper function to finish a magazine reload (a separate function to allow easy subclassing)
function FinishMagReload()
{
    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        MainAmmoCharge[0] = InitialPrimaryAmmo;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        MainAmmoCharge[1] = InitialSecondaryAmmo;
    }
}

// New helper function to check whether we can start a reload for a specified ammo type, accommodating either normal cannon shells or mags
simulated function bool HasAmmoToReload(byte AmmoIndex)
{
    if (bUsesMags || AmmoIndex == ALTFIRE_AMMO_INDEX)
    {
         return NumMGMags > 0;
    }

    return HasAmmo(AmmoIndex);
}

// New helper function to check if player uses manual reloading - implement functionality in subclasses as required
simulated function bool PlayerUsesManualReloading()
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  **************************  HIT DETECTION & DAMAGE  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Emptied out as suicide stuff is irrelevant & never called here, & because as shell & bullet's ProcessTouch now call TakeDamage directly on 'Driver' if he was hit
// Note that shell's ProcessTouch also now calls TakeDamage on VehicleWeapon instead of Vehicle itself, so this function decides what to do with that damage
// Add here if want to pass damage on to vehicle (& if DamageType is bDelayedDamage, need to call SetDelayedDamageInstigatorController(InstigatedBy.Controller) on relevant pawn)
// Can also add any desired functionality in subclasses, e.g. a shell impact could wreck an exposed MG
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
}

// Deprecated functions - return false just in case they get called
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    return false;
}

simulated function bool HitDriver(vector HitLocation, vector Momentum)
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************  SETUP, UPDATE, CLEAN UP, MISCELLANEOUS  *******************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties (note the Supers are empty)
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.Skins.Length; ++i)
    {
        if (default.Skins[i] != none)
        {
            L.AddPrecacheMaterial(default.Skins[i]);
        }
    }

    if (default.HudAltAmmoIcon != none)
    {
        L.AddPrecacheMaterial(default.HudAltAmmoIcon);
    }

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    for (i = 0; i < default.CollisionStaticMeshes.Length; ++i)
    {
        if (default.CollisionStaticMeshes[i].CollisionStaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.CollisionStaticMeshes[i].CollisionStaticMesh);
        }
    }

}

// Modified to add extra material properties (note the Super in Actor already pre-caches the Skins array)
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    if (HudAltAmmoIcon != none)
    {
        Level.AddPrecacheMaterial(HudAltAmmoIcon);
    }

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }
}

// Modified to add projectile classes & collision mesh
simulated function UpdatePrecacheStaticMeshes()
{
    local int i;

    super.UpdatePrecacheStaticMeshes();

    if (PrimaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(PrimaryProjectileClass.default.StaticMesh);
    }

    if (SecondaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(SecondaryProjectileClass.default.StaticMesh);
    }

    for (i = 0; i < CollisionStaticMeshes.Length; ++i)
    {
        if (CollisionStaticMeshes[i].CollisionStaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(CollisionStaticMeshes[i].CollisionStaticMesh);
        }
    }
}

// New function to do set up that requires the 'Gun' reference to the VehicleWeaponPawn actor (called from VehicleWeaponPawn when it receives a reference to this actor)
// Using it to set a convenient WeaponPawn reference & our Owner & Instigator variables
simulated function InitializeWeaponPawn(DHVehicleWeaponPawn WeaponPwn)
{
    if (WeaponPwn != none)
    {
        WeaponPawn = WeaponPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(WeaponPawn);
            Instigator = WeaponPawn;
        }

        // If we also have the Vehicle, initialize anything we need to do where we need both actors
        if (Base != none && !bInitializedVehicleAndWeaponPawn)
        {
            InitializeVehicleAndWeaponPawn();
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHVehicleWeaponPawn, so lots of things are not going to work!");
    }
}

// New function to do set up that requires the 'Base' reference to the Vehicle actor we are attached to
// Using it to add option to reposition VehicleWeapon attachment, & to start a hatch fire if armoured vehicle is burning when replicated.
simulated function InitializeVehicleBase()
{
    // Set any optional attachment offset, when attaching weapon to hull (set separately on net client as replication is unreliable & loses fractional precision)
    if (WeaponAttachOffset != vect(0.0, 0.0, 0.0))
    {
        SetRelativeLocation(WeaponAttachOffset);
    }

    // If vehicle is burning, start the hatch fire effect
    if (DHArmoredVehicle(Base) != none && DHArmoredVehicle(Base).bOnFire)
    {
        StartHatchFire();
    }

    // If we also have the VehicleWeaponPawn actor, initialize anything we need to do where we need both actors
    if (WeaponPawn != none && !bInitializedVehicleAndWeaponPawn)
    {
        InitializeVehicleAndWeaponPawn();
    }
}

// New function to do any set up that requires both the 'Base' & 'WeaponPawn' references to the Vehicle & VehicleWeaponPawn actors
// Currently unused but putting it in for consistency & for future usage, including option to easily subclass for any vehicle-specific set up
simulated function InitializeVehicleAndWeaponPawn()
{
    bInitializedVehicleAndWeaponPawn = true;
}

// Modified to always use rotation relative to vehicle (bPCRelativeFPRotation), to use yaw limits from DriverPositions in multi position weapon, & not to limit view yaw in behind view
// Also to ignore yaw restrictions for commander's periscope or binoculars positions (where bLimitYaw is true, e.g. casemate-style tank destroyers) - but see note below
simulated function int LimitYaw(int yaw)
{
    local int CurrentPosition;

    // TODO: Matt - this is confusing 2 different things: limit on weapon's yaw & limit on player's view yaw
    // bLimitYaw is used by native code to limit (or not) weapon's turning, which ignores anything that happens in this function
    // This function is best thought of as LimitViewYaw() & would be better placed in the cannon pawn class (but needs to stay as is because it is called by UpdateRotation() in PC class)
    // bLimitYaw should not be used here - the view yaw limits should be based on ViewNegativeYawLimit & ViewPositiveYawLimit in DriverPositions
    if (!bLimitYaw)
    {
        return yaw;
    }

    if (WeaponPawn != none)
    {
        if (WeaponPawn.IsHumanControlled() && PlayerController(WeaponPawn.Controller).bBehindView)
        {
            return yaw;
        }

        if (WeaponPawn.DriverPositions.Length > 0)
        {
            CurrentPosition = WeaponPawn.DriverPositionIndex;

            if (WeaponPawn.IsA('DHVehicleCannonPawn') && CurrentPosition >= DHVehicleCannonPawn(WeaponPawn).PeriscopePositionIndex)
            {
                return yaw;
            }

            return Clamp(yaw, WeaponPawn.DriverPositions[CurrentPosition].ViewNegativeYawLimit, WeaponPawn.DriverPositions[CurrentPosition].ViewPositiveYawLimit);
        }
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

// New function to start a hatch fire effect - all fires now triggered from vehicle base, so don't need cannon's Tick() constantly checking for a fire
simulated function StartHatchFire()
{
    if (TurretFireEffect == none && Level.NetMode != NM_DedicatedServer)
    {
        TurretFireEffect = Spawn(FireEffectClass);
    }

    if (TurretFireEffect != none)
    {
        AttachToBone(TurretFireEffect, FireAttachBone);
        TurretFireEffect.SetRelativeLocation(FireEffectOffset);
        TurretFireEffect.UpdateDamagedEffect(true, 0.0, false, false);

        if (FireEffectScale != 1.0)
        {
            TurretFireEffect.SetEffectScale(FireEffectScale);
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PC;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant to other net clients if the VehicleWeapon has not been drawn on their screen recently (within last 3 seconds)
        if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    PC = Level.GetLocalPlayerController();

    if (PC == none || PC.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player in the cannon)
    if (PC.Pawn != Instigator && vector(PC.CalcViewRotation) dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// Modified to add extra stuff
simulated function DestroyEffects()
{
    local int i;

    super.DestroyEffects();

    for (i = 0; i < CollisionMeshActors.Length; ++i)
    {
        if (CollisionMeshActors[i] != none)
        {
            CollisionMeshActors[i].Destroy(); // not actually an effect, but convenient to add here
        }
    }

    if (TurretFireEffect != none)
    {
        TurretFireEffect.Kill();
    }
}

// Implemented in vehicle weapon class so player gets an enter vehicle message when looking at a vehicle weapon, not just its hull or base
simulated event NotifySelected(Pawn User)
{
    if (ROVehicle(Base) != none)
    {
        Base.NotifySelected(User);
    }
}

// New helper function just to avoid code repetition elsewhere
simulated function PlayClickSound()
{
    if (Instigator != none && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
    {
        PlayerController(Instigator.Controller).ClientPlaySound(Sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
    }
}

// Modified to add location & various weapon rotation variables
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local string s;

    super.DisplayDebug(Canvas, YL, YPos);

    YPos += YL;
    Canvas.SetPos(4.0, YPos);
    Canvas.DrawText("Location:" @ Location @ " Rotation:" @ Rotation);

    YPos += YL;
    Canvas.SetPos(4.0, YPos);
    s = "CurrentAim =" @ CurrentAim;

    if (WeaponPawn != none && WeaponPawn.bCustomAiming)
    {
        s @= " CustomAim =" @ WeaponPawn.CustomAim;
    }

    Canvas.DrawText(s);
}

// State 'emptied out' as is deprecated as unnecessary in DH and should never be entered
// Fire functions now work out of state, so projectile fire is effectively the default, non-state condition for all DHVehicleWeapon
state ProjectileFireMode
{
    function Fire(Controller C);
    function AltFire(Controller C);

Begin:
    Log("WARNING:" @ Name @ "entered state 'ProjectileFireMode', which should never happen now!");
    GotoState('');
}

// Functions emptied out as not relevant to a VehicleWeapon in RO/DH, which never uses InstantFireMode:
state InstantFireMode
{
    function Fire(Controller C);
    function AltFire(Controller C);
    simulated event ClientSpawnHitEffects();
    simulated function SpawnHitEffects(Actor HitActor, vector HitLocation, vector HitNormal);
    simulated function AnimEnd(int Channel);
}

simulated function SimulateTraceFire(out vector Start, out rotator Dir, out vector HitLocation, out vector HitNormal);
function TraceFire(vector Start, rotator Dir);

defaultproperties
{
    bNetNotify=true // necessary to do set up requiring the 'Base' actor reference to the vehicle base
    bMultiStageReload=true
    ReloadState=RL_ReadyToFire
    PitchUpLimit=15000
    PitchDownLimit=45000
    SoundRadius=272.7
    FireEffectClass=class'DH_Effects.DHTurretFireEffect'
    FireEffectScale=1.0
    bCanAutoTraceSelect=true // so player gets enter vehicle message when looking at vehicle weapon, not just its hull or base (although will usually be col mesh actor that's traced)
    bAutoTraceNotify=true
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.9)

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & may be hard coded into functionality:
    FireIntervalAimLock=0.0 // also means AimLockReleaseTime is deprecated
    bShowAimCrosshair=false
    bInheritVelocity=false

    ResupplyInterval=2.5
}
