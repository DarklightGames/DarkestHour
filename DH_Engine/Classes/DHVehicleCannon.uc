//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleCannon extends DHVehicleWeapon
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DH_Vehicle_Reloads.uax

enum ECannonReloadState
{
    CR_Waiting,
    CR_Empty,
    CR_ReloadedPart1,
    CR_ReloadedPart2,
    CR_ReloadedPart3,
    CR_ReloadedPart4,
    CR_ReadyToFire,
};

var     DHVehicleCannonPawn CannonPawn;             // just a reference to the DH cannon pawn actor, for convenience & to avoid lots of casts
var     vector              CannonAttachmentOffset; // optional positional offset when attaching the cannon/turret mesh to the hull (allows correction of modelling errors)

// Armor penetration
var     float               FrontArmorFactor, RightArmorFactor, LeftArmorFactor, RearArmorFactor;
var     float               FrontArmorSlope, RightArmorSlope, LeftArmorSlope, RearArmorSlope;
var     float               FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;
var     float               GunMantletArmorFactor;    // used for mantlet hits for casemate-style vehicles without a turret
var     float               GunMantletSlope;
var     bool                bHasAddedSideArmor;       // has side skirts that will make a hit by a HEAT projectile ineffective

// Turret collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon)
var   DHCollisionMeshActor  CollisionMeshActor;
var   StaticMesh            CollisionStaticMesh; // specify a valid static mesh in cannon's default props & the col static mesh will automatically be used

// Ammo (with variables for up to three cannon ammo types, including shot dispersion customized by round type)
var     byte                MainAmmoChargeExtra[3]; // current quantity of each round type (using byte for more efficient replication)
var     int                 InitialTertiaryAmmo;    // starting load of tertiary round type
var     class<Projectile>   TertiaryProjectileClass;
var     class<Projectile>   PendingProjectileClass; // the round type we will switch to after firing currently loaded round
var localized array<string> ProjectileDescriptions; // text for each round type to display on HUD
var     bool                bUsesSecondarySpread;   // use different spread for secondary rounds (if false, just uses Spread setting)
var     float               SecondarySpread;
var     bool                bUsesTertiarySpread;
var     float               TertiarySpread;
var     bool                bCanisterIsFiring;      // canister is spawning separate projectiles - until done it stops firing effects playing or switch to different round type

// Coaxial MG
var     byte                NumAltMags;               // number of mags/belts for the coaxial MG (using byte for more efficient replication)
var     class<Projectile>   AltTracerProjectileClass; // replaces DummyTracerClass as tracer is now a real bullet that damages, not just client-only effect (old name was misleading)
var     byte                AltFireTracerFrequency;   // how often a tracer is loaded in (as in: 1 in the value of AltFireTracerFrequency)
var     sound               NoMGAmmoSound;            // 'dry fire' sound when trying to fire empty coaxial MG
var     float               AltFireSpawnOffsetX;      // optional extra forward offset when spawning MG bullets, allowing them to clear potential collision with driver's head

// Aiming
var     array<int>          RangeSettings;            // for cannons with range adjustment
var     int                 AddedPitch;               // option for global adjustment to cannon's pitch aim

// Firing effects
var     sound               CannonFireSound[3];     // sound of the cannon firing (selected randomly)
var     name                TankShootClosedAnim;    // firing animation if player is in a closed animation position, i.e. buttoned up // TODO: rename
var     name                ShootIntermediateAnim;  // firing animation if player is in an intermediate animation position, i.e. between closed & open/raised positions
var     name                TankShootOpenAnim;      // firing animation if player is in an open or raised animation position, i.e. unbuttoned or standing // TODO: rename
var     class<Emitter>      CannonDustEmitterClass; // emitter class for dust kicked up by the cannon firing
var     Emitter             CannonDustEmitter;

// Reloading
var     ECannonReloadState  CannonReloadState;    // cannon's current reload state/stage
var     bool                bClientCanFireCannon; // definitive flag that determines if cannon can fire
var     sound               ReloadSoundOne;       // cannon partial reload sound to play for the 1st reload stage
var     sound               ReloadSoundTwo;
var     sound               ReloadSoundThree;
var     sound               ReloadSoundFour;
var     sound               ReloadSound;          // reload sound for coaxial MH // TODO: rename to include MG/alt/coax

// Manual/powered turret
var     float               ManualRotationsPerSecond;  // turret/cannon rotation speed when turned by hand
var     float               PoweredRotationsPerSecond; // faster rotation speed with powered assistance (engine must be running)
var     bool                bHasTurret;                // this cannon is in a fully rotating turret

// Fire effects - Ch!cKeN
var     VehicleDamagedEffect        TurretHatchFireEffect;
var     class<VehicleDamagedEffect> FireEffectClass;
var     name                        FireAttachBone;
var     vector                      FireEffectOffset;
var     float                       FireEffectScale;

// Clientside flags to do certain things when certain actors are received, to fix problems caused by replication timing issues
var     bool                bInitializedVehicleBase;          // done set up after receiving the (vehicle) Base actor
var     bool                bInitializedVehicleAndWeaponPawn; // done set up after receiving both the (vehicle) Base & CannonPawn actors

// Debugging and calibration
var     bool                bDrawPenetration;
var     bool                bDebuggingText;
var     bool                bPenetrationText;
var     bool                bLogPenetration;
var     bool                bCannonShellDebugging;
var     vector              TraceHitLocation;
var     config bool         bGunFireDebug;
var     config bool         bGunsightSettingMode;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bClientCanFireCannon;

    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        MainAmmoChargeExtra, NumAltMags, PendingProjectileClass;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerManualReload;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDoReload, ClientSetReloadState;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to attach new collision static mesh actor, if one has been specified
