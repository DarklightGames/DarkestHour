//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHThrowableIncendiaryProjectile extends DHProjectile
    abstract;

const EXPLOSION_SOUNDS_MAX = 3;

var     byte            ThrowerTeam;      // the team number of the person that threw this projectile
var     float           FailureRate;      // percentage of duds (expressed between 0.0 & 1.0)
var     AvoidMarker     Fear;             // scares the bots away from this
var     byte            Bounces;
var     bool            bDud;
var     vector          HitVelocity;

// Surface damping
var     float           MinImpactSpeedToExplode;
var     float           MaxObliquityAngleToExplode; // [degrees] // https://www.researchgate.net/figure/Definition-of-projectile-notations-including-the-angle-of-attack-AoA-obliquity-angle_fig10_259515946
var class<WeaponPickup> PickupClass;                // pickup class when thrown but did not explode & lies on ground
var     array<float>    SurfaceDampen;

// Explosion / splash
var     class<Actor>    SubProjectileClass;
var     int             SubProjectilesAmount;
var     float           SubProjectileSpawnDistance;
var     class<Emitter>  ExplodeEffectClass;
var     class<Emitter>  WaterSplashEffect;

// Sound effects
var     sound           ExplosionSound[EXPLOSION_SOUNDS_MAX];
var     float           ExplosionSoundRadius;
var     array<sound>    SurfaceHits;
var     sound           WaterHitSound;

// Trail effect
var         class<Emitter> ProjectileTrailEffect;
var private Emitter        ProjectileTrail;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        Bounces, bDud;
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

    if (ProjectileTrailEffect != none && Level.NetMode != NM_DedicatedServer)
    {
        ProjectileTrail = Spawn(ProjectileTrailEffect);
        ProjectileTrail.SetBase(self);
        ProjectileTrail.SetRelativeLocation(vect(0, 0, 0));

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
    if (Fear != none)
    {
        Fear.Destroy();
    }

    if (ProjectileTrail != none)
    {
        ProjectileTrail.Destroy();
    }

    super.Destroyed();
}

