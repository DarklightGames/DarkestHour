//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovProjectile extends DHProjectile;

var     float           MinImpactSpeedToExplode;
var     float           MaxObliquityAngleToExplode; // [degrees] // https://www.researchgate.net/figure/Definition-of-projectile-notations-including-the-angle-of-attack-AoA-obliquity-angle_fig10_259515946
var class<WeaponPickup> PickupClass;                // pickup class when thrown but did not explode & lies on ground
var     array<float>    SurfaceDampen;

var     class<Actor>    FlameEffect;
var     class<Actor>    SubProjectileClass;
var     float           ExplosionSoundRadius;
var     class<Emitter>  ExplodeEffectClass;
var private Actor       _TrailInstance;

var     class<Actor>    WaterSplashEffect;
var     sound           WaterHitSound;
var     array<sound>    SurfaceHits;

//==============================================================================
// Variables from deprecated ROThrowableExplosiveProjectile:

var     byte            ThrowerTeam;      // the team number of the person that threw this projectile
var     float           FailureRate;      // percentage of duds (expressed between 0.0 & 1.0)
var     bool            bDud;
var     sound           ExplosionSound[3];
var     AvoidMarker     Fear;             // scares the bots away from this
var     byte            Bounces;

var Vector              _HitVelocity;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        Bounces, bDud;

    // Functions a client can call on the server
    // reliable if( Role<ROLE_Authority )
    //     ServerDoSomething;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator != none &&
            Instigator.HeadVolume != none &&
            Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }

        bDud = FRand() < FailureRate;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        _TrailInstance = Spawn(FlameEffect);
        _TrailInstance.SetBase(self);
        _TrailInstance.SetRelativeLocation(vect(0, 0, 0));

        bDynamicLight = true;
    }
    else
    {
        bDynamicLight = false;
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;

    RotationRate.Pitch = -(90000 + Rand(30000));
    // RandSpin(100000.0);

    if (InstigatorController != none)
    {
        ThrowerTeam = InstigatorController.GetTeamNum();
    }
}

simulated function Destroyed()
{
    if (Fear != none) Fear.Destroy();
    if (_TrailInstance != none) _TrailInstance.Destroy();

    if (EffectIsRelevant(Location, false))
    {
        // spawn explosion fx:
        if (ExplodeEffectClass != none)
            Spawn(ExplodeEffectClass,,, Location, rotator(vect(0, 0, 1)));

        if (Level.NetMode != NM_DedicatedServer)
        {
            PlaySound(ExplosionSound[Rand(3)],, 5.0,, ExplosionSoundRadius, 1.0, true);
            Spawn(ExplosionDecal, self,, Location, rotator(_HitVelocity)); // rotator(vect(0,0,-1))
        }
    }

    super.Destroyed();
}

function VehicleOccupantBlastDamage
(
    Pawn pawn,
    float damageAmount,
    float damageRadius,
    class<DamageType> damageType,
    float momentum,
    vector hitLocation
)
{
    local Actor  traceHitActor;
    local coords headBoneCoords;
    local vector headLocation, traceHitLocation, traceHitNormal, direction;
    local float  dist, damageScale;

    if (pawn != none)
    {
        headBoneCoords = pawn.GetBoneCoords(pawn.HeadBone);
        headLocation = headBoneCoords.Origin + ((pawn.HeadHeight + (0.5 * pawn.HeadRadius)) * pawn.HeadScale * headBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', traceHitActor, traceHitLocation, traceHitNormal, headLocation, hitLocation)
        {
            if (traceHitActor.bBlockActors)
                return;
        }

        // Calculate damage based on distance from explosion
        direction = pawn.Location - hitLocation;
        dist = FMax(1.0, VSize(direction));
        direction = direction / dist;
        damageScale = 1.0 - FMax(0.0, (dist - pawn.CollisionRadius) / damageRadius);

        // Damage the vehicle occupant
        if (damageScale > 0.0)
        {
            pawn.SetDelayedDamageInstigatorController(InstigatorController);
            pawn.TakeDamage(damageScale * damageAmount,
                            InstigatorController.Pawn,
                            pawn.Location - (0.5 * (pawn.CollisionHeight + pawn.CollisionRadius)) * direction,
                            damageScale * momentum * direction,
                            damageType);
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

simulated function Landed(vector hitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(hitNormal)),
                                  QuatFromAxisAndAngle(hitNormal, class'UUnits'.static.UnrealToRadians(Rotation.Yaw)))));

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker');
            Fear.SetCollisionSize(DamageRadius, 200.0);
            Fear.StartleBots();
        }
    }
    else
    {
        HitWall(hitNormal, none);
    }
}