// Also to fix minor bug where 1st key press to switch round type key didn't do anything
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (CollisionStaticMesh != none)
    {
        CollisionMeshActor = class'DHCollisionMeshActor'.static.AttachCollisionMesh(self, CollisionStaticMesh, YawBone); // attach to yaw bone, so col mesh turns with turret/cannon

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

    if (Role == ROLE_Authority && bMultipleRoundTypes)
    {
        PendingProjectileClass = PrimaryProjectileClass;
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Matt: no longer use Tick, as turret hatch fire effect & manual/powered turret are now triggered on net client from Vehicle's PostNetReceive()
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

// Modified to simplify a little, including call PlayOwnedSound for all modes, as calling that on client just plays sound locally, same as PlaySound would do
// Also to postpone reload if cannon is out of ammo & to sharply reduce frequency of repeat timer if reload can't proceed for now
simulated function Timer()
{
    // If a cannon reload isn't in progress then we exit & stop any repeating timer
    if (CannonReloadState == CR_ReadyToFire || CannonReloadState == CR_Waiting)
    {
        SetTimer(0.0, false);
    }
    // Do not proceed with reload if no player in cannon position or if cannon has no ammo - set a repeating timer to keep checking (but reduced from 20 times a second !)
    else if (CannonPawn == none || CannonPawn.Controller == none || PrimaryAmmoCount() < 1)
    {
        SetTimer(0.5, true);
    }
    else if (CannonReloadState == CR_Empty)
    {
        PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart1;
        SetTimer(FMax(0.1, GetSoundDuration(ReloadSoundOne)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
    }
    else if (CannonReloadState == CR_ReloadedPart1)
    {
        PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart2;
        SetTimer(FMax(0.1, GetSoundDuration(ReloadSoundTwo)), false);
    }
    else if (CannonReloadState == CR_ReloadedPart2)
    {
        PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart3;
        SetTimer(FMax(0.1, GetSoundDuration(ReloadSoundThree)), false);
    }
    else if (CannonReloadState == CR_ReloadedPart3)
    {
        PlayOwnedSound(ReloadSoundFour, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart4;
        SetTimer(FMax(0.1, GetSoundDuration(ReloadSoundFour)), false);
    }
    else if (CannonReloadState == CR_ReloadedPart4)
    {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }

        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************** FIRING ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle DH's extended ammo system & re-factored to reduce lots of code repetition
event bool AttemptFire(Controller C, bool bAltFire)
{
    local int   FireMode;
    local float ProjectileSpread;

    // Check that cannon/coaxial MG is ready to fire & that we're an authority role
    if (((!bAltFire && CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || (bAltFire && FireCountdown <= 0.0)) && Role == ROLE_Authority)
    {
        // Calculate the starting WeaponFireRotation
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        // Calculate any random spread & record the FireMode to simplify things later
        if (bAltFire)
        {
            ProjectileSpread = AltFireSpread;
        }
        else
        {
            if (Spread > 0.0)
            {
                ProjectileSpread = Spread; // a starting point for spread, using any primary round spread
            }

            if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
            {
                FireMode = 0;
            }
            else if (ProjectileClass == SecondaryProjectileClass)
            {
                FireMode = 1;

                if (bUsesSecondarySpread && SecondarySpread > 0.0)
                {
                    if (FRand() < 0.6)
                    {
                        ProjectileSpread = SecondarySpread;
                    }
                    else
                    {
                        ProjectileSpread = 0.0015; // 40% chance of SecondaryProjectileClass using literal value for spread instead of shell's SecondarySpread
                        // TODO - Matt: probably remove this as it doesn't seem to make sense
                    }
                }
            }
            else if (ProjectileClass == TertiaryProjectileClass)
            {
                FireMode = 2;

                // No spread here for canister shot, as it is randomised separately for each projectile fired (in the Fire function)
                if (bUsesTertiarySpread && TertiarySpread > 0.0 && class<DHCannonShellCanister>(TertiaryProjectileClass) == none)
                {
                    ProjectileSpread = TertiarySpread;
                }
            }
        }

        // Now apply any random spread
        if (ProjectileSpread > 0.0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * ProjectileSpread);

            if (!bAltFire)
            {
                WeaponFireRotation += rot(1, 6, 0);
            }
        }

        if (Instigator != none)
        {
            Instigator.MakeNoise(1.0);
        }

        // Coaxial MG fire - check we have ammo & fire the MG
        if (bAltFire)
        {
            // If MG is empty we can't fire - start a reload
            if (!ConsumeAmmo(3))
            {
                if (CannonPawn != none)
                {
                    CannonPawn.ClientVehicleCeaseFire(bAltFire);
                }

                HandleReload();

                return false;
            }

            // Fire
            AltFire(C);
            FireCountdown = AltFireInterval;
            AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

            // If we just fired our last MG round, start an MG reload
            if (!HasAmmo(3))
            {
                HandleReload();
            }
        }
        // Cannon fire - check we have ammo & fire the current round
        else
        {
            // If cannon is empty we can't fire
            if (!ConsumeAmmo(FireMode))
            {
                if (CannonPawn != none)
                {
                    CannonPawn.ClientVehicleCeaseFire(bAltFire);
                }

                return false;
            }

            // Fire
            Fire(C);
            bClientCanFireCannon = false;

            // If player uses manual reloading, just set the reload state to waiting (for key press)
            if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
            {
                CannonReloadState = CR_Waiting;
            }
            // Otherwise start a reload, including switch to another ammo type if we have run out of the current type
            // Note we don't start a reload on the client, as that gets done in OwnerEffects(), for effects only
            else
            {
                if (!HasAmmo(FireMode))
                {
                    if (FireMode == GetPendingRoundIndex()) // don't toggle if we already have a different pending ammo type selected
                    {
                        ToggleRoundType(true);// true signifies forced switch, not manual choice, making it try to switch to primary ammo, rather than strictly cycle ammo choice
                    }

                    ProjectileClass = PendingProjectileClass;
                }

                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }
        }

        return true;
    }

    return false;
}

state ProjectileFireMode
{
    // Modified to handle canister shot
    function Fire(Controller C)
    {
        local vector  WeaponFireVector;
        local int     ProjectilesToFire, i;

        // If firing canister shot
        if (class<DHCannonShellCanister>(ProjectileClass) != none)
        {
            bCanisterIsFiring = true;
            ProjectilesToFire = class<DHCannonShellCanister>(ProjectileClass).default.NumberOfProjectilesPerShot;
            WeaponFireVector = vector(WeaponFireRotation);

            for (i = 1; i <= ProjectilesToFire; ++i)
            {
                WeaponFireRotation = rotator(WeaponFireVector + VRand() * FRand() * TertiarySpread);
                WeaponFireRotation += rot(1, 6, 0);

                if (i >= ProjectilesToFire)
                {
                    bCanisterIsFiring = false;
                }

                SpawnProjectile(ProjectileClass, false);
            }
        }
        // Otherwise the usual Super for normal cannon fire
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }

    // Modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
    function AltFire(Controller C)
    {
        // Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly (result=0) then it's time to fire a tracer
        if (bUsesTracers && ((InitialAltAmmo - AltAmmoCharge - 1) % AltFireTracerFrequency == 0.0) && AltTracerProjectileClass != none)
        {
            SpawnProjectile(AltTracerProjectileClass, true);
        }
        else if (AltFireProjectileClass != none)
        {
            SpawnProjectile(AltFireProjectileClass, true);
        }
    }

    // Modified so we can get animend calls to notify the owning pawn that our animation ended (from ROTankCannon)
    simulated function AnimEnd(int Channel)
    {
        if (ROVehicleWeaponPawn(Owner) != none)
        {
            ROVehicleWeaponPawn(Owner).AnimEnd(Channel);
        }
    }
}

// Modified to handle canister shot, by avoiding possibility of switching to a different round type until canister finishes spawning its last separate projectile
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector     StartLocation, HitLocation, HitNormal, Extent;
    local rotator    FireRot;

    // Calculate projectile's starting rotation
    FireRot = WeaponFireRotation;

    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch; // used only for human players - lets cannons with non-centered aim points have a different aiming location
    }

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);

        if (bCannonShellDebugging)
        {
            Log("GetPitchForRange for" @ CurrentRangeIndex @ " = " @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
        }
    }

    // Calculate projectile's starting location - bDoOffsetTrace means we trace from outside vehicle's collision back towards weapon to determine firing offset
    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
        Extent.Z = ProjClass.default.CollisionHeight;

        if (Base != none)
        {
            if (!Base.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation,
                WeaponFireLocation + vector(WeaponFireRotation) * (Base.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
    }
    else
    {
        StartLocation = WeaponFireLocation;
    }

    if (bCannonShellDebugging)
    {
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355.0 * vector(WeaponFireRotation), WeaponFireLocation, false);
    }

    // Now spawn the projectile
    P = Spawn(ProjClass, none,, StartLocation, FireRot);

    // If pending round type is different, switch round type (unless it's canister in the process of spawning separate projectiles)
    if (ProjectileClass != PendingProjectileClass && PendingProjectileClass != none && ProjClass == ProjectileClass && !bCanisterIsFiring)
    {
        ProjectileClass = PendingProjectileClass;
    }

    if (P != none)
    {
        if (bInheritVelocity && Instigator != none)
        {
            P.Velocity = Instigator.Velocity;
        }

        // Play firing effects (unless it's canister in the process of spawning separate projectiles - only do it once at the end)
        if (!bCanisterIsFiring)
        {
            FlashMuzzleFlash(bAltFire);

            if (bAltFire)
            {
                AmbientSound = AltFireSoundClass;
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
            }
        }
    }

    return P;
}

// Modified to remove the call to UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
// Also to check against RaisedPositionIndex instead of bExposed (allows lowered commander in open turret to be exposed), to play shoot 'open' or 'closed' firing animation
// And to add new option for 'intermediate' position with its own firing animation, e.g. some AT guns have open sight position, between optics ('closed') & raised head position
// Also to avoid playing unnecessary shoot animations altogether on a server
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        FlashCount++;
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
    else
    {
        CalcWeaponFire(bWasAltFire);
    }

//  if (!bAltFireTracersOnly && bUsesTracers && !bWasAltFire)
//  {
//      UpdateTracer();
//  }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire)
    {
        if (FlashEmitter != none)
        {
            FlashEmitter.Trigger(self, Instigator);
        }

        if (EffectIsRelevant(Location, false))
        {
            if (EffectEmitterClass != none)
            {
                EffectEmitter = Spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);
            }

            if (CannonDustEmitterClass != none)
            {
                CannonDustEmitter = Spawn(CannonDustEmitterClass, self,, Base.Location, Base.Rotation);
            }
        }

        if (CannonPawn != none && CannonPawn.DriverPositionIndex >= CannonPawn.RaisedPositionIndex) // check against RaisedPositionIndex instead of whether position is bExposed
        {
            if (HasAnim(TankShootOpenAnim))
            {
                PlayAnim(TankShootOpenAnim);
            }
        }
        else if (CannonPawn != none && CannonPawn.DriverPositionIndex == CannonPawn.IntermediatePositionIndex)
        {
            if (HasAnim(ShootIntermediateAnim))
            {
                PlayAnim(ShootIntermediateAnim);
            }
        }
        else if (HasAnim(TankShootClosedAnim))
        {
            PlayAnim(TankShootClosedAnim);
        }
    }
}

// Modified to use a generic AltFireProjectileClass for MG firing effects, but to only spawn it if the cannon has a coaxial MG
simulated function InitEffects()
{
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (FlashEmitterClass != none && FlashEmitter == none)
    {
        FlashEmitter = Spawn(FlashEmitterClass);

        if (FlashEmitter != none)
        {
            FlashEmitter.SetDrawScale(DrawScale);

            if (WeaponFireAttachmentBone != '')
            {
                AttachToBone(FlashEmitter, WeaponFireAttachmentBone);
            }
            else
            {
                FlashEmitter.SetBase(self);
            }

            FlashEmitter.SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
        }
    }

    if (AltFireProjectileClass != none && AmbientEffectEmitterClass != none && AmbientEffectEmitter == none)
    {
        AmbientEffectEmitter = Spawn(AmbientEffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

        if (AmbientEffectEmitter != none)
        {
            if (WeaponFireAttachmentBone != '')
            {
                AttachToBone(AmbientEffectEmitter, WeaponFireAttachmentBone);
            }
            else
            {
                AmbientEffectEmitter.SetBase(self);
            }

            AmbientEffectEmitter.SetRelativeLocation(AltFireOffset);
        }
    }
}

// Modified to use specific ready to fire variables for a cannon instead of FireCountdown, which is only used for coaxial MG fire (from ROTankCannon)
simulated function ClientStartFire(Controller C, bool bAltFire)
{
    bIsAltFire = bAltFire;

    if ((!bIsAltFire && CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || ( bIsAltFire && FireCountdown <= 0.0))
    {
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
}

// Modified to fix occasional bug player where cannon would get stuck and be unable to fire or reload, when player exited position immediately after firing
// On net client this could result in phantom firing effects here, but no shot actually being fired (presume by time fire call reached server there was no player, so no shot fired)
// Cause was client setting bClientCanFireCannon to false here, in anticipation of server doing that, but server never initiating fire/reload process
// Also modified to stop 'phantom' coaxial MG firing effects (flash & tracers) from continuing if player has moved to ineligible firing position while holding down fire button
// And to enable MG muzzle flash when hosting a listen server, which the original code misses out
simulated function OwnerEffects()
{
    // Stop the firing effects it we shouldn't be able to fire, or if player moves to ineligible firing position while holding down fire button on coaxial MG
    if (Role < ROLE_Authority)
    {
        if (!ReadyToFire(bIsAltFire) || (CannonPawn != none && !CannonPawn.CanFire()))
        {
            CannonPawn.ClientVehicleCeaseFire(bIsAltFire);

            return;
        }

        if (bIsAltFire)
        {
            FireCountdown = AltFireInterval;

            SoundVolume = AltFireSoundVolume;
            SoundRadius = AltFireSoundRadius;
            AmbientSoundScaling = AltFireSoundScaling;
        }
        else
        {
            PlaySound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);

            // Wait for player to reload manually
            if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
            {
                CannonReloadState = CR_Waiting;
            }
            // Start an automatic reload
            else
            {
                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }

//          bClientCanFireCannon = false; // removed to fix occasion fire/reload bug
        }

        AimLockReleaseTime = Level.TimeSeconds + (FireCountdown * FireIntervalAimLock);

        FlashMuzzleFlash(bIsAltFire);
    }

    if (Level.NetMode != NM_DedicatedServer && bIsAltFire && AmbientEffectEmitter != none)
    {
        AmbientEffectEmitter.SetEmitterStatus(true); // consolidated here instead of having it in 3 places for 3 net modes
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

    ShakeView(bIsAltFire);
}

// Modified to remove shake from coaxial MGs
simulated function ShakeView(bool bWasAltFire)
{
    if (!bWasAltFire && Instigator != none && PlayerController(Instigator.Controller) != none)
    {
        PlayerController(Instigator.Controller).WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}

// Modified to handle DH's extended ammo system (coax MG is now mode 3)
function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (bWasAltFire && !HasAmmo(3))
    {
        HandleReload();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* RANGE SETTING  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Functions extended for easy tuning of gunsights in development mode
// Modified to network optimise by clientside check before sending replicated function to server, & also playing click clientside, not replicating it back
// These functions now get called on both client & server, but only progress to server if it's a valid action (see modified LeanLeft & LeanRight execs in DHPlayer)
simulated function IncrementRange()
{
    // If bGunsightSettingMode is enabled & gun not loaded, then the range control buttons change sight adjustment up and down
    if (bGunsightSettingMode && CannonReloadState != CR_ReadyToFire)
    {
        if (Role == ROLE_Authority) // the server action from when this was a server only function
        {
            IncreaseAddedPitch();
            GiveInitialAmmo();
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none) // net client just calls the server function
        {
            ROPlayer(Instigator.Controller).ServerLeanRight(true);
        }
    }
    // Normal range adjustment - 1st make sure it's a valid action
    else if (CurrentRangeIndex < RangeSettings.Length - 1)
    {
        if (Role == ROLE_Authority) // the server action from when this was a server only function
        {
            CurrentRangeIndex++;
        }

        if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller) != none)
        {
            if (Role < ROLE_Authority) // net client calls the server function, but only if we passed the valid action check
            {
                ROPlayer(Instigator.Controller).ServerLeanRight(true);
            }

            if (Instigator.IsLocallyControlled()) // play click sound only locally
            {
                ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
            }
        }
    }
}

simulated function DecrementRange()
{
    if (bGunsightSettingMode && CannonReloadState != CR_ReadyToFire)
    {
        if (Role == ROLE_Authority)
        {
            DecreaseAddedPitch();
            GiveInitialAmmo();
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            ROPlayer(Instigator.Controller).ServerLeanLeft(true);
        }
    }
    else if (CurrentRangeIndex > 0)
    {
        if (Role == ROLE_Authority)
        {
            CurrentRangeIndex--;
        }

        if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller) != none)
        {
            if (Role < ROLE_Authority)
            {
                ROPlayer(Instigator.Controller).ServerLeanLeft(true);
            }

            if (Instigator.IsLocallyControlled())
            {
                ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
            }
        }
    }
}

// Functions making AddedPitch (gunsight correction) adjustment and display:
function IncreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch += 1;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none)
    {
        Instigator.ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue + Correction @ "       correction =" @ Correction);
    }
}

function DecreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch -= 1;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none)
    {
        Instigator.ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue + Correction @ "       correction =" @ Correction);
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

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** AMMO & RELOADING *******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use DH's MainAmmoChargeExtra array
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo ||
        AltAmmoCharge != InitialAltAmmo || NumAltMags != default.NumAltMags)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumAltMags = default.NumAltMags;

        return true;
    }

    return false;
}

// New function (in VehicleWeapon class) to use DH's new incremental resupply system (only resupplies rounds; doesn't reload the cannon)
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
    {
        ++MainAmmoChargeExtra[0];
        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
    {
        ++MainAmmoChargeExtra[1];
        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
    {
        ++MainAmmoChargeExtra[2];
        bDidResupply = true;
    }

    if (NumAltMags < default.NumAltMags)
    {
        ++NumAltMags;
        bDidResupply = true;

        // If coaxial MG is out of ammo, start an MG reload, but only if there is a player in the cannon position
        // Note we don't need to consider cannon reload, as an empty cannon will already be on a repeating reload timer (or waiting for key press if player uses manual reloading)
        if (!HasAmmo(3) && Instigator != none && Instigator.Controller != none && Role == ROLE_Authority)
        {
            HandleReload();
        }
    }

    return bDidResupply;
}

// Modified to handle DH's extended ammo system
simulated function bool ConsumeAmmo(int Mode)
{
    if (!HasAmmo(Mode))
    {
        return false;
    }

    switch (Mode)
    {
        case 0:
            MainAmmoChargeExtra[0]--;
            return true;
        case 1:
            MainAmmoChargeExtra[1]--;
            return true;
        case 2:
            MainAmmoChargeExtra[2]--;
            return true;
        case 3:
            AltAmmoCharge--;
            return true;
        default:
            return false;
    }

    return false;
}

// Modified to handle DH's extended ammo system (coax MG is now mode 3)
simulated function bool HasAmmo(int Mode)
{
    switch (Mode)
    {
        case 0:
            return (MainAmmoChargeExtra[0] > 0);
            break;
        case 1:
            return (MainAmmoChargeExtra[1] > 0);
            break;
        case 2:
            return (MainAmmoChargeExtra[2] > 0);
            break;
        case 3:
            return (AltAmmoCharge > 0);
            break;
        default:
            return false;
    }

    return false;
}

// Modified to handle DH's extended ammo system
simulated function int PrimaryAmmoCount()
{
    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        return MainAmmoChargeExtra[0];
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        return MainAmmoChargeExtra[1];
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        return MainAmmoChargeExtra[2];
    }
}

