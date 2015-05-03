//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMountedTankMG extends ROMountedTankMG
    abstract;

var  DHMountedTankMGPawn  MGPawn;     // just a reference to the DH MG pawn actor, for convenience & to avoid lots of casts

var()   class<Projectile>    TracerProjectileClass; // replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so old name was misleading
var()   byte    TracerFrequency;      // how often a tracer is loaded in (as in: 1 in the value of TracerFrequency)
var     byte    NumMags;              // number of mags carried for this MG // Matt: changed from int to byte for more efficient replication
var     sound   NoAmmoSound;          // 'dry fire' sound when trying to fire empty MG

// Reload stuff
var     bool    bReloading;           // this MG is currently reloading
var()   sound   ReloadSound;          // sound of this MG reloading
var     float   ReloadDuration;       // time duration of reload (set automatically)
var     float   ReloadStartTime;      // records the level time the reload started, which can be used to determine reload progress on the HUD ammo indicator
var()   name    HUDOverlayReloadAnim; // reload animation to play if the MG uses a HUDOverlay

// Player hit detection
var     bool    bHasGunShield;        // this MG has a gunshield that may protect the player
var     float   MaxPlayerHitX;        // maximum distance along X-axis where a projectile must have hit player's collision box (hit location offset, relative to mesh origin)
var     bool    bDriverDebugging;     // screen & log messages to debug player/gunshield hit detection

// MG collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon)
var class<DHVehicleWeaponCollisionMeshActor> CollisionMeshActorClass; // specify a valid class in default props & the col static mesh will automatically be used
var DHVehicleWeaponCollisionMeshActor        CollisionMeshActor;

// Stuff for fire effects - Ch!cKeN
var     VehicleDamagedEffect        HullMGFireEffect;
var     class<VehicleDamagedEffect> FireEffectClass;
var()   name                        FireAttachBone;
var()   vector                      FireEffectOffset;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        bReloading, NumMags;

    // Variables the server will replicate to all clients
//  reliable if (bNetDirty && Role == ROLE_Authority)
//      bOnFire; // Matt: removed as have deprecated

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientHandleReload;
}

// Matt: modified to handle new collision static mesh actor, if one has been specified
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Just so the client's MGPawn doesn't have to do this many times per second to display reload progress on the HUD
    // This will be ignored if MG has a HUDOverlay with a reload animation, as a literal ReloadDuration value will have to be set in default properties
    if (ReloadDuration <= 0.0 && ReloadSound != none)
    {
        ReloadDuration = GetSoundDuration(ReloadSound);
    }

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

            // The col mesh actor will be positioned on the yaw bone, so we want to reposition it to align with the MG
            SetRelativeLocation(Location - GetBoneCoords(YawBone).Origin);
        }
    }
}

// Matt: new function to do any extra set up in the MG classes (called from MG pawn) - can be subclassed to do any vehicle specific setup
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMG(DHMountedTankMGPawn MGPwn)
{
    if (MGPwn != none)
    {
        MGPawn = MGPwn;

        if (Role < ROLE_Authority)
        {
            SetOwner(MGPawn);
            Instigator = MGPawn;
        }

        if (DHTreadCraft(MGPawn.VehicleBase) != none)
        {
            // Set the vehicle's HullMG reference - normally unused but can be useful
            DHTreadCraft(MGPawn.VehicleBase).HullMG = self;

            // If vehicle is burning, start the MG hatch fire effect
            if (DHTreadCraft(MGPawn.VehicleBase).bOnFire && Level.NetMode != NM_DedicatedServer)
            {
                StartMGFire();
            }
        }
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHMountedTankMGPawn, so lots of things are not going to work!");
    }
}

// Matt: no longer use Tick, as MG hatch fire effect is now triggered on net client from VehicleBase's PostNetReceive()
// Let's disable Tick altogether to save unnecessary processing
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
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

// Modified to return false if MG reloading
simulated function bool ReadyToFire(bool bAltFire)
{
    if (bReloading)
    {
        return false;
    }

    return super.ReadyToFire(bAltFire);
}

