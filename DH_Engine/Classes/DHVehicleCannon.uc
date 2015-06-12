//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleCannon extends ROTankCannon
    abstract;

#exec OBJ LOAD FILE=..\sounds\DH_Vehicle_Reloads.uax

// General
var     DHVehicleCannonPawn CannonPawn;               // just a reference to the DH cannon pawn actor, for convenience & to avoid lots of casts
var     bool                bHasTurret;               // this cannon is in a fully rotating turret
var     float               MinCommanderHitHeight;    // minimum height above which projectile must have hit commander's collision box (hit location offset, relative to mesh origin)

// Ammo (with variables for up to three cannon ammo types, including shot dispersion customized by round type)
var     byte                MainAmmoChargeExtra[3];   // using byte for more efficient replication
var     int                 InitialTertiaryAmmo;
var     class<Projectile>   TertiaryProjectileClass;
var     bool                bUsesSecondarySpread;
var     float               SecondarySpread;
var     bool                bUsesTertiarySpread;
var     float               TertiarySpread;
var     class<Projectile>   AltTracerProjectileClass; // replaces DummyTracerClass as tracer is now a real bullet that damages, not just client-only effect (old name was misleading)
var     byte                AltFireTracerFrequency;   // how often a tracer is loaded in (as in: 1 in the value of AltFireTracerFrequency)
var     sound               NoMGAmmoSound;            // 'dry fire' sound when trying to fire empty coaxial MG
var     bool                bCanisterIsFiring;        // canister is spawning separate projectiles - until done it stops firing effects playing or switch to different round type

// Armor penetration
var     float               FrontArmorFactor, RightArmorFactor, LeftArmorFactor, RearArmorFactor;
var     float               FrontArmorSlope, RightArmorSlope, LeftArmorSlope, RearArmorSlope;
var     float               FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;
var     float               GunMantletArmorFactor;    // used for mantlet hits for casemate-style vehicles without a turret
var     float               GunMantletSlope;
var     bool                bHasAddedSideArmor;       // has side skirts that will make a hit by a HEAT projectile ineffective

// Manual/powered turret
var     float               ManualRotationsPerSecond;
var     float               PoweredRotationsPerSecond;

// Turret collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon, like a tank turret)
var     class<DHVehicleWeaponCollisionMeshActor> CollisionMeshActorClass; // specify a valid class in default props & the col static mesh will automatically be used
var     DHVehicleWeaponCollisionMeshActor        CollisionMeshActor;

// Fire effects - Ch!cKeN
var     VehicleDamagedEffect        TurretHatchFireEffect;
var     class<VehicleDamagedEffect> FireEffectClass;
var     name                        FireAttachBone;
var     vector                      FireEffectOffset;
var     float                       FireEffectScale;

// Debugging and calibration
var     bool                bDrawPenetration;
var     bool                bDebuggingText;
var     bool                bPenetrationText;
var     bool                bLogPenetration;
var     bool                bDriverDebugging;
var     config bool         bGunFireDebug;
var     config bool         bGunsightSettingMode;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        MainAmmoChargeExtra;

    // Variables the server will replicate to all clients
//  reliable if (bNetDirty && Role == ROLE_Authority)
//      bManualTurret, bOnFire; // Matt: removed these variables
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to fix minor bug where 1st key press to switch round type key didn't do anything
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && bMultipleRoundTypes)
    {
        PendingProjectileClass = PrimaryProjectileClass;
    }
}

// Matt: modified to handle new collision static mesh actor, if one has been specified
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (CollisionMeshActorClass != none)
    {
        CollisionMeshActor = Spawn(CollisionMeshActorClass, self); // vital that this VehicleWeapon owns the col mesh actor

        if (CollisionMeshActor != none)
        {
            // Remove all collision from this VehicleWeapon class (instead let col mesh actor handle collision detection)
            SetCollision(false, false); // bCollideActors & bBlockActors both false
            bBlockNonZeroExtentTraces = false;
            bBlockZeroExtentTraces = false;

            // Attach col mesh actor to our yaw bone, so the col mesh will rotate with the turret
            CollisionMeshActor.bHardAttach = true;
            AttachToBone(CollisionMeshActor, YawBone);

            // The col mesh actor will be positioned on the yaw bone, so we want to reposition it to align with the turret
            CollisionMeshActor.SetRelativeLocation(Location - GetBoneCoords(YawBone).Origin);
        }
    }
}