// Modified to return the number of mags/belts for the coaxial MG (from ROTankCannon)
simulated function int GetNumMags()
{
    return NumAltMags;
}

// Modified to handle DH's extended ammo system
simulated function int GetRoundsDescription(out array<string> Descriptions)
{
    local int i;

    Descriptions.Length = 0;

    for (i = 0; i < ProjectileDescriptions.Length; ++i)
    {
        Descriptions[i] = ProjectileDescriptions[i];
    }

    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        return 0;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        return 1;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

// Modified to handle DH's extended ammo system
simulated function int GetPendingRoundIndex()
{
    if (PendingProjectileClass != none)
    {
        if (PendingProjectileClass == PrimaryProjectileClass)
        {
            return 0;
        }
        else if (PendingProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else if (PendingProjectileClass == TertiaryProjectileClass)
        {
            return 2;
        }
        else
        {
            return -1; // RO used 3 as the invalid/null return value, but that runs the risk of functions like HasAmmo() using 3 to return the alt fire (coaxial MG) ammo status
        }
    }
    else
    {
        if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
        {
            return 0;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            return 2;
        }
        else
        {
            return -1;
        }
    }
}

// Modified to handle DH's extended ammo system (also slightly optimised)
simulated function bool ReadyToFire(bool bAltFire)
{
    local int Mode;

    if (bAltFire)
    {
        Mode = 3;
    }
    else
    {
        if (!bClientCanFireCannon || CannonReloadState != CR_ReadyToFire)
        {
            return false;
        }

        if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
        {
            Mode = 0;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            Mode = 1;
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            Mode = 2;
        }
    }

    return HasAmmo(Mode);
}

// Modified to handle DH's extended ammo system
function ToggleRoundType(optional bool bForcedSwitch)
{
    if (PendingProjectileClass == PrimaryProjectileClass)
    {
        if (HasAmmo(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        // bForcedSwitch option is passed if we have run out of ammo, meaning if it was secondary ammo then we try to switch back to primary instead of tertiary
        if ((bForcedSwitch || !HasAmmo(2)) && HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmo(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
    }
    else
    {
        if (HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmo(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
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

// Modified to prevent attempting reload if don't have ammo
function ServerManualReload()
{
    if (Role == ROLE_Authority && CannonReloadState == CR_Waiting && HasAmmo(GetPendingRoundIndex()))
    {
        // If player has selected a different ammo type, switch now
        if (PendingProjectileClass != ProjectileClass && PendingProjectileClass != none)
        {
            ProjectileClass = PendingProjectileClass;
        }

        // Start reload on both client & server
        CannonReloadState = CR_Empty;
        ClientSetReloadState(CannonReloadState); // tell a net client to start reloading
        SetTimer(0.01, false);
    }
}

// Modified so only sets timer if the new reload state needs it, & to only act on net client (avoids duplication for standalone or listen server)
// Also add fail-safe if net client somehow hasn't got correct value of bClientCanFireCannon in reload state ready to fire (if server passes state RTF, cannon must be ready)
simulated function ClientSetReloadState(ECannonReloadState NewState)
{
    if (Role < ROLE_Authority)
    {
        CannonReloadState = NewState;

        if (CannonReloadState == CR_ReadyToFire)
        {
            bClientCanFireCannon = true;
        }
        else if (CannonReloadState != CR_Waiting)
        {
            SetTimer(0.01, false);
        }
    }
}

// New function to start a reload for the coxial MG (from ROTankCannon) // TODO: rename to include MG/coax/alt
function HandleReload()
{
    if (NumAltMags > 0)
    {
        NumAltMags--;
        AltAmmoCharge = InitialAltAmmo;
        ClientDoReload();
        NetUpdateTime = Level.TimeSeconds - 1.0;
        FireCountdown = GetSoundDuration(ReloadSound);
        PlaySound(ReloadSound, SLOT_None, 1.5,, 25.0, , true);
    }
}

// New function to set the fire countdown clientside (from ROTankCannon)
simulated function ClientDoReload()
{
    FireCountdown = GetSoundDuration(ReloadSound);

    if (CannonPawn != none)
    {
        CannonPawn.ClientVehicleCeaseFire(true);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************  HIT DETECTION, PENETRATION & DAMAGE  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Deprecated functions - return false just in case they get called
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    return false;
}

simulated function bool HitDriver(vector HitLocation, vector Momentum)
{
    return false;
}

// New generic function to handle penetration calcs for any shell type
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
    local float  WeaponRotationDegrees, HitAngleDegrees, Side, InAngle, InAngleDegrees;
    local vector LocDir, HitDir, X, Y, Z;

    if (!bHasTurret)
    {
        // Checking that PenetrationNumber > ArmorFactor 1st is a quick pre-check that it's worth doing more complex calculations in CheckPenetration()
        return PenetrationNumber > GunMantletArmorFactor && CheckPenetration(P, GunMantletArmorFactor, GunMantletSlope, PenetrationNumber);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0.0;
    HitDir = HitLocation - Location;
    HitDir.Z = 0.0;
    HitAngleDegrees = class'DHLib'.static.RadiansToDegrees(Acos(Normal(LocDir) dot Normal(HitDir)));
    GetAxes(Rotation, X, Y, Z);
    Side = Y dot HitDir;

    if (Side < 0.0)
    {
        HitAngleDegrees = 360.0 - HitAngleDegrees;
    }

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360.0);
    HitAngleDegrees -= WeaponRotationDegrees;

    if (HitAngleDegrees < 0.0)
    {
        HitAngleDegrees += 360.0;
        X = X >> CurrentAim;
        Y = Y >> CurrentAim;
    }

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Turret hit angle =" @ HitAngleDegrees @ "degrees");
    }

    // Frontal hit
    if (HitAngleDegrees >= FrontLeftAngle || HitAngleDegrees < FrontRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Front turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Calculate the direction the shot came from, so we can check for possible 'hit detection bug' (opposite side collision detection error)
        InAngle = Acos(Normal(-HitRotation) dot Normal(X));
        InAngleDegrees = class'DHLib'.static.RadiansToDegrees(InAngle);

        // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to opposite side
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from front to REAR turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm, slope =" @ RearArmorSlope);
            }

            // Checking that PenetrationNumber > ArmorFactor 1st is a quick pre-check that it's worth doing more complex calculations in CheckPenetration()
            return PenetrationNumber > RearArmorFactor && CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit: base armor =" @ FrontArmorFactor * 10.0 $ "mm, slope =" @ FrontArmorSlope);
        }

        return PenetrationNumber > FrontArmorFactor && CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);

    }

    // Right side hit
    else if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Right side turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = class'DHLib'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm, slope =" @ LeftArmorSlope);
            }

            return PenetrationNumber > LeftArmorFactor && CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm, slope =" @ RightArmorSlope);
        }

        return PenetrationNumber > RightArmorFactor && CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
    }

    // Rear hit
    else if (HitAngleDegrees >= RearRightAngle && HitAngleDegrees < RearLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Rear turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = class'DHLib'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from rear to FRONT turret hit: base armor =" @ FrontArmorFactor * 10.0 $ "mm, slope =" @ FrontArmorSlope);
            }

            return PenetrationNumber > FrontArmorFactor && CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm, slope =" @ RearArmorSlope);
        }

        return PenetrationNumber > RearArmorFactor && CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
    }

    // Left side hit
    else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Left side turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = class'DHLib'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from left to RIGHT turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm, slope =" @ RightArmorSlope);
            }

            return PenetrationNumber > RightArmorFactor && CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm, slope =" @ LeftArmorSlope);
        }

        return PenetrationNumber > LeftArmorFactor && CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
    }

    // Should never happen !
    else
    {
       Log ("?!? We shoulda hit something !!!!");
       Level.Game.Broadcast(self, "?!? We shoulda hit something !!!!");

       return false;
    }
}

