//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHThrowableExplosiveProjectile extends DHProjectile
    abstract;

var enum EFuzeType
{
    FT_Timed,   // Use FuzeLengthTimer to determine when to explode.
    FT_Impact,  // Explode on impact.
} FuzeType;

var     float           ExplosionSoundVolume;
var     float           ExplosionSoundRadius;
var     class<Emitter>  ExplodeDirtEffectClass;
var     class<Emitter>  ExplodeSnowEffectClass;
var     class<Emitter>  ExplodeMidAirEffectClass;
var     Vector          ExplodeEmitterOffset;

var     class<Actor>    SplashEffect;  // water splash effect class
var     Sound           WaterHitSound; // sound of this bullet hitting water

// Impact Sounds
var     float           NextImpactSoundTime;    // Time when the next impact sound can be played.
var()   float           ImpactSoundInterval;    // Minimum time between impact sounds.
var()   Range           ImpactSoundSpeedFactorRange;
var()   Range           ImpactSoundVolumeRange;         // The volume of the sound impact is dependent on the speed of the projectile (see ImpactSoundSpeedFactorRange).
var()   float           ImpactSoundRadius;
var()   Sound           ImpactSoundDirt;
var()   Sound           ImpactSoundWood;
var()   Sound           ImpactSoundMetal;
var()   Sound           ImpactSoundMud;
var()   Sound           ImpactSoundGrass;
var()   Sound           ImpactSoundConcrete;

// For DH_SatchelCharge10lb10sProjectile (moved from ROSatchelChargeProjectile & necessary here due to compiler package build order):
var     PlayerReplicationInfo   SavedPRI;
var     Pawn            SavedInstigator;

//==============================================================================
// Variables from deprecated ROThrowableExplosiveProjectile:

var     byte            ThrowerTeam;        // the team number of the person that threw this projectile
var     Range           FuzeLengthRange;
var     float           ImpactFuzeMomentumThreshold;        // Calculated when spawned, a random value between the range's min and max.
var()   Range           ImpactFuzeMomentumThresholdRange;    // The "momentum" range (i.e. speed * surface modifier) the projectile must be going to explode on impact.
var     float           DudChance;          // percentage of duds (expressed between 0.0 & 1.0)
var     bool            bDud;
var     float           DudLifeSpan;        // How long a dud lasts before it disappears.
var     float           TripMineLifeSpan;   // How long a trip mine lasts before it disappears.
var     Sound           ExplosionSound[3];
var     byte            Bounces;
var     float           DampenFactor;
var     float           DampenFactorParallel;

// View shake
var     float           BlurTime;         // how long blur effect should last for this projectile
var     float           BlurEffectScalar;
var     float           ShakeScale;       // how much larger than the explosion radius should the view shake
var     Vector          ShakeRotMag;      // how far to rot view
var     Vector          ShakeRotRate;     // how fast to rot view
var     float           ShakeRotTime;     // how much time to rot the instigator's view
var     Vector          ShakeOffsetMag;   // max view offset vertically
var     Vector          ShakeOffsetRate;  // how fast to offset view vertically
var     float           ShakeOffsetTime;  // how much time to offset view

var     bool            bHasExploded;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        Bounces, bDud;
}

simulated function float GetRandomFuzeLength()
{
    return RandRange(FuzeLengthRange.Min, FuzeLengthRange.Max);
}

// From ROThrowableExplosiveProjectile & ROGrenadeProjectile, combined
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Velocity = Speed * Vector(Rotation);

        if (Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }

        if (FRand() < DudChance)
        {
            bDud = true;
            LifeSpan = DudLifeSpan;
        }
        else
        {
            if (FuzeType == FT_Timed)
            {
                SetFuzeLength(GetRandomFuzeLength());
            }
        }

        // Calculate the momentum threshold for impact fuze grenades.
        if (FuzeType == FT_Impact)
        {
            ImpactFuzeMomentumThreshold = Class'UInterp'.static.Lerp(
                FRand(),
                ImpactFuzeMomentumThresholdRange.Min,
                ImpactFuzeMomentumThresholdRange.Max
            );
        }
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;

    if (InstigatorController != none)
    {
        ThrowerTeam = InstigatorController.GetTeamNum();
    }
}