simulated function HitWall(vector hitNormal, Actor wall)
{
    local RODestroyableStaticMesh destroMesh;
    local Class<DamageType> nextDamageType;
    local ESurfaceTypes hitSurfaceType;
    local int i, max;
    local float impactSpeed, impactObliquityAngle, obliquityDotProduct, surfaceDampenValue;
    local Sound sfx;
    local vector hitPoint;

    _HitVelocity = Velocity;
    destroMesh = RODestroyableStaticMesh(wall);
    impactSpeed = VSize(Velocity);
    obliquityDotProduct = Normal(-Velocity) dot hitNormal;
    impactObliquityAngle = Acos(obliquityDotProduct) * 180.0 / Pi;

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (destroMesh != none && destroMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            destroMesh.TakeDamage(destroMesh.Health + 1,
                                  Instigator,
                                  Location,
                                  MomentumTransfer * Normal(Velocity),
                                  class'DHWeaponBashDamageType');

            // But it will only take damage if it's vulnerable to a weapon bash - so check if it's been reduced to zero Health & if so then we'll exit without deflecting
            if (destroMesh.Health < 0)
            {
                return;
            }
        }
        // Problem is that a client needs to know right now whether or not the mesh will break, so it can decide whether or not to bounce off
        // So as a workaround we'll loop through the meshes TypesCanDamage array & check if the server's weapon bash DamageType will have broken the mesh
        else
        {
            max = destroMesh.TypesCanDamage.Length;

            for(i = 0; i < max; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                nextDamageType = destroMesh.TypesCanDamage[i];
                if (nextDamageType == class'DHWeaponBashDamageType' ||
                    ClassIsChildOf(class'DHWeaponBashDamageType', nextDamageType))
                {
                    return;
                }
            }
        }
    }

    hitSurfaceType = TraceForHitSurfaceType(-hitNormal, /*out*/ hitPoint);

    Bounces--;
    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // debug draw reflection angle:
        // if (Level.NetMode == NM_Standalone)
        // {
        //     DrawStayingDebugLine(Location, Location - (Normal(Velocity)*50), 255,255,0);
        //     DrawStayingDebugLine(Location, Location + (hitNormal*25), 0,255,255);
        // }

        if (int(hitSurfaceType) < SurfaceDampen.Length) surfaceDampenValue = SurfaceDampen[int(hitSurfaceType)];
        else surfaceDampenValue = 1.0;

        // kinetic reflection from hit surface:
        Velocity = class'UCore'.static.VReflect(Velocity, hitNormal) * // lossless kinetic reflection
                   FMax(0.1, 1.0 - obliquityDotProduct) * // dampen from hit angle
                   surfaceDampenValue; // dampen from surface type

        // if (Level.NetMode == NM_Standalone) DrawStayingDebugLine(Location, Location + (Normal(Velocity)*25), 255,255,0);
    }

    if (Role == ROLE_Authority)
    {
        // Log("impactSpeed: "@ impactSpeed @", MinImpactSpeedToExplode: "@ MinImpactSpeedToExplode);
        if (impactSpeed > MinImpactSpeedToExplode ||
            impactObliquityAngle < MaxObliquityAngleToExplode)
        {
            Explode(Location, hitNormal);
        }
    }

    if (Level.NetMode != NM_DedicatedServer && impactSpeed > 150.0)
    {
        if (int(hitSurfaceType) < SurfaceHits.Length)
        {
            sfx = SurfaceHits[int(hitSurfaceType)];
            if (sfx != none) PlaySound(sfx, SLOT_Misc, 1.1);
        }
    }
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor other)
{
    local vector hitLocation, hitNormal;

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(other) != none)
    {
        CheckForSplash(Location);
    }

    if (other == none || (!other.bProjTarget && !other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use our location if velocity is zero (touching actor when projectile spawns) or hit a Mover actor (legacy, don't know why)
    if (VSizeSquared(Velocity) == 0 ||
        other.IsA(class'Mover'.Name) ||
        other.TraceThisActor(/*out*/ hitLocation,
                             /*out*/ hitNormal,
                             Location,
                             Location - (2.0 * Velocity),
                             GetCollisionExtent()))
    {
        hitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (other.IsA(class'DHCollisionMeshActor'.Name))
    {
        if (DHCollisionMeshActor(other).bWontStopThrownProjectile)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a thrown projectile, e.g. grenade or satchel
        }

        other = other.Owner;
    }

    ProcessTouch(other, hitLocation);
}

simulated function ProcessTouch(Actor other, vector hitLocation)
{
    local vector tempHitLocation, hitNormal;

    if (other == Instigator ||
        other.Base == Instigator ||
        ROBulletWhipAttachment(other) != none)
    {
        return;
    }

    Trace(/*out*/ tempHitLocation,
          /*out*/ hitNormal,
          hitLocation + Normal(Velocity) * 50.0,
          hitLocation - Normal(Velocity) * 50.0,
          true); // get a reliable HitNormal for a deflection

    HitWall(hitNormal, other);
}

/// <summary> Calls Destroy() </summary>
simulated function Explode(vector hitLocation, vector hitNormal)
{
    if (!bDud) BlowUp(hitLocation);
    Destroy();
}

/// <summary> Deals damage, creates fx & sfx </summary>
simulated function BlowUp(vector hitLocation)
{
    local Actor instance, tracedActorHit;
    local ESurfaceTypes hitSurfaceType;
    local vector tracedHitPoint, tracedHitNormal;
    local rotator spread;
    local int i;

    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);

        hitSurfaceType = TraceForHitSurfaceType(Normal(hitLocation - Location),
                                                /*out*/ tracedHitPoint,
                                                /*out*/ tracedHitNormal,
                                                /*out*/ tracedActorHit);

        // spawn flames:
        for(i = 0; i < 20; i++) // TODO: Why 20? This should probably be a variable
        {
            // 65536  ==  360', 32768  ==  180', 16384  ==  90' [degrees]
            spread.Yaw = 32768 * (FRand() - 0.5);
            spread.Pitch = 32768 * (FRand() - 0.5);
            spread.Roll = 32768 * (FRand() - 0.5);

            instance = Spawn(SubProjectileClass, Instigator.Controller,, hitLocation);
            instance.LifeSpan = 5.0 + (FRand() * 30.0);
            instance.Velocity = (Normal(Velocity) >> spread) * Lerp(FRand(), 60, 450);

            if (tracedActorHit != none)
                instance.SetBase(tracedActorHit);

            // if (Level.NetMode == NM_Standalone) DrawStayingDebugLine(hitLocation, hitLocation + instance.Velocity, 255,0,0);
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
simulated function bool EffectIsRelevant(vector spawnLocation, bool bForceDedicated)
{
    local PlayerController playerController;

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
        if ((Level.TimeSeconds-LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    playerController = Level.GetLocalPlayerController();

    if (playerController == none || playerController.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player that fired the projectile)
    if (playerController.Pawn != Instigator &&
        vector(playerController.CalcViewRotation) dot (spawnLocation-playerController.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(playerController.ViewTarget.Location-spawnLocation) < (1600*1600); // 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(playerController, spawnLocation);
}

simulated function ESurfaceTypes TraceForHitSurfaceType
(
    vector dir,
    optional out vector out_hitLoc,
    optional out vector out_hitNorm,
    optional out Actor actorTraced
)
{
    local material  hitMat;
    actorTraced = Trace(/*out*/ out_hitLoc,
                        /*out*/ out_hitNorm,
                        Location - (dir * 16.0),
                        Location,
                        false,,
                        /*out*/ hitMat);

    if (hitMat == none) return EST_Default;
    else return ESurfaceTypes(hitMat.SurfaceType);
}

simulated function PhysicsVolumeChange(PhysicsVolume newVolume)
{
    // if thrown projectile hits water we play a splash effect
    if (newVolume != none && newVolume.bWaterVolume)
    {
        Velocity *= 0.25;
        CheckForSplash(Location);
    }
}

simulated function CheckForSplash(vector pos)
{
    local Actor  hitActor;
    local vector hitLocation, hitNormal;

    // No splash if detail settings are low, or if projectile is already in a water volume
    if (Level.NetMode != NM_DedicatedServer &&
        !Level.bDropDetail &&
        Level.DetailMode != DM_Low &&
        !(Instigator != none &&
        Instigator.PhysicsVolume != none &&
        Instigator.PhysicsVolume.bWaterVolume))
    {
        bTraceWater = true;
        hitActor = Trace(/*out*/ hitLocation,
                         /*out*/ hitNormal,
                         pos - vect(0, 0, 50),
                         pos + vect(0, 0, 15),
                         true);
        bTraceWater = false;

        // We hit a water volume or a fluid surface, so play splash effects
        if ((PhysicsVolume(hitActor) != none && PhysicsVolume(hitActor).bWaterVolume) ||
            FluidSurfaceInfo(hitActor) != none)
        {
            if (WaterHitSound != none)
                PlaySound(WaterHitSound);

            if (WaterSplashEffect != none && EffectIsRelevant(hitLocation, false))
                Spawn(WaterSplashEffect,,, hitLocation, rot(16384, 0, 0));

            // fire is out:
            bDud = true;
            _TrailInstance.Destroy();
        }
    }
}

defaultproperties
{
    bNetTemporary=false
    PickupClass=class'DH_Weapons.DH_MolotovWeapon'

    MaxObliquityAngleToExplode=60
    MinImpactSpeedToExplode=100
    FailureRate=0.001 // 1 in 1000

    // mesh:
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups_molotov.MolotovCocktail_throw'

    // physics
    Physics=PHYS_Falling
    bBlockHitPointTraces=false
    Speed=800.0
    bBounce=true
    Bounces=5
    MaxSpeed=1500.0
    MomentumTransfer=8000.0
    TossZ=150.0
    bFixedRotationDir=true

    // surface dampen values:
    SurfaceDampen(0)=1.0// EST_Default,
    SurfaceDampen(1)=1.0// EST_Rock,
    SurfaceDampen(2)=0.7// EST_Dirt,
    SurfaceDampen(3)=1.0// EST_Metal,
    SurfaceDampen(4)=1.0// EST_Wood,
    SurfaceDampen(5)=0.5// EST_Plant,
    SurfaceDampen(6)=0.5// EST_Flesh,
    SurfaceDampen(7)=1.0// EST_Ice,
    SurfaceDampen(8)=0// EST_Snow,
    SurfaceDampen(9)=0// EST_Water,
    SurfaceDampen(10)=1.0// EST_Glass,
    SurfaceDampen(11)=0.25// EST_Gravel,
    SurfaceDampen(12)=1.0// EST_Concrete,
    SurfaceDampen(13)=1.0// EST_HollowWood,
    SurfaceDampen(14)=0.25// EST_Mud,
    SurfaceDampen(15)=1.0// EST_MetalArmor,
    SurfaceDampen(16)=0.7// EST_Paper,
    SurfaceDampen(17)=0.7// EST_Cloth,
    SurfaceDampen(18)=1.5// EST_Rubber,
    SurfaceDampen(19)=0.5// EST_Poop,

    // sound
    ExplosionSoundRadius=300.0
    ExplosionSound(0)=Sound'DH_MolotovCocktail.explosion1'
    ExplosionSound(1)=Sound'DH_MolotovCocktail.explosion2'
    ExplosionSound(2)=Sound'DH_MolotovCocktail.explosion3'
    SurfaceHits(0)=Sound'DH_MolotovCocktail.bounce' // EST_Default,
    SurfaceHits(1)=Sound'DH_MolotovCocktail.bounce' // EST_Rock,
    SurfaceHits(2)=Sound'DH_MolotovCocktail.bounce' // EST_Dirt,
    SurfaceHits(3)=Sound'DH_MolotovCocktail.bounce' // EST_Metal,
    SurfaceHits(4)=Sound'DH_MolotovCocktail.bounce' // EST_Wood,
    SurfaceHits(5)=Sound'DH_MolotovCocktail.bounce' // EST_Plant,
    SurfaceHits(6)=Sound'DH_MolotovCocktail.bounce' // EST_Flesh,
    SurfaceHits(7)=Sound'DH_MolotovCocktail.bounce' // EST_Ice,
    SurfaceHits(8)=Sound'DH_MolotovCocktail.bounce' // EST_Snow,
    SurfaceHits(9)=Sound'DH_MolotovCocktail.bounce' // EST_Water,
    SurfaceHits(10)=Sound'DH_MolotovCocktail.bounce' // EST_Glass,
    SurfaceHits(11)=Sound'DH_MolotovCocktail.bounce' // EST_Gravel,
    SurfaceHits(12)=Sound'DH_MolotovCocktail.bounce' // EST_Concrete,
    SurfaceHits(13)=Sound'DH_MolotovCocktail.bounce' // EST_HollowWood,
    SurfaceHits(14)=Sound'DH_MolotovCocktail.bounce' // EST_Mud,
    SurfaceHits(15)=Sound'DH_MolotovCocktail.bounce' // EST_MetalArmor,
    SurfaceHits(16)=Sound'DH_MolotovCocktail.bounce' // EST_Paper,
    SurfaceHits(17)=Sound'DH_MolotovCocktail.bounce' // EST_Cloth,
    SurfaceHits(18)=Sound'DH_MolotovCocktail.bounce' // EST_Rubber,
    SurfaceHits(19)=Sound'DH_MolotovCocktail.bounce' // EST_Poop

    // fx
    FlameEffect=class'DH_Effects.DHMolotovCoctailTrail'
    SubProjectileClass=class'DH_Weapons.DH_MolotovSubProjectile'
    ExplodeEffectClass=none
    ExplosionDecal=class'DH_Effects.DH_MolotovMark'
    WaterSplashEffect=class'ROEffects.ROBulletHitWaterEffect'

    // give light
    LightType=LT_Pulse
    LightBrightness=1.0
    LightRadius=200.0
    LightHue=10
    LightSaturation=255
}