// Matt: new generic function to handle penetration calcs for any shell type
// Replaces PenetrationAPC, PenetrationAPDS, PenetrationHVAP, PenetrationHVAPLarge & PenetrationHEAT (also Darkest Orchestra's PenetrationAP & PenetrationAPBC)
simulated function bool CheckPenetration(DHAntiVehicleProjectile P, float ArmorFactor, float CompoundAngle, float PenetrationNumber)
{
    local DHArmoredVehicle AV;
    local float CompoundAngleDegrees, OverMatchFactor, SlopeMultiplier, EffectiveArmor, PenetrationRatio;
    local bool  bProjectilePenetrated;

    // Convert angle back to degrees
    CompoundAngleDegrees = class'DHLib'.static.RadiansToDegrees(CompoundAngle);

    if (CompoundAngleDegrees > 90.0)
    {
        CompoundAngleDegrees = 180.0 - CompoundAngleDegrees;
    }

    // Calculate the SlopeMultiplier & EffectiveArmor, to give us the PenetrationRatio
    OverMatchFactor = ArmorFactor / P.ShellDiameter;
    SlopeMultiplier = GetArmorSlopeMultiplier(P, CompoundAngleDegrees, OverMatchFactor);
    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    // Penetration debugging
    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective armor:" @ EffectiveArmor * 10.0 $ "mm" @ " Shot penetration:" @ PenetrationNumber * 10.0 $ "mm");
        Level.Game.Broadcast(self, "Compound angle:" @ CompoundAngleDegrees @ " Slope multiplier:" @ SlopeMultiplier);
    }

    // Check if round shattered on armor
    P.bRoundShattered = P.bShatterProne && PenetrationRatio >= 1.0 && CheckIfShatters(P, PenetrationRatio, OverMatchFactor);

    // Check if round penetrated the vehicle
    bProjectilePenetrated = PenetrationRatio >= 1.0 && !P.bRoundShattered;

    // Set TakeDamage-related variables on the vehicle itself
    AV = DHArmoredVehicle(Base);

    if (AV != none)
    {
        AV.bProjectilePenetrated = bProjectilePenetrated;
        AV.bTurretPenetration = bProjectilePenetrated;
        AV.bRearHullPenetration = false;
        AV.bHEATPenetration = P.RoundType == RT_HEAT && bProjectilePenetrated;
    }

    return bProjectilePenetrated;
}