function SetFuzeLength(float FuzeLength)
{
    if (FuzeType == FT_Timed)
    {
        SetTimer(FuzeLength, false);
    }
}

// From ROThrowableExplosiveProjectile, ROGrenadeProjectile & ROSatchelChargeProjectile, combined
// Incorporates ExplosionSoundRadius to make more generic
simulated function Destroyed()
{
    local ESurfaceTypes ST;
    local ROPawn        Victims;
    local Vector        Start, Direction;
    local float         DamageScale, Distance;

    if (bDud)
    {
        return;
    }

    WeaponLight();

    PlaySound(ExplosionSound[Rand(3)],, ExplosionSoundVolume,, ExplosionSoundRadius, 1.0, true); // TODO: skip sounds on ded server as played locally anyway? (probably other stuff too)

    Start = Location + ExplodeEmitterOffset;

    DoShakeEffect();

    if (EffectIsRelevant(Start, false))
    {
        // If the projectile is still moving we'll need to spawn a different explosion effect
        if (Physics == PHYS_Falling && FuzeType == FT_Timed)
        {
            Spawn(ExplodeMidAirEffectClass,,, Start, Rotator(vect(0.0, 0.0, 1.0)));
        }
        // If the projectile has stopped and is on the ground (or is an impact fuze grenade) we'll spawn a ground explosion effect and spawn some dirt flying out
        else if (Physics == PHYS_None || FuzeType == FT_Impact)
        {
            GetHitSurfaceType(ST, vect(0.0, 0.0, 1.0));

            if (ST == EST_Snow || ST == EST_Ice)
            {
                Spawn(ExplodeSnowEffectClass,,, Start, Rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecalSnow, self,, Location, Rotator(-vect(0.0, 0.0, 1.0)));
            }
            else
            {
                Spawn(ExplodeDirtEffectClass,,, Start, Rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecal, self,, Location, Rotator(-vect(0.0, 0.0, 1.0)));
            }
        }
    }

    // Move karma ragdolls around when this explodes
    if (Level.NetMode != NM_DedicatedServer)
    {
        foreach VisibleCollidingActors(Class'ROPawn', Victims, DamageRadius, Start)
        {
            if (Victims.Physics == PHYS_KarmaRagDoll && Victims != self)
            {
                Direction = Victims.Location - Start;
                Distance = FMax(1.0, VSize(Direction));
                Direction = Direction / Distance;
                DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

                Victims.DeadExplosionKarma(MyDamageType, DamageScale * MomentumTransfer * Direction, DamageScale);
            }
        }
    }

    super.Destroyed();
}

simulated function Timer()
{
    Explode(Location, vect(0.0, 0.0, 1.0));
}

// Modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// And to fix problem affecting many vehicles with hull mesh modelled with origin on the ground, where even a slight ground bump could block all blast damage
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     V;
    local DHConstruction C;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked;
    local Vector        VictimLocation, Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    UpdateInstigator();

    // Just return if the player switches teams after throwing the explosive - this prevent people TK exploiting by switching teams
    if (InstigatorController == none || InstigatorController.GetTeamNum() != ThrowerTeam || ThrowerTeam == 255)
    {
        return;
    }

    bHurtEntry = true;

    // Find all colliding actors within blast radius, which the blast should damage
    // No longer use VisibleCollidingActors as much slower (FastTrace on every actor found), but we can filter actors & then we do our own, more accurate trace anyway
    foreach CollidingActors(Class'Actor', Victim, DamageRadius, HitLocation)
    {
        if (!Victim.bBlockActors)
        {
            continue;
        }

        // If hit a collision mesh actor, switch to its owner
        if (Victim.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victim).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victim = Victim.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), cannon actors, non-authority actors, or fluids
        // We skip damage on cannons because the blast will hit the vehicle base so we don't want to double up on damage to the same vehicle
        if (Victim == none || Victim == self || Victim == HurtWall || Victim.IsA('DHVehicleCannon') || Victim.Role < ROLE_Authority || Victim.IsA('FluidSurfaceInfo'))
        {
            continue;
        }

        // Before tracing the victim, we must adjust its location for certain types of actors
        // Tracing to origin can be unreliable as it's usually located at the bottom and can sink under the terrain, blocking the blast damage
        C = DHConstruction(Victim);

        if (C != none)
        {
            VictimLocation = C.GetExplosiveDamageTraceLocation();
        }
        else
        {
            VictimLocation = Victim.Location;

            V = DHVehicle(Victim);

            if (V != none && V.Cannon != none && V.Cannon.AttachmentBone != '')
            {
                // Raise the trace location to the cannon bone height
                VictimLocation.Z = V.GetBoneCoords(V.Cannon.AttachmentBone).Origin.Z;
            }
        }

        // Trace from explosion point to the actor to check whether anything is in the way that could shield it from the blast
        TraceActor = Trace(TraceHitLocation, TraceHitNormal, VictimLocation, HitLocation);

        if (DHCollisionMeshActor(TraceActor) != none)
        {
            if (DHCollisionMeshActor(TraceActor).bWontStopBlastDamage)
            {
                continue;
            }

            TraceActor = TraceActor.Owner; // as normal, if hit a collision mesh actor then switch to its owner
        }

        // Ignore the actor if the blast is blocked by world geometry, a vehicle, or a turret (but don't let a turret block damage to its own vehicle)
        if (TraceActor != none && TraceActor != Victim && (TraceActor.bWorldGeometry || TraceActor.IsA('ROVehicle') || (TraceActor.IsA('DHVehicleCannon') && Victim != TraceActor.Base)))
        {
            continue;
        }

        // Check for hit on player pawn
        P = ROPawn(Victim);

        if (P != none)
        {
            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            for (i = 0; i < CheckedROPawns.Length; ++i)
            {
                if (P == CheckedROPawns[i])
                {
                    bAlreadyChecked = true;
                    break;
                }
            }

            if (bAlreadyChecked)
            {
                bAlreadyChecked = false;
                continue;
            }

            CheckedROPawns[CheckedROPawns.Length] = P;

            // If player is partially shielded from the blast, calculate damage reduction scale
            DamageExposure = P.GetExposureTo(HitLocation + 15.0 * -Normal(PhysicsVolume.Gravity));

            if (DamageExposure <= 0.0)
            {
                continue;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = VictimLocation - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - Victim.CollisionRadius) / DamageRadius);

        if (P != none)
        {
            DamageScale *= DamageExposure;
        }

        // Record player responsible for damage caused, & if we're damaging LastTouched actor, reset that to avoid damaging it again at end of function
        if (Instigator == none || Instigator.Controller == none)
        {
            Victim.SetDelayedDamageInstigatorController(InstigatorController);
        }

        if (Victim == LastTouched)
        {
            LastTouched = none;
        }

        // Damage the actor hit by the blast - if it's a vehicle, check for damage to any exposed occupants
        Victim.TakeDamage(DamageScale * DamageAmount, Instigator, VictimLocation - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Direction,
            DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(Victim) != none && ROVehicle(Victim).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(Victim), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);

            // If vehicle's engine is vulnerable to "grenades", then we can cause some damage to the engine!
            if (V.EngineDamageFromGrenadeModifier > 0.0)
            {
                // Cause reduced damage to vehicle's engine
                V.DamageEngine(DamageScale * DamageAmount * V.EngineDamageFromGrenadeModifier, Instigator, VictimLocation - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Direction, DamageScale * Momentum * Direction, DamageType);
            }
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for CollidingActors
    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Direction = LastTouched.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = FMax(LastTouched.CollisionRadius / (LastTouched.CollisionRadius + LastTouched.CollisionHeight),
            1.0 - FMax(0.0, (Distance - LastTouched.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            LastTouched.SetDelayedDamageInstigatorController(InstigatorController);
        }

        LastTouched.TakeDamage(DamageScale * DamageAmount, Instigator,
            LastTouched.Location - 0.5 * (LastTouched.CollisionHeight + LastTouched.CollisionRadius) * Direction, DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(LastTouched) != none && ROVehicle(LastTouched).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(LastTouched), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }

        LastTouched = none;
    }

    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius()
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    local ROVehicleWeaponPawn WP;
    local int i;

    if (V.Driver != none && V.DriverPositions[V.DriverPositionIndex].bExposed && !V.Driver.bCollideActors && !V.bRemoteControlled)
    {
        VehicleOccupantRadiusDamage(V.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
    }

    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = ROVehicleWeaponPawn(V.WeaponPawns[i]);

        if (WP != none && WP.Driver != none && ((WP.bMultiPosition && WP.DriverPositions[WP.DriverPositionIndex].bExposed) || WP.bSinglePositionExposed)
            && !WP.bCollideActors && !WP.bRemoteControlled)
        {
            VehicleOccupantRadiusDamage(WP.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }
}

// New function to handle blast damage to vehicle occupants
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    local Actor  TraceHitActor;
    local Coords HeadBoneCoords;
    local Vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Distance, DamageScale;

    if (P != none)
    {
        HeadBoneCoords = P.GetBoneCoords(P.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((P.HeadHeight + (0.5 * P.HeadRadius)) * P.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(Class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
            {
                return;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = P.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - P.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            P.SetDelayedDamageInstigatorController(InstigatorController);

            P.TakeDamage(DamageScale * DamageAmount, InstigatorController.Pawn, P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction,
                DamageScale * Momentum * Direction, DamageType);
        }
    }
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since throwing, e.g. entered vehicle
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

// Modified from ROGrenadeProjectile/ROSatchelChargeProjectile to add SetRotation
simulated function Landed(Vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(Rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Class'UUnits'.static.UnrealToRadians(Rotation.Yaw)))));

        if (Role == ROLE_Authority && FuzeType == FT_Impact && !bDud && !bHasExploded)
        {
            GotoState('TripMine');
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}


// A state for impact fuze explosives that have landed on the ground and not exploded.
state TripMine
{
    function BeginState()
    {
        bBlockZeroExtentTraces = true;
        bBlockNonZeroExtentTraces = true;
        bBlockProjectiles = true;
        bBlockHitPointTraces = true;    // Needed so that PLT will work on this!

        SetCollision(true, false);
        SetCollisionSize(8.0, 8.0);
        SetPhysics(PHYS_None);
        Velocity = vect(0, 0, 0);

        SetTimer(TripMineLifeSpan, false);
    }

    event Touch(Actor Other)
    {
        // Impact grenades can be laying on the ground unexploded.
        // If a any pawn walks or drives over it, it explodes!
        if (Other.IsA('Pawn'))
        {
            Explode(Location, vect(0, 0, 1));
        }
    }

    function TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        if (!DamageType.default.bCausesBlood)
        {
            // HACK: stops gas damage types from triggering the projectile from exploding.
            return;
        }

        // Make sure the instigator is set to the controller of the pawn that caused the damage, not the person who threw the grenade.
        InstigatorController = InstigatedBy.Controller;

        // Any damage will cause this to explode.
        Explode(Location, vect(0, 0, 1));
    }

    function Timer()
    {
        // Mark this as a dud, then set the lifetime so thatclients get the new state.
        // This is so that clients do not play the explosion effect when the grenade is destroyed locally.
        bDud = true;
        SetDrawType(DT_None);
        LifeSpan = 2.0;
    }
}

// The amount of momentum transferred to the grenade on impact.
// Used to determine if an impact grenade should explode on impact.
simulated function float GetSurfaceTypeMomentumTransfer(ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Dirt:
            return 0.8;
        case EST_Snow:
            return 0.25;
        case EST_Mud:
        case EST_Cloth:
            return 0.5;
        case EST_Custom01:  // Sand
            return 0.25;
        default:
            return 1.0;
    }
}

// Modified from ROGrenadeProjectile/ROSatchelChargeProjectile to add handling if projectile hits a weak destroyable mesh (e.g. glass)
// The projectile breaks the mesh & continues its flight, instead of bouncing off
simulated function HitWall(Vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local Vector        VNorm;
    local ESurfaceTypes ST;
    local int           i;
    local float         ImpactMomentumTransfer, ImpactSoundVolume;

    DestroMesh = RODestroyableStaticMesh(Wall);

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            DestroMesh.TakeDamage(DestroMesh.Health + 1, Instigator, Location, MomentumTransfer * Normal(Velocity), Class'DHWeaponBashDamageType');

            // But it will only take damage if it's vulnerable to a weapon bash - so check if it's been reduced to zero Health & if so then we'll exit without deflecting
            if (DestroMesh.Health < 0)
            {
                return;
            }
        }
        // Problem is that a client needs to know right now whether or not the mesh will break, so it can decide whether or not to bounce off
        // So as a workaround we'll loop through the meshes TypesCanDamage array & check if the server's weapon bash DamageType will have broken the mesh
        else
        {
            for (i = 0; i < DestroMesh.TypesCanDamage.Length; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                if (DestroMesh.TypesCanDamage[i] == Class'DHWeaponBashDamageType' || ClassIsChildOf(Class'DHWeaponBashDamageType', DestroMesh.TypesCanDamage[i]))
                {
                    return;
                }
            }
        }
    }

    GetHitSurfaceType(ST, HitNormal);

    if (Role == ROLE_Authority && FuzeType == FT_Impact && !bDud)
    {
        ImpactMomentumTransfer = GetSurfaceTypeMomentumTransfer(ST) * Speed;

        if (ImpactMomentumTransfer >= ImpactFuzeMomentumThreshold)
        {
            Explode(Location, HitNormal);
        }
    }

    if (!bDeleteMe)
    {
        GetDampenAndSoundValue(ST); // gets the deflect dampen factor & the hit sound, based on the type of surface the projectile hit

        Bounces--;

        if (Bounces <= 0)
        {
            bBounce = false;
        }
        else
        {
            // Reflect off Wall with damping
            VNorm = (Velocity dot HitNormal) * HitNormal;
            Velocity = -VNorm * DampenFactor + ((Velocity - VNorm) * DampenFactorParallel);
            Speed = VSize(Velocity);
        }

        if (Level.NetMode != NM_DedicatedServer && ImpactSound != none && Level.TimeSeconds >= NextImpactSoundTime)
        {
            ImpactSoundVolume = Class'UInterp'.static.MapRangeClamped(
                Speed,
                ImpactSoundSpeedFactorRange.Min, ImpactSoundSpeedFactorRange.Max,
                ImpactSoundVolumeRange.Min, ImpactSoundVolumeRange.Max
                );

            if (ImpactSoundVolume > 0.0)
            {
                PlaySound(ImpactSound, SLOT_Misc, ImpactSoundVolume,, ImpactSoundRadius);

                NextImpactSoundTime = Level.TimeSeconds + ImpactSoundInterval;
            }
        }
    }
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also to do splash effects if projectile hits a fluid surface, which wasn't previously handled
// Removed call to ClientSideTouch() as produces unwanted impact effects on a ragdoll body, i.e. grenade impact makes dead bodies jump around
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
    local Vector HitLocation, HitNormal;

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(Other) != none)
    {
        CheckForSplash(Location);
    }

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use our location if velocity is zero (touching actor when projectile spawns) or hit a Mover actor (legacy, don't know why)
    if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover')
        || Other.TraceThisActor(HitLocation, HitNormal, Location, Location - (2.0 * Velocity), GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA('DHCollisionMeshActor'))
    {
        if (DHCollisionMeshActor(Other).bWontStopThrownProjectile)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a thrown projectile, e.g. grenade or satchel
        }

        Other = Other.Owner;
    }

    // Now call ProcessTouch(), which is the where the class-specific Touch functionality gets handled
    // Record LastTouched to make sure that if HurtRadius() gets called to give blast damage, it will always 'find' the hit actor
    LastTouched = Other;
    ProcessTouch(Other, HitLocation);
    LastTouched = none;
}

