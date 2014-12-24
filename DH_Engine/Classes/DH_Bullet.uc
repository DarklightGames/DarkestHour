//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Bullet extends ROBullet
    config(DH_Penetration)
    abstract;

var   int    WhizType;        // sent in HitPointTrace for ROBulletWhipAttachment to only do snaps for supersonic rounds (0 = none, 1 = close supersonic bullet, 2 = subsonic or distant bullet)
var   Actor  SavedTouchActor; // Matt: added (same as shell) to prevent recurring ProcessTouch on same actor (e.g. was screwing up tracer ricochets from VehicleWeapons like turrets)

var() bool            bIsTracerBullet; // Matt: just set to true in a tracer bullet subclass of a normal bullet & then the inheritance from this class will handle everything
var   bool            bHasDeflected;
var   byte            Bounces;
var   StaticMesh      DeflectedMesh;
var   class<Emitter>  TracerEffectClass;
var() Emitter         TracerEffect;
var() float           TracerPullback;
var() float           DampenFactor;
var() float           DampenFactorParallel;

var globalconfig bool   bDebugMode;         // If true, give our detailed report in log.
var globalconfig bool   bDebugROBallistics; // If true, set bDebugBallistics to true for getting the arrow pointers


// Modified to handle tracer effect if this is a tracer bullet
simulated function PostBeginPlay()
{
    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    super.PostBeginPlay();

    OrigLoc = Location;

    if (bIsTracerBullet)
    {
        if (Level.bDropDetail)
        {
            bDynamicLight = false;
            LightType = LT_None;
        }

        if (Level.NetMode != NM_DedicatedServer)
        {
            TracerEffect = Spawn(TracerEffectClass, self, , (Location + Normal(Velocity) * TracerPullback));

            SetRotation(rotator(Velocity));
        }
    }
}

// Matt: called by DH_FastAutoFire's SpawnProjectile function to set this as a server bullet, meaning it won't be replicated as a separate client bullet will be spawned on client
// RemoteRole=none was the only change in DH_ServerBullet that had any effect, so simply doing this means server bullet classes can be deprecated
function SetAsServerBullet()
{
    RemoteRole = ROLE_None;
}

// Matt: modified to keep tracer rotation matched to it's direction of travel - emptied function does nothing as we no longer use Tick to do delayed destruction on a server
simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (bIsTracerBullet && Level.NetMode != NM_DedicatedServer)
    {
        SetRotation(rotator(Velocity));
    }
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (DH_VehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        LastTouched = Other;

        if (Velocity == vect(0.0,0.0,0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other,Location);
            LastTouched = none;
        }
        else
        {
            if (Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
            {
                HitLocation = Location;
            }

            ProcessTouch(Other, HitLocation);
            LastTouched = none;

            if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none)
            {
                ClientSideTouch(Other, HitLocation);
            }
        }
    }
}