// Returns the compound hit angle (now we pass AOI to this function in radians, to save unnecessary processing to & from degrees)
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    return Acos(Cos(class'DHLib'.static.DegreesToRadians(Abs(ArmorSlopeDegrees))) * Cos(AOI));
}

// New generic function to work with generic ShouldPenetrate & CheckPenetration functions
simulated function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float CompoundAngleDegrees, optional float OverMatchFactor)
{
    local float CompoundExp, RoundedDownAngleDegrees, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, SlopeMultiplierGap;

    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter > 8.5) // HVAP rounds bigger than 85mm shell diameter (instead of using separate RoundType RT_HVAPLarge)
        {
            if (CompoundAngleDegrees <= 30.0)
            {
               CompoundExp = CompoundAngleDegrees ** 1.75;

               return 2.71828 ** (CompoundExp * 0.000662);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 0.9043 * (2.71828 ** (CompoundExp * 0.0001987));
            }
        }
        else // smaller HVAP rounds
        {
            if (CompoundAngleDegrees <= 25.0)
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 2.71828 ** (CompoundExp * 0.0001727);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 1.5;

               return 0.7277 * (2.71828 ** (CompoundExp * 0.003787));
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        CompoundExp = CompoundAngleDegrees ** 2.6;

        return 2.71828 ** (CompoundExp * 0.00003011);
    }
    else if (P.RoundType == RT_HEAT)
    {
        return 1.0 / Cos(class'DHLib'.static.DegreesToRadians(Abs(CompoundAngleDegrees)));
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (CompoundAngleDegrees < 10.0)
        {
            return CompoundAngleDegrees / 10.0 * ArmorSlopeTable(P, 10.0, OverMatchFactor);
        }
        else
        {
            RoundedDownAngleDegrees = float(int(CompoundAngleDegrees / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            ExtraAngleDegrees = CompoundAngleDegrees - RoundedDownAngleDegrees;
            BaseSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees, OverMatchFactor);
            NextSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees + 5.0, OverMatchFactor);
            SlopeMultiplierGap = NextSlopeMultiplier - BaseSlopeMultiplier;

            return BaseSlopeMultiplier + (ExtraAngleDegrees / 5.0 * SlopeMultiplierGap);
        }
    }

    return 1.0; // fail-safe neutral return value
}