// Modified to start a reload when empty
function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (!bReloading && !HasAmmo(0))
    {
        HandleReload();
    }
}

// Matt: modified to generic function handling HUDOverlay reloads as well as normal reloads, including making client record ReloadStartTime (used for reload progress on HUD ammo icon)
function HandleReload()
{
    if (NumMags > 0 && !bReloading)
    {
        bReloading = true;
        NumMags--;
        NetUpdateTime = Level.TimeSeconds - 1.0;
        ReloadStartTime = Level.TimeSeconds;
        ClientHandleReload();

        if (MGPawn == none || MGPawn.HUDOverlay == none || !HasAnim(HUDOverlayReloadAnim)) // don't play sound if there's a HUDOverlay with reload animation, as it plays its own sounds
        {
            PlaySound(ReloadSound, SLOT_None, 1.5,, 25.0,, true);
        }

        SetTimer(ReloadDuration, false);
    }
}

// New server-to-client function called at start of reload or if player enters an MG that is reloading
// Client records when reload started, which is used to show reload progress on HUD ammo icon (replication optimised to a byte instead of passing start time as float)
// Also plays any HUDOverlay reload animation, starting it from the appropriate point if a reload is already in progress
simulated function ClientHandleReload(optional byte PercentageDone)
{
    ReloadStartTime = Level.TimeSeconds - (Float(PercentageDone) / 100.0 * ReloadDuration);

    if (MGPawn != none && MGPawn.HUDOverlay != none && MGPawn.HUDOverlay.HasAnim(HUDOverlayReloadAnim))
    {
        MGPawn.HUDOverlay.PlayAnim(HUDOverlayReloadAnim);
        MGPawn.HUDOverlay.SetAnimFrame(Float(PercentageDone)); // move reload animation to appropriate point
    }
}

// Timer used to reload the MG, after the set reload duration
simulated function Timer()
{
    if (bReloading && Role == ROLE_Authority)
    {
        bReloading = false;
        MainAmmoCharge[0] = InitialPrimaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;
    }
}

