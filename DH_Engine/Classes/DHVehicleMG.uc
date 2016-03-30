//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleMG extends ROMountedTankMG
    abstract;

// General
var     DHVehicleMGPawn MGPawn;              // just a reference to the DH MG pawn actor, for convenience & to avoid lots of casts
var     bool            bMatchSkinToVehicle; // option to automatically match MG skin zero to vehicle skin zero (e.g. for gunshield), avoiding need for separate MGPawn & MG classes
var     vector          MGAttachmentOffset;  // optional positional offset when attaching the MG mesh to the hull (allows correction of modelling errors)

// Ammo & firing
var     class<Projectile>   TracerProjectileClass; // replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so old name was misleading
var     byte                TracerFrequency;       // how often a tracer is loaded in (as in: 1 in the value of TracerFrequency)
var     byte                NumMags;               // number of mags carried for this MG (use byte for more efficient replication)
var     sound               NoAmmoSound;           // 'dry fire' sound when trying to fire empty MG

// MG collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon)
var     DHCollisionMeshActor    CollisionMeshActor;
var     StaticMesh              CollisionStaticMesh; // specify a valid static mesh in MG's default props & the col static mesh will automatically be used

// Stuff for fire effects - Ch!cKeN
var     VehicleDamagedEffect        HullMGFireEffect;
var     class<VehicleDamagedEffect> FireEffectClass;
var     name                        FireAttachBone;
var     vector                      FireEffectOffset;

// Clientside flags to do certain things when certain actors are received, to fix problems caused by replication timing issues
var     bool           bInitializedVehicleBase;          // done set up after receiving the (vehicle) Base actor
var     bool           bInitializedVehicleAndWeaponPawn; // done set up after receiving both the (vehicle) Base & MGPawn actors

// Reloading
struct  ReloadStage
{
    var  sound  Sound;
    var  float  Duration;
};

enum  EReloadState
{
    MG_Empty,
    MG_ReloadedPart1,
    MG_ReloadedPart2,
    MG_ReloadedPart3,
    MG_ReloadedPart4,
    MG_ReadyToFire,
    MG_Waiting, // put waiting at end of list, as ReloadSounds array then matches ReloadState numbering, & also "ReloadState < MG_ReadyToFire" conveniently signifies MG is reloading
};