function VehicleOccupantBlastDamage(Pawn Pawn, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Dist, DamageScale;

    if (Pawn != none)
    {
        HeadBoneCoords = Pawn.GetBoneCoords(Pawn.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((Pawn.HeadHeight + (0.5 * Pawn.HeadRadius)) * Pawn.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
                return;
        }

        // Calculate damage based on distance from explosion
        Direction = Pawn.Location - HitLocation;
        Dist = FMax(1.0, VSize(Direction));
        Direction = Direction / Dist;
        DamageScale = 1.0 - FMax(0.0, (Dist - Pawn.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            Pawn.SetDelayedDamageInstigatorController(InstigatorController);
            Pawn.TakeDamage(DamageScale * DamageAmount,
                            InstigatorController.Pawn,
                            Pawn.Location - (0.5 * (Pawn.CollisionHeight + Pawn.CollisionRadius)) * Direction,
                            DamageScale * Momentum * Direction,
                            DamageType);
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

simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local Class<DamageType> NextDamageType;
    local ESurfaceTypes HitSurfaceType;
    local int i, DamageTypesAmount;
    local float ImpactSpeed, ImpactObliquityAngle, ObliquityDotProduct, SurfaceDampenValue;
    local Sound SoundFX;
    local vector HitPoint;

    HitVelocity = Velocity;
    DestroMesh = RODestroyableStaticMesh(Wall);
    ImpactSpeed = VSize(Velocity);
    ObliquityDotProduct = Normal(-Velocity) dot HitNormal;
    ImpactObliquityAngle = Acos(ObliquityDotProduct) * 180.0 / Pi;

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            DestroMesh.TakeDamage(DestroMesh.Health + 1,
                                  Instigator,
                                  Location,
                                  MomentumTransfer * Normal(Velocity),
                                  class'DHWeaponBashDamageType');

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
            DamageTypesAmount = DestroMesh.TypesCanDamage.Length;

            for(i = 0; i < DamageTypesAmount; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                NextDamageType = DestroMesh.TypesCanDamage[i];
                if (NextDamageType == class'DHWeaponBashDamageType' ||
                    ClassIsChildOf(class'DHWeaponBashDamageType', NextDamageType))
                {
                    return;
                }
            }
        }
    }

    HitSurfaceType = TraceForHitSurfaceType(-HitNormal, /*out*/ HitPoint);

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

        if (int(HitSurfaceType) < SurfaceDampen.Length)
        {
            SurfaceDampenValue = SurfaceDampen[int(HitSurfaceType)];
        }
        else
        {
            SurfaceDampenValue = 1.0;
        }

        // kinetic reflection from hit surface:
        Velocity = class'UCore'.static.VReflect(Velocity, HitNormal) * // lossless kinetic reflection
                   FMax(0.1, 1.0 - ObliquityDotProduct) * // dampen from hit angle
                   SurfaceDampenValue; // dampen from surface type

        // if (Level.NetMode == NM_Standalone) DrawStayingDebugLine(Location, Location + (Normal(Velocity)*25), 255,255,0);
    }

    if (Role == ROLE_Authority)
    {
        // Log("impactSpeed: "@ impactSpeed @", MinImpactSpeedToExplode: "@ MinImpactSpeedToExplode);
        if (ImpactSpeed > MinImpactSpeedToExplode ||
            ImpactObliquityAngle < MaxObliquityAngleToExplode)
        {
            Explode(Location, HitNormal);
        }
    }

    if (Level.NetMode != NM_DedicatedServer && ImpactSpeed > 150.0)
    {
        if (int(HitSurfaceType) < SurfaceHits.Length)
        {
            SoundFX = SurfaceHits[int(HitSurfaceType)];

            if (SoundFX != none)
            {
                PlaySound(SoundFX, SLOT_Misc, 1.1);
            }
        }
    }
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

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
    if (VSizeSquared(Velocity) == 0 ||
        Other.IsA(class'Mover'.Name) ||
        Other.TraceThisActor(/*out*/ HitLocation,
                             /*out*/ HitNormal,
                             Location,
                             Location - (2.0 * Velocity),
                             GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA(class'DHCollisionMeshActor'.Name))
    {
        if (DHCollisionMeshActor(Other).bWontStopThrownProjectile)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a thrown projectile, e.g. grenade or satchel
        }

        Other = Other.Owner;
    }

    ProcessTouch(Other, HitLocation);
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector TempHitLocation, HitNormal;

    if (Other == Instigator ||
        Other.Base == Instigator ||
        ROBulletWhipAttachment(Other) != none)
    {
        return;
    }

    Trace(/*out*/ TempHitLocation,
          /*out*/ HitNormal,
          HitLocation + Normal(Velocity) * 50.0,
          HitLocation - Normal(Velocity) * 50.0,
          true); // get a reliable HitNormal for a deflection

    HitWall(HitNormal, Other);
}

simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
    local actor  TraceHitActor;
    local vector TraceHitLocation;
    local vector TraceHitNormal;

    if (!EffectIsRelevant(Location, false))
    {
        return;
    }

    // Spwn explosion effect
    if (ExplodeEffectClass != none)
    {
        Spawn(ExplodeEffectClass,,, Location, rotator(vect(0, 0, 1)));
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        PlaySound(ExplosionSound[Rand(EXPLOSION_SOUNDS_MAX)],, 5.0,, ExplosionSoundRadius, 1.0, true);

        if (ExplosionDecal != none)
        {
            TraceHitActor = Trace(TraceHitLocation,
                                  TraceHitNormal,
                                  Location + (16.0 * Normal(HitVelocity)),
                                  Location,
                                  true);

            // Spawn explosion decal only when terrain or a static mesh is hit
            if (TraceHitActor != none &&
                !TraceHitActor.IsA('DHCollisionMeshActor') &&
                (TraceHitActor.IsA('TerrainInfo') || TraceHitActor.IsA('StaticMeshActor')))
            {
                Spawn(ExplosionDecal, self,, Location, rotator(HitVelocity)); // rotator(vect(0,0,-1))
            }
        }
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bDud)
    {
        BlowUp(HitLocation);
    }
}