// Emptied out as produces unwanted impact effects on a ragdoll body, i.e. grenade impact makes dead bodies jump around
// No longer even called as has been removed from Touch()
simulated function ClientSideTouch(Actor Other, Vector HitLocation)
{
}

// Modified from ROThrowableExplosiveProjectile to call HitWall for all hit actors, so grenades etc bounce off things like turrets or other players
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local Vector TempHitLocation, HitNormal;

    if (Other == Instigator || Other.Base == Instigator || ROBulletWhipAttachment(Other) != none)
    {
        return;
    }

    Trace(TempHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true); // get a reliable HitNormal for a deflection
    HitWall(HitNormal, Other);
}

// From ROGrenadeProjectile
simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (bDud)
    {
        Destroy();
        return;
    }

    BlowUp(HitLocation);

    bHasExploded = true;

    Destroy();
}

// From ROGrenadeProjectile & ROSatchelChargeProjectile, combined
function BlowUp(Vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        if (Damage > 0)
        {
            DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }
        
        MakeNoise(1.0);
    }
}

// From ROThrowableExplosiveProjectile (slightly re-factored to optimise & make clearer)
simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float            Distance, MaxShakeDistance, Scale, BlastShielding;

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.ViewTarget != none)
    {
        Distance = VSize(Location - PC.ViewTarget.Location);
        MaxShakeDistance = DamageRadius * ShakeScale;

        if (Distance < MaxShakeDistance)
        {
            // Screen shake
            Scale = (MaxShakeDistance - Distance) / MaxShakeDistance * BlurEffectScalar;
            PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

            // Screen blur (reduce scale if player is not fully exposed to the blast)
            if (ROPawn(PC.Pawn) != none && PC.IsA('ROPlayer'))
            {
                BlastShielding = 1.0 - ROPawn(PC.Pawn).GetExposureTo(Location - (15.0 * Normal(PhysicsVolume.Gravity)));
                Scale -= 0.5 * BlastShielding * Scale;
                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PC;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player, i.e. the player that fired the projectile
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant to other net clients if the projectile has not been drawn on their screen recently (within last 3 seconds)
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
    // (doesn't apply to the player that fired the projectile)
    if (PC.Pawn != Instigator && Vector(PC.CalcViewRotation) dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// From ROGrenadeProjectile/ROSatchelChargeProjectile
simulated function GetHitSurfaceType(out ESurfaceTypes ST, Vector HitNormal)
{
    local Vector   HitLoc, HitNorm;
    local Material HitMat;

    Trace(HitLoc, HitNorm, Location - (HitNormal * 16.0), Location, false,, HitMat);

    if (HitMat == none)
    {
        ST = EST_Default;
    }
    else
    {
        ST = ESurfaceTypes(HitMat.SurfaceType);
    }
}

// From ROGrenadeProjectile/ROSatchelChargeProjectile
simulated function GetDampenAndSoundValue(ESurfaceTypes ST)
{
    local Sound MyImpactSound;

    switch (ST)
    {
        case EST_Default:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.5;
            MyImpactSound = default.ImpactSoundConcrete;
            break;

        case EST_Rock:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            MyImpactSound = default.ImpactSoundConcrete;
            break;

        case EST_Dirt:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            MyImpactSound = default.ImpactSoundDirt;
            break;

        case EST_Metal:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            MyImpactSound = default.ImpactSoundMetal;
            break;

        case EST_Wood:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.4;
            MyImpactSound = default.ImpactSoundWood;
            break;

        case EST_Plant:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.1;
            MyImpactSound = default.ImpactSoundGrass;
            break;

        case EST_Flesh:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.3;
            MyImpactSound = default.ImpactSoundMud;
            break;

        case EST_Ice:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            MyImpactSound = default.ImpactSoundConcrete;
            break;

        case EST_Snow:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            MyImpactSound = default.ImpactSoundMud;
            break;

        case EST_Water:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            MyImpactSound = WaterHitSound;
            break;

        case EST_Glass:
            DampenFactor = 0.3;
            DampenFactorParallel = 0.55;
            MyImpactSound = default.ImpactSoundConcrete;
            break;

        case EST_Custom01: //Sand
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            MyImpactSound = default.ImpactSoundMud;
            break;

        case EST_Custom02: //SandBag
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            MyImpactSound = default.ImpactSoundMud;
            break;

        case EST_Custom03: //Brick
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            MyImpactSound = default.ImpactSoundConcrete;
            break;

        case EST_Custom04: //Hedgerow
            DampenFactor = 0.15;
            DampenFactorParallel = 0.55;
            MyImpactSound = default.ImpactSoundGrass;
            break;
    }

    if (MyImpactSound != none)
    {
        ImpactSound = MyImpactSound;
    }
}

// From ROGrenadeProjectile/ROSatchelChargeProjectile - empty but can be subclassed
simulated function WeaponLight()
{
}

// Modified from ROGrenadeProjectile so if thrown projectile hits water we play a splash effect
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        Velocity *= 0.25;
        CheckForSplash(Location);
    }
}

// New function, same as bullet & shell classes, to play a water splash effect
simulated function CheckForSplash(Vector SplashLocation)
{
    local Actor  HitActor;
    local Vector HitLocation, HitNormal;

    // No splash if detail settings are low, or if projectile is already in a water volume
    if (Level.Netmode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low
        && !(Instigator != none && Instigator.PhysicsVolume != none && Instigator.PhysicsVolume.bWaterVolume))
    {
        bTraceWater = true;
        HitActor = Trace(HitLocation, HitNormal, SplashLocation - (50.0 * vect(0.0, 0.0, 1.0)), SplashLocation + (15.0 * vect(0.0, 0.0, 1.0)), true);
        bTraceWater = false;

        // We hit a water volume or a fluid surface, so play splash effects
        if ((PhysicsVolume(HitActor) != none && PhysicsVolume(HitActor).bWaterVolume) || FluidSurfaceInfo(HitActor) != none)
        {
            if (WaterHitSound != none)
            {
                PlaySound(WaterHitSound);
            }

            if (SplashEffect != none && EffectIsRelevant(HitLocation, false))
            {
                Spawn(SplashEffect,,, HitLocation, rot(16384, 0, 0));
            }
        }
    }
}

defaultproperties
{
    bBounce=true
    Bounces=5
    MaxSpeed=1500.0
    MomentumTransfer=8000.0
    TossZ=150.0
    DampenFactor=0.05
    DampenFactorParallel=0.8
    bFixedRotationDir=true
    DudChance=0.001 // 1 in 1000
    ImpactSound=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Concrete'
    ImpactSoundDirt=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Dirt'
    ImpactSoundWood=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Wood'
    ImpactSoundMetal=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Metal'
    ImpactSoundMud=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Mud'
    ImpactSoundGrass=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Grass'
    ImpactSoundConcrete=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Concrete'
    ExplosionSoundVolume=5.0
    ExplosionSoundRadius=300.0
    ExplosionDecal=Class'DHGrenadeMark'
    ExplosionDecalSnow=Class'GrenadeMarkSnow'
    SplashEffect=Class'ROBulletHitWaterEffect'
    WaterHitSound=SoundGroup'DH_ProjectileSounds.GrenadeImpacts_Water'
    LightType=LT_Pulse
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=200
    LightHue=30
    LightSaturation=150
    LightRadius=5.0
    ExplodeEmitterOffset=(z=32)

    // From deprecated ROThrowableExplosiveProjectile class:
    bNetTemporary=false
    bBlockHitPointTraces=false
    Physics=PHYS_Falling
    DrawType=DT_StaticMesh
    ShakeScale=2.25
    BlurTime=4.0
    BlurEffectScalar=1.35

    ImpactFuzeMomentumThresholdRange=(Min=0,Max=200.0)
    TripMineLifeSpan=300

    ImpactSoundInterval=0.5
    ImpactSoundRadius=45.0
    ImpactSoundVolumeRange=(Min=0.0,Max=1.0)
    ImpactSoundSpeedFactorRange=(Min=100,Max=500.0)
}