var     array<ReloadStage>  ReloadSounds;         // sounds for multi-part reload (optional durations, as servers often use 'index' sound files without actual sounds, breaking MG reload)
var     EReloadState        ReloadState;          // the stage of MG reload or readiness (similar to a tank cannon)
var     bool                bReloadPaused;        // MG reload has been paused
var     name                HUDOverlayReloadAnim; // reload animation to play if the MG uses a HUDOverlay

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        NumMags;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientSetReloadState;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: modified to attach new collision static mesh actor, if one has been specified
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (CollisionStaticMesh != none)
    {
        CollisionMeshActor = class'DHCollisionMeshActor'.static.AttachCollisionMesh(self, CollisionStaticMesh, YawBone); // attach to yaw bone, so col mesh turns with MG

        if (CollisionMeshActor != none)
        {
            // Remove all collision from this VehicleWeapon class (instead let col mesh actor handle collision detection)
            SetCollision(false, false); // bCollideActors & bBlockActors both false
            bBlockZeroExtentTraces = false;
            bBlockNonZeroExtentTraces = false;
            bBlockHitPointTraces = false;
            bProjTarget = false;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: no longer use Tick, as MG hatch fire effect is now triggered on net client from Vehicle's PostNetReceive()
// Let's disable Tick altogether to save unnecessary processing
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Matt: modified to call set up functionality that requires the Vehicle actor (just after vehicle spawns via replication)
// This controls common and sometimes critical problems caused by unpredictability of when & in which order a net client receives replicated actor references
// Functionality is moved to series of Initialize-X functions, for clarity & to allow easy subclassing for anything that is vehicle-specific
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

// Multi-stage MG reload similar to a tank cannon, but implemented differently to optimise (runs independently on server & owning net client)
simulated function Timer()
{
    // If already reached final reload stage, always complete reload, regardless of circumstances
    // Reason: final reload sound will have played, so may be confusing if player cannot fire, especially if would need to unbutton to complete an apparently completed reload
    if (ReloadState == ReloadSounds.Length)
    {
        ReloadState = MG_ReadyToFire;
        bReloadPaused = false;

        if (Role == ROLE_Authority)
        {
            MainAmmoCharge[0] = InitialPrimaryAmmo;
        }
    }
    else if (ReloadState < ReloadSounds.Length)
    {
        // For earlier reload stages, we only proceed if we have a player in a position where he can reload
        if (!bReloadPaused && MGPawn != none && MGPawn.Controller != none && MGPawn.CanReload())
        {
            // Play reloading sound for this stage, if there is one (if MG uses a HUD reload animation, it will usually play its own sound through animation notifies)
            // Only played locally & not broadcast by server to other players, as is not worth the network load just for a reload sound
            if (ReloadSounds[ReloadState].Sound != none && MGPawn.IsLocallyControlled())
            {
                PlaySound(ReloadSounds[ReloadState].Sound, SLOT_Misc, 2.0, , 150.0,, false);
            }

            // Set next timer based on duration of current reload sound (use reload duration if specified, otherwise try & get the sound duration)
            if (ReloadSounds[ReloadState].Duration > 0.0)
            {
                SetTimer(ReloadSounds[ReloadState].Duration, false);
            }
            else
            {
                SetTimer(FMax(0.1, GetSoundDuration(ReloadSounds[ReloadState].Sound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
            }

            // Move to next reload state
            ReloadState = EReloadState(ReloadState + 1);
        }
        // Otherwise pause the reload, including stopping any HUD reload animation
        else
        {
            bReloadPaused = true;

            if (MGPawn != none && MGPawn.HUDOverlay != none)
            {
                MGPawn.HUDOverlay.StopAnimating();
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************** FIRING ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to optimise & shorten by removing lots of redundancy for an MG, which doesn't have different round types or alt fire
event bool AttemptFire(Controller C, bool bAltFire)
{
    if (FireCountdown <= 0.0 && Role == ROLE_Authority)
    {
        // Have ammo - fire
        if (ConsumeAmmo(0))
        {
            CalcWeaponFire(bAltFire);

            if (bCorrectAim)
            {
                WeaponFireRotation = AdjustAim(bAltFire);
            }

            if (Spread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * Spread);
            }

            If (Instigator != none)
            {
                Instigator.MakeNoise(1.0);
            }

            FireCountdown = FireInterval;
            Fire(C);
            AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

            return true;
        }

        // Out of ammo - cease fire
        if (MGPawn != none)
        {
            MGPawn.ClientVehicleCeaseFire(bAltFire);
        }
    }

    return false;
}

// Matt: modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        // Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly (result = 0) then it's time to fire a tracer
        if (bUsesTracers && ((InitialPrimaryAmmo - MainAmmoCharge[0] - 1) % TracerFrequency == 0.0))
        {
            SpawnProjectile(TracerProjectileClass, false);
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

// Modified to remove the Super in ROVehicleWeapon to remove calling UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super(VehicleWeapon).FlashMuzzleFlash(bWasAltFire);
}

// Modified to stop 'phantom' firing effects (muzzle flash & tracers) from continuing if player has moved to an invalid firing position while holding down fire button
// Also to enable muzzle flash when hosting a listen server, which the original code misses out
simulated function OwnerEffects()
{
    if (MGPawn != none)
    {
        if (MGPawn.CanFire())
        {
            super.OwnerEffects();

            if (Level.NetMode == NM_ListenServer && AmbientEffectEmitter != none) // added so we get muzzle flash when hosting a listen server
            {
                AmbientEffectEmitter.SetEmitterStatus(true);
            }
        }
        else
        {
            MGPawn.ClientVehicleCeaseFire(bIsAltFire); // stops flash & tracers if player has moved to invalid firing position while holding down fire
        }
    }
}

// Modified to try to start a reload if MG is empty
function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (!HasAmmo(0))
    {
        TryToReload();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** AMMO & RELOADING *******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle MG magazines
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

// New function (in VehicleWeapon class) to use DH's new incremental resupply system
function bool ResupplyAmmo()
{
    if (NumMags < default.NumMags)
    {
        ++NumMags;

        // If MG is out of ammo & waiting to reload & we have a player on the MG, try to start a reload
        if (!HasAmmo(0) && ReloadState == MG_Waiting && Instigator != none && Instigator.Controller != none)
        {
            TryToReload();
        }

        return true;
    }

    return false;
}

// New function to start a reload or resume a previously paused reload
simulated function TryToReload(optional bool bIgnoreViewTransition, optional bool bSkipClientSetReloadState)
{
    local bool bStateChanged;

    // Need to start a new reload
    if (ReloadState >= MG_ReadyToFire)
    {
        if (Role == ROLE_Authority) // a new reload can't be started by a net client
        {
            // Start a reload, if we have a spare mag & a player in a position where he can reload
            if (NumMags > 0 && MGPawn != none && MGPawn.CanReload(bIgnoreViewTransition))
            {
                NumMags--;
                ReloadState = MG_Empty;
                ProgressReload();
                bStateChanged = true;
            }
            // Otherwise make sure loading state is waiting (for a player in reloading position or a resupply)
            else if (ReloadState == MG_ReadyToFire)
            {
                ReloadState = MG_Waiting;

                if (MGPawn != none && !MGPawn.CanReload() && MGPawn.IsLocallyControlled() && DHPlayer(MGPawn.Controller) != none)
                {
                    DHPlayer(MGPawn.Controller).QueueHint(48, true); // need to unbutton to reload externally mounted MG
                }

                bStateChanged = true;
            }

            // If state changed & actor not locally controlled (dedicated server, or listen server with MG controlled by another player), pass new state to client (unless flagged not to)
            if (bStateChanged && !bSkipClientSetReloadState && !MGPawn.IsLocallyControlled())
            {
                ClientSetReloadState(ReloadState);
            }
        }
    }
    // Resume a paused reload
    else if (bReloadPaused)
    {
        ProgressReload();
    }
}

// New server-to-client function to pass reload state & to start/resume clientside reload process if relevant
simulated function ClientSetReloadState(EReloadState NewState)
{
    if (Role < ROLE_Authority)
    {
        ReloadState = NewState;

        // MG is in the middle of a reload
        if (ReloadState < MG_ReadyToFire)
        {
            // Start/resume reloading, as we have a player in a position to reload
            // If server starts new reload on unbuttoning, may be possible that net client is still in state ViewTransition when it receives this replicated function call
            // If so, CanReload would return false & reload would be paused on client, but a split second later client would leave ViewTransition & reload would be resumed
            if (MGPawn != none && MGPawn.CanReload())
            {
                ProgressReload();
            }
            // Otherwise the reload is paused
            else
            {
                bReloadPaused = true;
            }
        }
        // If MG is waiting to start a reload, but player isn't in a position where he can reload, show a hint that he needs to unbutton
        // Player will get this if he is firing the MG, runs out of ammo, but isn't in a valid reload position, e.g. buttoned up on remote controlled MG
        else if (ReloadState == MG_Waiting && MGPawn != none && !MGPawn.CanReload() && DHPlayer(MGPawn.Controller) != none)
        {
            DHPlayer(MGPawn.Controller).QueueHint(48, true); // need to unbutton to reload externally mounted MG
        }
    }
}

// New function to start or resume a reload, including playing any HUD overlay reload animation
simulated function ProgressReload()
{
    local float ReloadSecondsElapsed, TotalReloadDuration;
    local int   i;

    // Make sure reload isn't set to paused & start a reload timer
    bReloadPaused = false;
    SetTimer(0.05, false);

    // If MG uses a HUD reload animation, play it
    if (MGPawn != none && MGPawn.HUDOverlay != none && MGPawn.HUDOverlay.HasAnim(HUDOverlayReloadAnim))
    {
        MGPawn.HUDOverlay.PlayAnim(HUDOverlayReloadAnim);

        // If we're resuming a paused reload, move the animation to where it left off (add up the previous stage durations)
        if (ReloadState > MG_Empty)
        {
            for (i = 0; i < ReloadSounds.Length; ++i)
            {
                if (i < ReloadState)
                {
                    ReloadSecondsElapsed += ReloadSounds[i].Duration;
                }

                TotalReloadDuration += ReloadSounds[i].Duration;
            }

            if (ReloadSecondsElapsed > 0.0)
            {
                MGPawn.HUDOverlay.SetAnimFrame(ReloadSecondsElapsed / TotalReloadDuration);
            }
        }
    }
}

// Modified to return false if MG is not loaded
simulated function bool ReadyToFire(bool bAltFire)
{
    return ReloadState == MG_ReadyToFire && super.ReadyToFire(bAltFire);
}

// Modified to handle MG magazines
simulated function int GetNumMags()
{
    return NumMags;
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

    L.AddPrecacheMaterial(default.HudAltAmmoIcon);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }
}

// Modified to add extra material properties (note the Super in Actor already pre-caches the Skins array)
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(HudAltAmmoIcon);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }
}

// Matt: new function to do set up that requires the 'Gun' reference to the VehicleWeaponPawn actor
// Using it to set a convenient MGPawn reference & our Owner & Instigator variables
simulated function InitializeWeaponPawn(DHVehicleMGPawn MGPwn)
{
    if (MGPwn != none)
    {
        MGPawn = MGPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(MGPawn);
            Instigator = MGPawn;
        }

        // If we also have the Vehicle, initialize anything we need to do where we need both actors
        if (Base != none && !bInitializedVehicleAndWeaponPawn)
        {
            InitializeVehicleAndWeaponPawn();
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHVehicleMGPawn, so lots of things are not going to work!");
    }
}

// Matt: new function to do set up that requires the 'Base' reference to the Vehicle actor we are attached to
// Using it to add option to automatically match MG skin to vehicle skin, e.g. for gunshield, avoiding need for separate MGPawn & MG classes just for camo variants
simulated function InitializeVehicleBase()
{
    // Set any optional attachment offset, when attaching MG to hull (set separately on net client as replication is unreliable & loses fractional precision)
    if (MGAttachmentOffset != vect(0.0, 0.0, 0.0))
    {
        SetRelativeLocation(MGAttachmentOffset);
    }

    // Match MG skin zero to vehicle skin zero, e.g. for gunshield
    if (bMatchSkinToVehicle)
    {
        Skins[0] = Base.Skins[0];
    }

    if (DHVehicle(Base) != none)
    {
        // Set the vehicle's MGun reference
        DHVehicle(Base).MGun = self;

        // If vehicle is burning, start the MG hatch fire effect
        if (DHArmoredVehicle(Base) != none && DHArmoredVehicle(Base).bOnFire)
        {
            StartMGFire();
        }
    }

    // If we also have the VehicleWeaponPawn actor, initialize anything we need to do where we need both actors
    if (MGPawn != none && !bInitializedVehicleAndWeaponPawn)
    {
        InitializeVehicleAndWeaponPawn();
    }
}

// Matt: new function to do any set up that requires both the 'Base' & 'MGPawn' references to the Vehicle & VehicleWeaponPawn actors
// Currently unused but putting it in for consistency & for future usage, including option to easily subclass for any vehicle-specific set up
simulated function InitializeVehicleAndWeaponPawn()
{
    bInitializedVehicleAndWeaponPawn = true;
}

// Modified to enforce use of rotation relative to vehicle (bPCRelativeFPRotation), to use yaw limits from DriverPositions in a multi position MG,
// & so we don't limit view yaw if in behind view
simulated function int LimitYaw(int yaw)
{
    if (!bLimitYaw || (Instigator != none && Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bBehindView))
    {
        return yaw;
    }

    if (MGPawn != none && MGPawn.DriverPositions.Length > 0)
    {
        return Clamp(yaw, MGPawn.DriverPositions[MGPawn.DriverPositionIndex].ViewNegativeYawLimit, MGPawn.DriverPositions[MGPawn.DriverPositionIndex].ViewPositiveYawLimit);
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

// Matt: deprecated functions - return false just in case they get called
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    return false;
}

simulated function bool HitDriver(vector HitLocation, vector Momentum)
{
    return false;
}

// Matt: modified to avoid calling TakeDamage on Driver, as shell & bullet's ProcessTouch now call it directly on the Driver if he was hit
// Note that shell's ProcessTouch also now calls TD() on VehicleWeapon instead of Vehicle itself
// For a vehicle MG this is not counted as a hit on vehicle itself, but we could add any desired functionality here or in subclasses, e.g. shell could wreck MG
// Note that if calling a damage function & DamageType.bDelayedDamage, we need to call SetDelayedDamageInstigatorController(InstigatedBy.Controller) on the relevant pawn
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if ((DamageType == class'Suicided' || DamageType == class'ROSuicided') && MGPawn != none)
    {
        MGPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');
    }
}

// New function to start an MG hatch fire effect - all fires now triggered from vehicle base, so don't need MG's Tick() constantly checking for a fire
simulated function StartMGFire()
{
    if (HullMGFireEffect == none && Level.NetMode != NM_DedicatedServer)
    {
        HullMGFireEffect = Spawn(FireEffectClass);
    }

    if (HullMGFireEffect != none)
    {
        AttachToBone(HullMGFireEffect, FireAttachBone);
        HullMGFireEffect.SetRelativeLocation(FireEffectOffset);
        HullMGFireEffect.UpdateDamagedEffect(true, 0.0, false, false);
    }
}

// Modified to add extra stuff
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.Destroy(); // not actually an effect, but convenient to add here
    }

    if (HullMGFireEffect != none)
    {
        HullMGFireEffect.Kill();
    }
}

defaultproperties
{
    bNetNotify=true // Matt: necessary to do set up requiring the 'Base' actor reference to the MG's vehicle base
    RotationsPerSecond=0.25
    bLimitYaw=true
    YawStartConstraint=0 // revert to defaults from VehicleWeapon, as MGs such as the StuH don't work with the values from ROMountedTankMG
    YawEndConstraint=65535
    PitchUpLimit=15000
    PitchDownLimit=45000
    bInstantFire=false
    Spread=0.002
    WeaponFireAttachmentBone="mg_yaw"
    ReloadState=MG_ReadyToFire
    ReloadSounds(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden01',Duration=1.105) // default is MG34 reload sounds, as is used by most vehicles, even allies
    ReloadSounds(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden02',Duration=2.413)
    ReloadSounds(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden03',Duration=1.843)
    ReloadSounds(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden04',Duration=1.314)
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    FireAttachBone="mg_pitch"
    AIInfo(0)=(bInstantHit=false,bLeadTarget=true,bFireOnRelease=true,WarnTargetPct=0.75,RefireRate=0.1)
}