// New generic function to work with new GetArmorSlopeMultiplier for APC shells (also handles Darkest Orchestra's AP & APBC shells)
simulated function float ArmorSlopeTable(DHAntiVehicleProjectile P, float CompoundAngleDegrees, float OverMatchFactor)
{
    // after Bird & Livingston:
    if (P.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 0.98  * (OverMatchFactor ** 0.06370); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.00  * (OverMatchFactor ** 0.09690);
        else if (CompoundAngleDegrees <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (CompoundAngleDegrees <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (CompoundAngleDegrees <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (CompoundAngleDegrees <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (CompoundAngleDegrees <= 45.0)  return 2.00  * (OverMatchFactor ** 0.34717);
        else if (CompoundAngleDegrees <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (CompoundAngleDegrees <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (CompoundAngleDegrees <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (CompoundAngleDegrees <= 65.0)  return 6.27  * (OverMatchFactor ** 0.91920);
        else if (CompoundAngleDegrees <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (CompoundAngleDegrees <= 75.0)  return 13.75 * (OverMatchFactor ** 1.07400);
        else if (CompoundAngleDegrees <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                    return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.04  * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.06  * (OverMatchFactor ** 0.02315);
        else if (CompoundAngleDegrees <= 20.0)  return 1.08  * (OverMatchFactor ** 0.03448);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.05134);
        else if (CompoundAngleDegrees <= 30.0)  return 1.16  * (OverMatchFactor ** 0.07710);
        else if (CompoundAngleDegrees <= 35.0)  return 1.22  * (OverMatchFactor ** 0.11384);
        else if (CompoundAngleDegrees <= 40.0)  return 1.31  * (OverMatchFactor ** 0.16952);
        else if (CompoundAngleDegrees <= 45.0)  return 1.44  * (OverMatchFactor ** 0.24604);
        else if (CompoundAngleDegrees <= 50.0)  return 1.68  * (OverMatchFactor ** 0.37910);
        else if (CompoundAngleDegrees <= 55.0)  return 2.11  * (OverMatchFactor ** 0.56444);
        else if (CompoundAngleDegrees <= 60.0)  return 3.50  * (OverMatchFactor ** 1.07411);
        else if (CompoundAngleDegrees <= 65.0)  return 5.34  * (OverMatchFactor ** 1.46188);
        else if (CompoundAngleDegrees <= 70.0)  return 9.48  * (OverMatchFactor ** 1.81520);
        else if (CompoundAngleDegrees <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (CompoundAngleDegrees <= 80.0)  return 56.20 * (OverMatchFactor ** 2.56210);
        else                                    return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (CompoundAngleDegrees <= 20.0)  return 1.10  * (OverMatchFactor ** 0.0454);
        else if (CompoundAngleDegrees <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (CompoundAngleDegrees <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (CompoundAngleDegrees <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (CompoundAngleDegrees <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (CompoundAngleDegrees <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (CompoundAngleDegrees <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (CompoundAngleDegrees <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (CompoundAngleDegrees <= 60.0)  return 2.56  * (OverMatchFactor ** 0.2450);
        else if (CompoundAngleDegrees <= 65.0)  return 3.20  * (OverMatchFactor ** 0.3354);
        else if (CompoundAngleDegrees <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (CompoundAngleDegrees <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (CompoundAngleDegrees <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                    return 11.32 * (OverMatchFactor ** 0.4550); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// New generic function to work with new CheckPenetration function - checks if the round should shatter, based on the 'shatter gap' for different round types
simulated function bool CheckIfShatters(DHAntiVehicleProjectile P, float PenetrationRatio, optional float OverMatchFactor)
{
    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.27)
            {
                return true;
            }
        }
        else // smaller HVAP rounds
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.34)
            {
                return true;
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.2)
        {
            return true;
        }
    }
    else if (P.RoundType == RT_HEAT) // no chance of shatter for HEAT round
    {
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (OverMatchFactor > 0.8 && PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19)
        {
            return true;
        }
    }

    return false;
}

// Matt: modified as shell's ProcessTouch() now calls TD() on VehicleWeapon instead of directly on vehicle itself, but for a cannon it's counted as a vehicle hit, so we call TD() on vehicle
// Can also be subclassed for any custom handling of cannon hits
// Also to avoid calling TakeDamage on Driver, as shell & bullet's ProcessTouch now call it directly on the Driver if he was hit
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Suicide
    if ((DamageType == class'Suicided' || DamageType == class'ROSuicided') && CannonPawn != none)
    {
        CannonPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');
    }
    // Shell's ProcessTouch now calls TD here, but for tank cannon this is counted as hit on vehicle itself, so we call TD on that
    else if (Base != none)
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

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties
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

// Modified to add TertiaryProjectileClass
simulated function UpdatePrecacheStaticMeshes()
{
    super.UpdatePrecacheStaticMeshes();

    if (PrimaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(PrimaryProjectileClass.default.StaticMesh);
    }

    if (SecondaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(SecondaryProjectileClass.default.StaticMesh);
    }

    if (TertiaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    }
}

// New function to do set up that requires the 'Gun' reference to the VehicleWeaponPawn actor
// Using it to set a convenient CannonPawn reference & our Owner & Instigator variables (they were previously set in PostNetReceive)
simulated function InitializeWeaponPawn(DHVehicleCannonPawn CannonPwn)
{
    if (CannonPwn != none)
    {
        CannonPawn = CannonPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(CannonPawn);
            Instigator = CannonPawn;
        }

        // If we also have the Vehicle, initialize anything we need to do where we need both actors
        if (Base != none && !bInitializedVehicleAndWeaponPawn)
        {
            InitializeVehicleAndWeaponPawn();
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHVehicleCannonPawn, so lots of things are not going to work!");
    }
}

// New function to do set up that requires the 'Base' reference to the Vehicle actor we are attached to
// Using it to add option of cannon mesh attachment offset, to give Vehicle a reference to this actor, to start a hatch fire if vehicle is burning when replicated.
// & an option for to skin cannon mesh using CannonSkins array in Vehicle class (avoiding need for separate cannon pawn & cannon classes just for camo variants)
simulated function InitializeVehicleBase()
{
    local DHVehicle V;
    local int       i;

    // Set any optional attachment offset, when attaching cannon/turret to hull (set separately on net client as replication is unreliable & loses fractional precision)
    if (CannonAttachmentOffset != vect(0.0, 0.0, 0.0))
    {
        SetRelativeLocation(CannonAttachmentOffset);
    }

    V = DHVehicle(Base);

    if (V != none)
    {
        // Set the vehicle's Cannon reference - normally only used clientside in HUD, but can be useful elsewhere, including on server
        V.Cannon = self;

        if (Level.NetMode != NM_DedicatedServer)
        {
            // Option to skin the cannon mesh using CannonSkins specified in vehicle class
            for (i = 0; i < V.CannonSkins.Length; ++i)
            {
                if (V.CannonSkins[i] != none)
                {
                    Skins[i] = V.CannonSkins[i];
                }
            }

            // If vehicle is burning, start the turret hatch fire effect
            if (V.IsA('DHArmoredVehicle') && DHArmoredVehicle(V).bOnFire)
            {
                StartTurretFire();
            }
        }
    }

    // If we also have the VehicleWeaponPawn actor, initialize anything we need to do where we need both actors
    if (CannonPawn != none && !bInitializedVehicleAndWeaponPawn)
    {
        InitializeVehicleAndWeaponPawn();
    }
}

// New function to do any set up that requires both the 'Base' & 'CannonPawn' references to the Vehicle & VehicleWeaponPawn actors
// Currently unused but putting it in for consistency & for future usage, including option to easily subclass for any vehicle-specific set up
simulated function InitializeVehicleAndWeaponPawn()
{
    bInitializedVehicleAndWeaponPawn = true;
}

// Modified to use optional AltFireSpawnOffsetX for coaxial MG fire, instead of irrelevant WeaponFireOffset for cannon
// Also removes redundant dual fire stuff
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Get bone co-ordinates on which to to base fire location
    WeaponBoneCoords = GetBoneCoords(WeaponFireAttachmentBone);

    // Calculate fire position offset
    if (bWasAltFire)
    {
        CurrentFireOffset = AltFireOffset + (AltFireSpawnOffsetX * vect(1.0, 0.0, 0.0));
    }
    else
    {
        CurrentFireOffset = WeaponFireOffset * vect(1.0, 0.0, 0.0);
    }

    // Calculate rotation of the cannon's aim
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);

    // Calculate exact fire location
    WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);
}

// Modified to ignore yaw restrictions for commander's periscope of binoculars positions (where bLimitYaw is true, e.g. casemate-style tank destroyers)
// Also to enforce use of rotation relative to vehicle (bPCRelativeFPRotation), to use yaw limits from DriverPositions in a multi position cannon,
// & so we don't limit view yaw if in behind view
simulated function int LimitYaw(int yaw)
{
    local int CurrentPosition;

    // TODO: Matt - this is confusing 2 different things: limit on cannon's yaw & limit on player's view yaw
    // bLimitYaw is used by native code to limit (or not) cannon's turning, which ignores anything that happens in this function
    // This function is best thought of as LimitViewYaw() & would be better placed in the cannon pawn class (but needs to stay as is because it is called by UpdateRotation() in PC class)
    // bLimitYaw should not be used here - the view yaw limits should be based on ViewNegativeYawLimit & ViewPositiveYawLimit in DriverPositions
    if (!bLimitYaw || (Instigator != none && Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bBehindView))
    {
        return yaw;
    }

    if (CannonPawn != none && CannonPawn.DriverPositions.Length > 0)
    {
        CurrentPosition = CannonPawn.DriverPositionIndex;

        if (CurrentPosition >= CannonPawn.PeriscopePositionIndex)
        {
            return yaw;
        }

        return Clamp(yaw, CannonPawn.DriverPositions[CurrentPosition].ViewNegativeYawLimit, CannonPawn.DriverPositions[CurrentPosition].ViewPositiveYawLimit);
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

// New function to start a turret hatch fire effect - all fires now triggered from vehicle base, so don't need cannon's Tick() constantly checking for a fire
simulated function StartTurretFire()
{
    if (TurretHatchFireEffect == none && Level.NetMode != NM_DedicatedServer)
    {
        TurretHatchFireEffect = Spawn(FireEffectClass);
    }

    if (TurretHatchFireEffect != none)
    {
        AttachToBone(TurretHatchFireEffect, FireAttachBone);
        TurretHatchFireEffect.SetRelativeLocation(FireEffectOffset);
        TurretHatchFireEffect.UpdateDamagedEffect(true, 0.0, false, false);

        if (FireEffectScale != 1.0)
        {
            TurretHatchFireEffect.SetEffectScale(FireEffectScale);
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing cannon firing effects to be skipped
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

    // Net clients
    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant for other net clients if cannon has not been drawn on their screen recently
        if (SpawnLocation == Location)
        {
            if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
            {
                return false;
            }
        }
        else if (Instigator == none || (Level.TimeSeconds - Instigator.LastRenderTime) >= 3.0)
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
    super.DestroyEffects();

    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.Destroy(); // not actually an effect, but convenient to add here
    }

    if (TurretHatchFireEffect != none)
    {
        TurretHatchFireEffect.Kill();
    }

    if (CannonDustEmitter != none)
    {
        CannonDustEmitter.Destroy();
    }
}

defaultproperties
{
    // Key properties
    bForceSkelUpdate=true // Matt: necessary for new player hit detection system, as makes server update the cannon mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    bNetNotify=true       // necessary to do set up requiring the 'Base' actor reference to the cannon's vehicle base
    bHasTurret=true

    // Collision
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    // Animation
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_attachment"
    TankShootClosedAnim="shoot_close"
    TankShootOpenAnim="shoot_open"

    // Turret/cannon movement
    bUseTankTurretRotation=true
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000

    // Cannon ammo
    bMultipleRoundTypes=true
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"
    bUsesSecondarySpread=true
    bUsesTertiarySpread=true

    // Coaxial MG ammo
    AltFireInterval=0.12 // just a fallback default
    AltFireSpread=0.002
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    bUsesTracers=true
    bAltFireTracersOnly=true

    // Weapon fire
    bClientCanFireCannon=false
    CannonReloadState=CR_Waiting
    bPrimaryIgnoreFireCountdown=true
    WeaponFireAttachmentBone="Barrel"
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    CannonDustEmitterClass=class'ROEffects.TankCannonDust'
    FireForce="Explosion05"
    bAmbientEmitterAltFireOnly=true
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bShowAimCrosshair=false
    AIInfo(0)=(AimError=0.0,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,AimError=750.0,RefireRate=0.99,WarnTargetPct=0.9)

    // Sounds
    bAmbientAltFireSound=true
    AltFireSoundScaling=3.0
    NoMGAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    SoundVolume=130
    FireSoundVolume=512.0
    SoundRadius=200.0
    FireSoundRadius=4000.0
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750.0

    // Screen shake
    ShakeRotMag=(X=0.0,Y=0.0,Z=50.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=1.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=1.0,Y=1.0,Z=1.0)
    AltShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0

    // Turret hatch fire
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    FireAttachBone="com_player"
    FireEffectScale=1.0
}