// Matt: new function to do any extra set up in the cannon classes (called from cannon pawn) - can be subclassed to do any vehicle specific setup
// Crucially, we know that we have CannonPawn & its VehicleBase when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeCannon(DHVehicleCannonPawn CannonPwn)
{
    if (CannonPwn != none)
    {
        CannonPawn = CannonPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(CannonPawn);
            Instigator = CannonPawn;
        }

        if (DHArmoredVehicle(CannonPawn.VehicleBase) != none)
        {
            // Set the vehicle's CannonTurret reference - normally only used clientside in HUD, but can be useful elsewhere, including on server
            DHArmoredVehicle(CannonPawn.VehicleBase).CannonTurret = self;

            // If vehicle is burning, start the turret hatch fire effect
            if (DHArmoredVehicle(CannonPawn.VehicleBase).bOnFire && Level.NetMode != NM_DedicatedServer)
            {
                StartTurretFire();
            }
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHVehicleCannonPawn, so lots of things are not going to work!");
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

// Modified to simplify a little, including call PlayOwnedSound for all modes, as calling that on client just plays sound locally, same as PlaySound would do
// Also to postpone reload if cannon is out of ammo & to sharply reduce frequency of repeat timer if reload can't proceed for now
simulated function Timer()
{
    // Do not proceed with reload if no player in cannon position or if cannon has no ammo - set a repeating timer to keep checking (but reduced from 20 times a second !)
    if (CannonPawn == none || CannonPawn.Controller == none || PrimaryAmmoCount() < 1)
    {
        SetTimer(0.5, true);
    }
    else if (CannonReloadState == CR_Empty)
    {
        PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart1;
        SetTimer(GetSoundDuration(ReloadSoundOne), false);
    }
    else if (CannonReloadState == CR_ReloadedPart1)
    {
        PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart2;
        SetTimer(GetSoundDuration(ReloadSoundTwo), false);
    }
    else if (CannonReloadState == CR_ReloadedPart2)
    {
        PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart3;
        SetTimer(GetSoundDuration(ReloadSoundThree), false);
    }
    else if (CannonReloadState == CR_ReloadedPart3)
    {
        PlayOwnedSound(ReloadSoundFour, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart4;
        SetTimer(GetSoundDuration(ReloadSoundFour), false);
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
                        ProjectileSpread = 0.0015; // 40% chance of SecondaryProjectileClass using literal value for spread instead of shell's SecondarySpread // Matt: why? // TEST
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

            // Now apply any random spread
            if (ProjectileSpread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * ProjectileSpread);

                if (!bAltFire)
                {
                    WeaponFireRotation += rot(1, 6, 0);
                }
            }
        }

        Instigator.MakeNoise(1.0);

        // Coaxial MG fire - check we have ammo & fire the MG
        if (bAltFire)
        {
            // If MG is empty we can't fire - start a reload
            if (!ConsumeAmmo(3))
            {
                CannonPawn.ClientVehicleCeaseFire(bAltFire);
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
                Log(Tag @ "AttemptFire returning false as ConsumeAmmo returned false (no ammo): FireMode =" @ FireMode); // DEBUG
                CannonPawn.ClientVehicleCeaseFire(bAltFire);

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
                        ToggleRoundType();
                    }

                    ProjectileClass = PendingProjectileClass;
                }

                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }
        }

        return true;
    }
    else if (!bAltFire && Role == ROLE_Authority) Log(Tag @ "AttemptFire returning false: CannonReloadState =" @ GetEnum(enum'ECannonReloadState', CannonReloadState)
        @ " bClientCanFireCannon =" @ bClientCanFireCannon); // DEBUG

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

    // Matt: modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
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

        if (CannonPawn != none && CannonPawn.VehicleBase != none)
        {
            if (!CannonPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation,
                WeaponFireLocation + vector(WeaponFireRotation) * (CannonPawn.VehicleBase.CollisionRadius * 1.5), Extent))
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
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

        // Play firing effects (unless it's canister in the process of spawning separate projectiles - only do it once at the end)
        if (!bCanisterIsFiring)
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
                    PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
                }
            }
        }
    }

    return P;
}

