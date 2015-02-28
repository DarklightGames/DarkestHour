//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ROMountedTankMG extends ROMountedTankMG
    abstract;

var()   class<Projectile>   TracerProjectileClass; // Matt: replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so the old name was misleading
var()   int                 TracerFrequency;       // how often a tracer is loaded in (as in: 1 in the value of TracerFrequency)
 
// Reload stuff
var     bool    bReloading;      // this MG is currently reloading
var()   sound   ReloadSound;     // sound of this MG reloading
var     float   ReloadDuration;  // time duration of reload (set automatically)
var     float   ReloadStartTime; // records the level time the reload started, which can be used to determine reload progress on the HUD ammo indicator
var     byte    NumMags;         // number of mags carried for this MG // Matt: changed from int to byte for more efficient replication

// MG collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon)
var class<DH_VehicleWeaponCollisionMeshActor> CollisionMeshActorClass; // specify a valid class in default props & the col static mesh will automatically be used
var DH_VehicleWeaponCollisionMeshActor        CollisionMeshActor;

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
        ClientSetReloadStartTime;
}

// Matt: modified to handle new collision static mesh actor, if one has been specified
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ReloadDuration = GetSoundDuration(ReloadSound); // just so the client's MGPawn doesn't have to do this many times per second to display reload progress on the HUD

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

            // Attach col mesh actor to our yaw bone, so the col mesh will rotate with the MG
            AttachToBone(CollisionMeshActor, YawBone);

            // The col mesh actor will be positioned on the yaw bone, so we want to reposition it to align with the MG
            SetRelativeLocation(Location - GetBoneCoords(YawBone).Origin);
        }
    }
}

// Matt: new function to do any extra set up in the MG classes (called from MG pawn) - can be subclassed to do any vehicle specific setup
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMG(DH_ROMountedTankMGPawn MGPwn)
{
    if (MGPwn != none)
    {
        // On client, MG pawn is destroyed if becomes net irrelevant - when it respawns, these values need to be set again or will cause lots of errors
        if (Role < ROLE_Authority)
        {
            SetOwner(MGPwn);
            Instigator = MGPwn;
        }

        if (DH_ROTreadCraft(MGPwn.VehicleBase) != none)
        {
            // Set the vehicle's HullMG reference - normally unused but can be useful
            DH_ROTreadCraft(MGPwn.VehicleBase).HullMG = self;

            // If vehicle is burning, start the MG hatch fire effect
            if (DH_ROTreadCraft(MGPwn.VehicleBase).bOnFire && Level.NetMode != NM_DedicatedServer)
            {
                StartMGFire();
            }
        }
    }
}

// Matt: no longer use Tick, as MG hatch fire effect is now triggered on net client from VehicleBase's PostNetReceive()
// Let's disable Tick altogether to save unnecessary processing
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Matt: new function to start an MG hatch fire effect - all fires now triggered from vehicle base, so don't need MG's Tick() constantly checking for a fire
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
    if (bReloading)
    {
        return false;
    }

    return super.ReadyToFire(bAltFire);
}

function CeaseFire(Controller C, bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    if (!bReloading && !HasAmmo(0))
    {
        HandleReload();
    }
}

function HandleReload()
{
    if (NumMags > 0 && !bReloading)
    {
        bReloading = true;
        NumMags--;
        NetUpdateTime = Level.TimeSeconds - 1;
        ReloadStartTime = Level.TimeSeconds; // Matt: added so we can pass this to client (using next function call), so client can work out reload progress to display on HUD 
        ClientSetReloadStartTime();
        SetTimer(GetSoundDuration(ReloadSound), false);
        PlaySound(ReloadSound, SLOT_None, 1.5,, 25,, true);
    }
}

// Matt: new server-to-client function passing the % of reload already done, so client can determine when reload started - used to show reload progress on HUD ammo icon
// Only called once for owning player, either when reload starts or if player enters MG position that is in the process of reloading
simulated function ClientSetReloadStartTime(optional byte PercentageDone) // replication optimised to a byte, instead of passing start time as float
{
    ReloadStartTime = Level.TimeSeconds - (Float(PercentageDone) / 100.0 * ReloadDuration);
}

simulated function Timer()
{
    if (bReloading && Role == ROLE_Authority)
    {
        bReloading = false;
        MainAmmoCharge[0] = InitialPrimaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;
    }
}

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

// Matt: modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        // Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly (result=0) then it's time to fire a tracer
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

// Matt: modified to remove the Super in ROVehicleWeapon to remove calling UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super(VehicleWeapon).FlashMuzzleFlash(bWasAltFire);
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

simulated function int GetNumMags()
{
    return NumMags;
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

/**
    Matt: shell's ProcessTouch now calls TD on VehicleWeapon instead of VehicleBase & for vehicle MG this is not counted as hit on vehicle itself
    But we can add any desired functionality here or in subclasses, e.g. shell could wreck MG
    Note that if calling a damage function & DamageType.bDelayedDamage, we need to call SetDelayedDamageInstigatorController(InstigatedBy.Controller) on the relevant pawn
*/

    // Matt: removed as shell & bullet's ProcessTouch now call TakeDamage directly on Driver if he was hit
    //  if (HitDriver(Hitlocation, Momentum))
//  {
//      ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
//  }
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

simulated function Destroyed() // Matt: added
{
    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.Destroy();
    }

    super.Destroyed();
}

defaultproperties
{
    FireAttachBone="mg_pitch"
    FireEffectOffset=(X=10.0,Z=5.0)
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
}