// Matt: modified to handle tracer bullet clientside effects, as well as normal bullet functionality, plus handling of hit on a vehicle weapon similar to a shell
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector             X, Y, Z;
    local float              V;
    local bool               bHitWhipAttachment, bHitVehicleDriver;
    local ROVehicleWeapon    HitVehicleWeapon;
    local ROVehicleHitEffect VehEffect;
    local DH_Pawn            HitPawn;
    local vector             TempHitLocation, HitNormal;
    local array<int>         HitPoints;
    local float              BulletDistance;
    local bool               bDoDeflection;

    if (bDebugMode && !bHasDeflected)
    {
        if (Pawn(Other) != none)
        {
            if (Instigator != none)
            {
                Instigator.ClientMessage("ProcessTouch" @ Other @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health @ "Velocity" @ VSize(Velocity));
            }

            Log(self @ " >>> ProcessTouch" @ Pawn(Other).PlayerReplicationInfo.PlayerName @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health @ "Velocity" @ VSize(Velocity));
        }

        Log(">>>" @ Other @ "==" @ Instigator @ "||" @ Other.Base @ "==" @ Instigator @ "||" @ !Other.bBlockHitPointTraces);
    }

    if (SavedTouchActor == Other || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces)
    {
        return;
    }

    if (bDebugMode && !bHasDeflected)
    {
        Log(">>> ProcessTouch 3");
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);

    // We hit a VehicleWeapon // Matt: added this block to handle VehicleWeapon 'driver' hit detection much better (very similar to a shell)
    if (HitVehicleWeapon != none)
    {
        // We hit the Driver's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the Driver
            if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
            {
                bHitVehicleDriver = true;
            }
            else
            {
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor

                return;
            }
        }
        else if (Level.NetMode != NM_DedicatedServer)
        {
            VehEffect = Spawn(class'ROVehicleHitEffect', , , HitLocation, rotator(Normal(Velocity)));
            VehEffect.InitHitEffects(HitLocation, Normal(-Velocity));

            if (bIsTracerBullet)
            {
                bDoDeflection = true;
            }
        }
    }

    V = VSize(Velocity);

    if (bDebugMode && !bHasDeflected)
    {
        Log(">>> ProcessTouch 4" @ Other);

        if (Pawn(Other) != none)
        {
            if (Instigator != none)
            {
                Instigator.ClientMessage("ProcessTouch Velocity" @ VSize(Velocity) @ Velocity);
            }

            Log(self @ ">>> ProcessTouch Velocity" @ VSize(Velocity) @ Velocity);
        }
    }

    // If the bullet collides right after launch, it doesn't have any velocity yet - use the rotation instead & give it the default speed - Ramm
    if (V < 25.0)
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> ProcessTouch 5a ... V < 25");
        }

        GetAxes(Rotation, X, Y, Z);
        V = default.Speed;
    }
    else
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> ProcessTouch 5b ... GetAxes");
        }

        GetAxes(rotator(Velocity), X, Y, Z);
    }

    if (ROBulletWhipAttachment(Other) != none)
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> ProcessTouch ROBulletWhipAttachment ... ");
        }

        if (!Other.Base.bDeleteMe)
        {
            if (!bHasDeflected)
            {
                // If bullet collides immediately after launch, it has no location (or so it would appear, go figure) - let's check against the firer's location instead
                if (OrigLoc == vect(0.0,0.0,0.0))
                {
                    OrigLoc = Instigator.Location;
                }

                BulletDistance = VSize(Location - OrigLoc) / 60.352; // calculate distance travelled by bullet in metres

                // If it's FF at close range, we won't suppress, so send a different WT through
                if (BulletDistance < 10.0 && Instigator != none && Instigator.Controller != none && Other != none && DH_Pawn(Other.Base) != none && 
                    DH_Pawn(Other.Base).Controller != none && Instigator.Controller.SameTeamAs(DH_Pawn(Other.Base).Controller))
                {
                    WhizType = 3;
                }
                // Bullets only "snap" after a certain distance in reality, same goes here
                else if (BulletDistance < 20.0 && WhizType == 1)
                {
                    WhizType = 2;
                }
            }

            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation, , WhizType);

            if (!bHasDeflected)
            {
                if (bDebugMode)
                {
                    Log(">>> ProcessTouch HitPointTrace ... " @ Other);
                }

                if (Other == none)
                {
                    WhizType = default.WhizType; // reset for the next collision

                    return;
                }
            }

            HitPawn = DH_Pawn(Other);

            if (HitPawn == none)
            {
                bHitWhipAttachment = true;
            }
        }
        else
        {
            return;
        }
    }

    if (!bHasDeflected)
    {
        if (bDebugMode)
        {
            Log(">>> ProcessTouch MinPenetrateVelocity ... " @ V @ ">" @ (MinPenetrateVelocity * ScaleFactor));
        }

        if (V > MinPenetrateVelocity * ScaleFactor)
        {
            if (Role == ROLE_Authority)
            {
                if (HitPawn != none)
                {
                    if (bDebugMode)
                    {
                        Log(">>> ProcessTouch ProcessLocationalDamage ... " @ HitPawn);
                    }

                    if (!HitPawn.bDeleteMe)
                    {
                        HitPawn.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType, HitPoints);
                    }
                }
                else
                {
                    if (bHitVehicleDriver) // Matt: added to call TakeDamage directly on the Driver if we hit him
                    {
                        if (VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                        {
                            if (bDebugMode)
                            {
                                Log(">>> ProcessTouch VehicleWeaponPawn.Driver.TakeDamage ... " @ VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver);
                            }

                            VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
                        }
                    }
                    else
                    {
                        if (bDebugMode)
                        {
                            Log(">>> ProcessTouch Other.TakeDamage ... " @ Other);
                        }

                        Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
                    }
                }
            }
            else
            {
                if (bDebugMode)
                {
                    Log(">>> ProcessTouch Nothing Clientside... ");
                }
            }
        }

        if (bDebugMode && Pawn(Other) != none)
        {
            if (Instigator != none)
            {
                Instigator.ClientMessage("result ProcessTouch" @ Other @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health);
            }

            Log(self @ " >>> result ProcessTouch" @ Pawn(Other).PlayerReplicationInfo.PlayerName @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health);
        }
    }

    if (!bHitWhipAttachment)
    {
        // bDoDeflection is true means this must be a tracer that has hit a VehicleWeapon & not on dedicated server - so deflect unless bullet speed is low
        if (bDoDeflection && VSizeSquared(Velocity) > 500000.0)
        {
            // Matt: added this trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
            Trace(TempHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true);
            Deflect(HitNormal);
        }
        else
        {
            Destroy();
        }
    }
}