// Modified to remove the call to UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
// Also to avoid playing unnecessary shoot animations on a server
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

        if (EffectEmitterClass != none && EffectIsRelevant(Location, false))
        {
            EffectEmitter = Spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);
        }

        if (CannonDustEmitterClass != none && EffectIsRelevant(Location, false))
        {
            CannonDustEmitter = Spawn(CannonDustEmitterClass, self,, Base.Location, Base.Rotation);
        }

        if (CannonPawn != none && CannonPawn.DriverPositions[CannonPawn.DriverPositionIndex].bExposed)
        {
            if (HasAnim(TankShootOpenAnim))
            {
                PlayAnim(TankShootOpenAnim);
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

// Modified to stop 'phantom' coaxial MG firing effects (muzzle flash & tracers) from continuing if player has moved to ineligible firing position while holding down fire button
// Also to enable MG muzzle flash when hosting a listen server, which the original code misses out
simulated function OwnerEffects()
{
    if (Role < ROLE_Authority && bIsAltFire && CannonPawn != none && !CannonPawn.CanFire())
    {
        CannonPawn.ClientVehicleCeaseFire(bIsAltFire); // stops MG flash & tracers

        return;
    }

    super.OwnerEffects();

    if (Level.NetMode == NM_ListenServer && bIsAltFire && AmbientEffectEmitter != none) // to get MG muzzle flash on listen server
    {
        AmbientEffectEmitter.SetEmitterStatus(true);
    }
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
    super(ROVehicleWeapon).CeaseFire(C, bWasAltFire);

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

    AddedPitch += 2;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue+Correction @ "       correction =" @ Correction);
    }
}

function DecreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch -= 2;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue+Correction @ "       correction =" @ Correction);
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
        if (!HasAmmo(3) && Instigator.Controller != none && Role == ROLE_Authority)
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