function BlowUp(vector HitLocation)
{
    local Actor SubProjectile, TracedActorHit;
    local ESurfaceTypes HitSurfaceType;
    local vector TracedHitPoint, TracedHitNormal;
    local rotator Spread;
    local vector EjectDirection;
    local int i;

    if (Role != ROLE_Authority)
    {
        return;
    }

    MakeNoise(1.0);

    HitSurfaceType = TraceForHitSurfaceType(Normal(HitLocation - Location),
                                            /*out*/ TracedHitPoint,
                                            /*out*/ TracedHitNormal,
                                            /*out*/ TracedActorHit);

    // Spawn sub-projectiles (flames)
    if (InstigatorController != none)
    {
        for(i = 0; i < SubProjectilesAmount; i++)
        {
            // Sub-projectiles sometimes fail to spawn when when they hit
            // static meshes. To combat this, we spawn them at a slight
            // distance from the hit locations.
            Spread.Yaw = 32768 * (FRand() - 0.5);
            Spread.Pitch = 32768 * (FRand() - 0.5);
            Spread.Roll = 32768 * (FRand() - 0.5);
            EjectDirection = Normal(Velocity) >> Spread;

            SubProjectile = Spawn(SubProjectileClass,
                                InstigatorController,
                                ,
                                HitLocation + EjectDirection * SubProjectileSpawnDistance);

            if (SubProjectile != none)
            {
                SubProjectile.LifeSpan = 5.0 + (FRand() * 30.0);
                SubProjectile.Velocity = EjectDirection * Lerp(FRand(), 60, 450);

                if (TracedActorHit != none)
                {
                    SubProjectile.SetBase(TracedActorHit);
                }
            }
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PlayerController;

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

    PlayerController = Level.GetLocalPlayerController();

    if (PlayerController == none || PlayerController.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player that fired the projectile)
    if (PlayerController.Pawn != Instigator &&
        vector(PlayerController.CalcViewRotation) dot (SpawnLocation-PlayerController.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PlayerController.ViewTarget.Location-SpawnLocation) < (1600*1600); // 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PlayerController, SpawnLocation);
}

simulated function ESurfaceTypes TraceForHitSurfaceType(vector Direction, optional out vector HitLocation, optional out vector HitNormal, optional out Actor ActorTraced)
{
    local material  HitMaterial;

    ActorTraced = Trace(/*out*/ HitLocation,
                        /*out*/ HitNormal,
                        Location - (Direction * 16.0),
                        Location,
                        false,,
                        /*out*/ HitMaterial);

    if (HitMaterial == none)
    {
        return EST_Default;
    }
    else
    {
        return ESurfaceTypes(HitMaterial.SurfaceType);
    }
}

simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    // if thrown projectile hits water we play a splash effect
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        Velocity *= 0.25;
        CheckForSplash(Location);
    }
}

simulated function CheckForSplash(vector Position)
{
    local Actor  HitActor;
    local vector HitLocation, HitNormal;

    // No splash if detail settings are low, or if projectile is already in a water volume
    if (Level.NetMode != NM_DedicatedServer &&
        !Level.bDropDetail &&
        Level.DetailMode != DM_Low &&
        !(Instigator != none &&
        Instigator.PhysicsVolume != none &&
        Instigator.PhysicsVolume.bWaterVolume))
    {
        bTraceWater = true;
        HitActor = Trace(/*out*/ HitLocation,
                         /*out*/ HitNormal,
                         Position - vect(0, 0, 50),
                         Position + vect(0, 0, 15),
                         true);
        bTraceWater = false;

        // We hit a water volume or a fluid surface, so play splash effects
        if ((PhysicsVolume(HitActor) != none && PhysicsVolume(HitActor).bWaterVolume) ||
            FluidSurfaceInfo(HitActor) != none)
        {
            if (WaterHitSound != none)
                PlaySound(WaterHitSound);

            if (WaterSplashEffect != none && EffectIsRelevant(HitLocation, false))
                Spawn(WaterSplashEffect,,, HitLocation, rot(16384, 0, 0));

            // fire is out:
            bDud = true;
            ProjectileTrail.Destroy();
        }
    }
}

defaultproperties
{
    bNetTemporary=false
    MaxObliquityAngleToExplode=60
    MinImpactSpeedToExplode=100
    FailureRate=0.001 // 1 in 1000
    DrawType=DT_StaticMesh

    // Physics
    Physics=PHYS_Falling
    bBlockHitPointTraces=false
    Speed=800.0
    bBounce=true
    Bounces=5
    MaxSpeed=1500.0
    MomentumTransfer=8000.0
    TossZ=150.0
    bFixedRotationDir=true

    // Surface dampen values:
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

    // Sound
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

    // FX
    SubProjectileClass=class'DH_Engine.DHIncendiarySubProjectile'
    SubProjectilesAmount=20
    ExplodeEffectClass=none
    WaterSplashEffect=class'ROEffects.ROBulletHitWaterEffect'
    // ProjectileTrailEffect=class'DH_Effects.DHMolotovCoctailTrail'
    // ExplosionDecal=class'DH_Effects.DH_MolotovMark'

    // Give light
    LightType=LT_Pulse
    LightBrightness=1.0
    LightRadius=200.0
    LightHue=10
    LightSaturation=255
}