// Matt: modified to remove delayed destruction of bullet on a server, as serves no purpose for a bullet
// Bullet is bNetTemporary, meaning it gets torn off on client as soon as it replicates, receiving no further input from server, so delaying destruction on server has no effect
// Also to handle tracer bullet clientside effects, as well as normal bullet functionality
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicleHitEffect      VehEffect;
    local RODestroyableStaticMesh DestroMesh;

    if (WallHitActor != none && WallHitActor == Wall)
    {
        if (bIsTracerBullet)
        {
            // Deflect off wall unless bullet speed is very low
            if (Level.NetMode != NM_DedicatedServer && VSizeSquared(Velocity) >= 250000.0)
            {
                Deflect(HitNormal);
            }
            else
            {
                bBounce = false;
                Bounces = 0;
                Destroy();
            }
        }

        return;
    }

    WallHitActor = Wall;
    DestroMesh = RODestroyableStaticMesh(Wall);

    if (Role == ROLE_Authority && !bHasDeflected)
    {
        // Have to use special damage for vehicles, otherwise it doesn't register for some reason - Ramm
        if (ROVehicle(Wall) != none)
        {
            Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
        }
        else if (Mover(Wall) != none || DestroMesh != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
        {
            Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
        }

        MakeNoise(1.0);
    }

    // Spawn the bullet hit effect
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (ROVehicle(Wall) != none)
        {
            VehEffect = Spawn(class'ROVehicleHitEffect', , , Location, rotator(-HitNormal));
            VehEffect.InitHitEffects(Location, HitNormal);
        }
        else if (ImpactEffect != none)
        {
            Spawn(ImpactEffect, , , Location, rotator(-HitNormal));
        }
    }

	if (!bHasDeflected)
    {
        super(ROBallisticProjectile).HitWall(HitNormal, Wall); // is debug only
    }

    // Don't want to destroy the bullet if its going through something like glass
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        return;
    }

    // Matt: removed the section that used to "Give the bullet a little time to play the hit effect client side before destroying the bullet"

    if (bIsTracerBullet)
    {
        // Deflect off wall unless bullet speed is low
        if (Level.NetMode != NM_DedicatedServer && VSizeSquared(Velocity) >= 500000.0)
        {
            Deflect(HitNormal);
        }
        else
        {
            bBounce = false;
            Bounces = 0;
            Destroy();
        }
    }
    else
    {
        Destroy();
    }
}

// New function to handle tracer deflection off things
simulated function Deflect(vector HitNormal)
{
    local vector VNorm;

    bHasDeflected = true;

    if (TracerEffect != none && VSizeSquared(Velocity) < 750000.0)
    {
        TracerEffect.Destroy();
    }

    if (StaticMesh != DeflectedMesh)
    {
        SetStaticMesh(DeflectedMesh);
    }

    SetPhysics(PHYS_Falling);
    bTrueBallistics = false;
    Acceleration = PhysicsVolume.Gravity;

    if (Bounces > 0)
    {
        Velocity *= 0.6;

        // Reflect off Wall with damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        VNorm = VNorm + VRand() * FRand() * 5000.0; // add random spread
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Bounces--;
    }
    else
    {
        bBounce = false;
    }
}

// Modified to destroy tracer when it falls to ground
simulated function Landed(vector HitNormal)
{
    if (bIsTracerBullet)
    {
        SetPhysics(PHYS_None);
        Destroy();
    }
}

// Modified to destroy any tracer effect
simulated function Destroyed()
{
    if (TracerEffect != none)
    {
        TracerEffect.Destroy();
    }
}

defaultproperties
{
    WhizType=1
    ImpactEffect=class'DH_Effects.DH_BulletHitEffect'
    WhizSoundEffect=class'DH_Effects.DH_BulletWhiz'

    // Tracer properties:
    DrawType=DT_StaticMesh
    DrawScale=2.0
    TracerPullback=150.0
    bBounce=true
    Bounces=2
    DampenFactor=0.1
    DampenFactorParallel=0.05
    LightType=LT_Steady
    LightBrightness=90.0
    LightRadius=10.0
    LightHue=45
    LightSaturation=128
    LightCone=16
    bDynamicLight=true
    bUnlit=true
    AmbientGlow=254
}