// Modified to call HandleReload when empty
event bool AttemptFire(Controller C, bool bAltFire)
{
    if (Role != ROLE_Authority || bForceCenterAim)
    {
        return false;
    }

    if (FireCountdown <= 0.0)
    {
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        if (bAltFire)
        {
            if (AltFireSpread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * AltFireSpread);
            }
        }
        else if (Spread > 0.0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * Spread);
        }

        DualFireOffset *= -1.0;

        Instigator.MakeNoise(1.0);

        if (bAltFire)
        {
            if (!ConsumeAmmo(2))
            {
                MGPawn.ClientVehicleCeaseFire(bAltFire);

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
                        MGPawn.ClientVehicleCeaseFire(bAltFire);

                        return false;
                    }
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        MGPawn.ClientVehicleCeaseFire(bAltFire);

                        return false;
                    }
                }
            }
            else if (!ConsumeAmmo(0))
            {
                MGPawn.ClientVehicleCeaseFire(bAltFire);
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

// Modified to stop 'phantom' firing effects (muzzle flash & tracers) from continuing if player has moved to an ineligible firing position while holding fire button down
// Also to enable muzzle flash when hosting a listen server, which the original code misses out
simulated function OwnerEffects()
{
    if (Role < ROLE_Authority && !MGPawn.CanFire())
    {
        MGPawn.ClientVehicleCeaseFire(bIsAltFire); // stops flash & tracers if player unbuttons while holding down fire

        return;
    }

    super.OwnerEffects();

    if (Level.NetMode == NM_ListenServer && AmbientEffectEmitter != none) // added so we get muzzle flash when hosting a listen server
    {
        AmbientEffectEmitter.SetEmitterStatus(true);
    }
}

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

// Modified to use DH's new incremental resupply system
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

// Modified to handle MG magazines
simulated function int GetNumMags()
{
    return NumMags;
}

// Modified to make into a generic function to handle single & multi position MGs, without need for overrides in subclasses, & to optimise
simulated function int LimitYaw(int yaw)
{
    local int VehYaw;

    if (!bLimitYaw)
    {
        return yaw;
    }

    if (MGPawn != none)
    {
        // For multi-position MGs, we use the view yaw limits in the MG pawn's DriverPositions
        if (MGPawn.bMultiPosition)
        {
            return Clamp(yaw, MGPawn.DriverPositions[MGPawn.DriverPositionIndex].ViewNegativeYawLimit, MGPawn.DriverPositions[MGPawn.DriverPositionIndex].ViewPositiveYawLimit);
        }
        // Or for single position MGs we use our max/min yaw values from the MG weapon class
        else if (MGPawn.VehicleBase != none)
        {
            VehYaw = MGPawn.VehicleBase.Rotation.Yaw;

            return Clamp(yaw, VehYaw + MaxNegativeYaw, VehYaw + MaxPositiveYaw);
        }
    }

    // Just a fallback
    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

// Matt: modified to avoid calling TakeDamage on Driver, as shell & bullet's ProcessTouch now call it directly on the Driver if he was hit
// Note that shell's ProcessTouch also now calls TD() on VehicleWeapon instead of VehicleBase
// For a vehicle MG this is not counted as a hit on vehicle itself, but we could add any desired functionality here or in subclasses, e.g. shell could wreck MG
// Note that if calling a damage function & DamageType.bDelayedDamage, we need to call SetDelayedDamageInstigatorController(InstigatedBy.Controller) on the relevant pawn
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        MGPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        MGPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

// Matt: slightly different concept to work more accurately & simply with projectiles: think of this function as asking "did we hit the player's collision box?"
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    local vector HitOffset;

    // If MG has no gunshield then we can only have hit the player's collision box
    if (!bHasGunShield)
    {
        return true;
    }

    HitOffset = (Hitlocation - Location) << Rotation; // hit offset in local space (after actor's 3D rotation applied)

    // We must have hit the player's collision box (HitOffset.X is how far the HitLocation is in front of the mesh origin)
    if (HitOffset.X <= MaxPlayerHitX)
    {
        if (bDriverDebugging)
        {
            Log("HitOffset.X =" @ HitOffset.X @ "MaxPlayerHitX =" @ MaxPlayerHitX @ " Assume hit player's collision box");

            if (Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HitOffset.X =" @ HitOffset.X @ "MaxPlayerHitX =" @ MaxPlayerHitX @ " Assume hit player's collision box");
            }
        }

        return true;
    }
    // We can't have hit the player so we must have hit the MG itself (or some other collision box)
    else
    {
        if (bDriverDebugging)
        {
            Log("HitOffset.X =" @ HitOffset.X @ "MaxPlayerHitX =" @ MaxPlayerHitX @ " Must have missed player's collision box");

            if (Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HitOffset.X =" @ HitOffset.X @ "MaxPlayerHitX =" @ MaxPlayerHitX @ " Must have missed player's collision box");
            }
        }

        return false;
    }
}

// Matt: slightly different concept to work more accurately & simply with projectiles
// Think of this function as asking "is there an exposed player there & did we actually hit him, not just his collision box?"
simulated function bool HitDriver(vector Hitlocation, vector Momentum)
{
    // Player is present & is not buttoned up & we hit his collision box & hit one of the hit points representing his head or torso
    if (MGPawn != none && MGPawn.Driver != none && MGPawn.DriverPositions[MGPawn.DriverPositionIndex].bExposed &&
        IsPointShot(HitLocation, Normal(Momentum), 1.0, 0) || IsPointShot(HitLocation, Normal(Momentum), 1.0, 1))
    {
        return true;
    }

    return false;
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

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties (note the Supers are empty)
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.Skins.Length; ++i)
    {
        L.AddPrecacheMaterial(default.Skins[i]);
    }

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

defaultproperties
{
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    FireAttachBone="mg_pitch"
    FireEffectOffset=(X=10.0,Y=0.0,Z=5.0)
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    YawStartConstraint=0 // Matt: revert to defaults from VehicleWeapon, as MGs such as the StuH don't work with the values from ROMountedTankMG
    YawEndConstraint=65535
}