// Modified to optimise slightly
simulated function bool ReadyToFire(bool bAltFire)
{
    local int Mode;

    if (bAltFire)
    {
        Mode = 3;
    }
    else
    {
        if (CannonReloadState != CR_ReadyToFire || !bClientCanFireCannon)
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
function ToggleRoundType()
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
        if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
        else if (HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
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
simulated function ClientSetReloadState(ECannonReloadState NewState)
{
    if (Role < ROLE_Authority)
    {
        CannonReloadState = NewState;

        if (CannonReloadState != CR_Waiting  && CannonReloadState != CR_ReadyToFire)
        {
            SetTimer(0.01, false);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************  HIT DETECTION, PENETRATION & DAMAGE  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

simulated function bool HitDriverArea(vector HitLocation, vector Momentum) // Matt: DEBUG
{
    log("HitDriverArea() called on" @ Tag @ " SHOULD NOT HAPPEN NOW !!!");
    return false;
}

simulated function bool HitDriver(vector HitLocation, vector Momentum) // Matt: DEBUG
{
    log("HitDriver() called on" @ Tag @ " SHOULD NOT HAPPEN NOW !!!");
    return false;
}

// Matt: new generic function to handle 'should penetrate' calcs for any shell type
// Replaces DHShouldPenetrateAPC, DHShouldPenetrateAPDS, DHShouldPenetrateHVAP, DHShouldPenetrateHVAPLarge, DHShouldPenetrateHEAT (also DO's DHShouldPenetrateAP & DHShouldPenetrateAPBC)
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
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
    HitDir =  HitLocation - Location;
    HitDir.Z = 0.0;
    HitAngleDegrees = (Acos(Normal(LocDir) dot Normal(HitDir))) * 57.2957795131; // final multiplier converts the angle into degrees from radians
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
        InAngleDegrees = InAngle * 57.2957795131;

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
        InAngleDegrees = InAngle * 57.2957795131;

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
        InAngleDegrees = InAngle * 57.2957795131;

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
        InAngleDegrees = InAngle * 57.2957795131;

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
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

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

// Returns the compound hit angle
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    local float ArmorSlope, CompoundAngle;

//  AOI = Abs(AOI * 0.01745329252); // we now pass AOI to this function in radians, to save unnecessary processing to & from degrees
    ArmorSlope = Abs(ArmorSlopeDegrees * 0.01745329252); // convert the angle degrees to radians
    CompoundAngle = Acos(Cos(ArmorSlope) * Cos(AOI));

    return CompoundAngle;
}

// Matt: new generic function to work with generic DHShouldPenetrate & CheckPenetration functions
simulated function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float CompoundAngleDegrees, optional float OverMatchFactor)
{
    local float CompoundExp, CompoundAngleFixed;
    local float RoundedDownAngleDegrees, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, SlopeMultiplierGap;

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
        CompoundAngleFixed = Abs(CompoundAngleDegrees * 0.01745329252); // convert angle back to radians

        return 1.0 / Cos(CompoundAngleFixed);
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (CompoundAngleDegrees < 10.0)
        {
            return CompoundAngleDegrees / 10.0 * ArmorSlopeTable(P, 10.0, OverMatchFactor);
        }
        else
        {
            RoundedDownAngleDegrees = Float(Int(CompoundAngleDegrees / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            ExtraAngleDegrees = CompoundAngleDegrees - RoundedDownAngleDegrees;
            BaseSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees, OverMatchFactor);
            NextSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees + 5.0, OverMatchFactor);
            SlopeMultiplierGap = NextSlopeMultiplier - BaseSlopeMultiplier;

            return BaseSlopeMultiplier + (ExtraAngleDegrees / 5.0 * SlopeMultiplierGap);
        }
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new GetArmorSlopeMultiplier for APC shells (also handles Darkest Orchestra's AP & APBC shells)
simulated function float ArmorSlopeTable(DHAntiVehicleProjectile P, float CompoundAngleDegrees, float OverMatchFactor)
{
    // after Bird & Livingston:
    if (P.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 0.98  * (OverMatchFactor ** 0.0637); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.0  * (OverMatchFactor ** 0.0969);
        else if (CompoundAngleDegrees <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (CompoundAngleDegrees <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (CompoundAngleDegrees <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (CompoundAngleDegrees <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (CompoundAngleDegrees <= 45.0)  return 2.0  * (OverMatchFactor ** 0.34717);
        else if (CompoundAngleDegrees <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (CompoundAngleDegrees <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (CompoundAngleDegrees <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (CompoundAngleDegrees <= 65.0)  return 6.27  * (OverMatchFactor ** 0.9192);
        else if (CompoundAngleDegrees <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (CompoundAngleDegrees <= 75.0)  return 13.75 * (OverMatchFactor ** 1.074);
        else if (CompoundAngleDegrees <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                    return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.04 * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.06 * (OverMatchFactor ** 0.02315);
        else if (CompoundAngleDegrees <= 20.0)  return 1.08 * (OverMatchFactor ** 0.03448);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11 * (OverMatchFactor ** 0.05134);
        else if (CompoundAngleDegrees <= 30.0)  return 1.16 * (OverMatchFactor ** 0.0771);
        else if (CompoundAngleDegrees <= 35.0)  return 1.22 * (OverMatchFactor ** 0.11384);
        else if (CompoundAngleDegrees <= 40.0)  return 1.31 * (OverMatchFactor ** 0.16952);
        else if (CompoundAngleDegrees <= 45.0)  return 1.44 * (OverMatchFactor ** 0.24604);
        else if (CompoundAngleDegrees <= 50.0)  return 1.68 * (OverMatchFactor ** 0.3791);
        else if (CompoundAngleDegrees <= 55.0)  return 2.11 * (OverMatchFactor ** 0.56444);
        else if (CompoundAngleDegrees <= 60.0)  return 3.5 * (OverMatchFactor ** 1.07411);
        else if (CompoundAngleDegrees <= 65.0)  return 5.34 * (OverMatchFactor ** 1.46188);
        else if (CompoundAngleDegrees <= 70.0)  return 9.48 * (OverMatchFactor ** 1.8152);
        else if (CompoundAngleDegrees <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (CompoundAngleDegrees <= 80.0)  return 56.2 * (OverMatchFactor ** 2.5621);
        else                                    return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (CompoundAngleDegrees <= 20.0)  return 1.1  * (OverMatchFactor ** 0.0454);
        else if (CompoundAngleDegrees <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (CompoundAngleDegrees <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (CompoundAngleDegrees <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (CompoundAngleDegrees <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (CompoundAngleDegrees <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (CompoundAngleDegrees <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (CompoundAngleDegrees <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (CompoundAngleDegrees <= 60.0)  return 2.56  * (OverMatchFactor ** 0.245);
        else if (CompoundAngleDegrees <= 65.0)  return 3.2  * (OverMatchFactor ** 0.3354);
        else if (CompoundAngleDegrees <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (CompoundAngleDegrees <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (CompoundAngleDegrees <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                    return 11.32 * (OverMatchFactor ** 0.455); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new CheckPenetration function - checks if the round should shatter, based on the 'shatter gap' for different round types
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
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        CannonPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        CannonPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    // Shell's ProcessTouch now calls TD here, but for tank cannon this is counted as hit on vehicle itself, so we call TD on that
    else if (CannonPawn != none && CannonPawn.VehicleBase != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            CannonPawn.VehicleBase.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        CannonPawn.VehicleBase.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
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
        L.AddPrecacheMaterial(default.Skins[i]);
    }

    super.StaticPrecache(L);

    L.AddPrecacheMaterial(default.hudAltAmmoIcon);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

}

// Modified to add extra material properties (note the Super in Actor already pre-caches the Skins array)
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(hudAltAmmoIcon);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }
}

// Modified to add TertiaryProjectileClass
simulated function UpdatePrecacheStaticMeshes()
{
    if (TertiaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    }

    super.UpdatePrecacheStaticMeshes();
}

// Modified to ignore yaw restrictions for commander's periscope of binoculars positions (where bLimitYaw is true, e.g. casemate-style tank destroyers)
// Also to enforce use of rotation relative to vehicle (bPCRelativeFPRotation) & to use yaw limits from DriverPositions in a multi position cannon
simulated function int LimitYaw(int yaw)
{
    local int CurrentPosition;

    // Matt: this is confusing 2 different things: limit on cannon's yaw & limit on player's view yaw
    // bLimitYaw is used by native code to limit (or not) cannon's turning, which ignores anything that happens in this function
    // This function is best thought of as LimitViewYaw() & would be better placed in the cannon pawn class (but needs to stay as is because it is called by UpdateRotation() in PC class)
    // bLimitYaw should not be used here - the view yaw limits should be based on ViewNegativeYawLimit & ViewPositiveYawLimit in DriverPositions
    if (!bLimitYaw)
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
}

defaultproperties
{
    bForceSkelUpdate=true // Matt: necessary for new player hit detection system, as makes server update the cannon mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    bHasTurret=true
    bUsesSecondarySpread=true
    bUsesTertiarySpread=true
    AltFireSpread=0.002
    ManualRotationsPerSecond=0.011111
    CannonReloadState=CR_Waiting
    NoMGAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireAttachBone="com_player"
    FireEffectOffset=(Z=-20.0)
    FireEffectScale=1.0
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
}
