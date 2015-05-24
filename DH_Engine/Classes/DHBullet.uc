//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBullet extends ROBullet
    config
    abstract;

// General
var     int             WhizType;        // sent in HitPointTrace to only do snaps for supersonic rounds (0 = none, 1 = close supersonic bullet, 2 = subsonic or distant bullet)
var     Actor           SavedTouchActor; // added (same as shell) to prevent recurring ProcessTouch on same actor (e.g. was screwing up tracer ricochets from VehicleWeapons like turrets)

// Tracers
var     bool            bIsTracerBullet; // just set to true in a tracer bullet subclass of a normal bullet & then the inheritance from this class will handle everything
var     bool            bHasDeflected;
var     byte            Bounces;
var     StaticMesh      DeflectedMesh;
var     class<Emitter>  TracerEffectClass;
var     Emitter         TracerEffect;
var     float           TracerPullback;
var     float           DampenFactor;
var     float           DampenFactorParallel;

// Debugging
var globalconfig bool   bDebugMode;         // if true, give a detailed report in log & some screen messages
var globalconfig bool   bDebugROBallistics; // if true, set bDebugBallistics to true for getting the arrow pointers

// Modified to move bDebugBallistics stuff to PostNetBeginPlay, as net client won't yet have Instigator here
simulated function PostBeginPlay()
{
    OrigLoc = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority && Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
    {
        Velocity *= 0.5;
    }
}

// Modified to set InstigatorController, to set tracer properties if this is a tracer bullet, & to move bDebugBallistics stuff here from PostBeginPlay (with bDebugROBallistics option)
simulated function PostNetBeginPlay()
{
    local Actor  TraceHitActor;
    local vector HitNormal;
    local float  TraceRadius;

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }

    if (bIsTracerBullet && Level.NetMode != NM_DedicatedServer)
    {
        SetDrawType(DT_StaticMesh);
//      SetRotation(rotator(Velocity)); // removed as simply setting bOrientToVelocity handles this natively (replacing use of Tick)
        bOrientToVelocity = true;

        if (Level.bDropDetail)
        {
            bDynamicLight = false;
//          LightType = LT_None; // is default anyway
        }
        else
        {
            bDynamicLight = true;
            LightType = LT_Steady;
        }

        LightBrightness = 90.0;
        LightRadius = 10.0;
        LightHue = 45;
        LightSaturation = 128;
        AmbientGlow = 254;
        LightCone = 16;

        TracerEffect = Spawn(TracerEffectClass, self,, (Location + Normal(Velocity) * TracerPullback));
    }

    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    if (bDebugBallistics)
    {
        TraceRadius = 5.0;

        if (Instigator != none)
        {
            TraceRadius += Instigator.CollisionRadius;
        }

        TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), Location + TraceRadius * vector(Rotation), true);

        if (ROBulletWhipAttachment(TraceHitActor) != none)
        {
            TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), TraceHitLoc + 5.0 * vector(Rotation), true);
        }

        Log("Bullet debug tracing: TraceHitActor =" @ TraceHitActor);
    }
}

// Matt: new function, called by DHFastAutoFire's SpawnProjectile function to set this as a server bullet, meaning won't be replicated as a separate client bullet will be spawned on client
// RemoteRole = none was the only change in DH_ServerBullet that had any effect, so simply doing this means server bullet classes can be deprecated
function SetAsServerBullet()
{
    RemoteRole = ROLE_None;
}

// Matt: disabled as function now emptied out - see comments below
simulated function Tick(float DeltaTime)
{
    Disable('Tick');

//  super.Tick(DeltaTime); // ROBullet Super is not needed as delayed destruction on a server is handled far more efficiently by simply setting a short LifeSpan on a server

//  if (bIsTracerBullet && Level.NetMode != NM_DedicatedServer)
//  {
//      SetRotation(rotator(Velocity)); // keep tracer rotation matched to it's direction // not needed as simply setting bOrientToVelocity handles this natively
//  }
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (DHVehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        LastTouched = Other;

        if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other, Location);
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
    local ROVehicleWeapon    HitVehicleWeapon;
    local ROVehicleHitEffect VehEffect;
    local DHPawn             HitPawn;
    local vector             TempHitLocation, HitNormal, X, Y, Z;
    local array<int>         HitPoints;
    local float              BulletDistance, V;
    local bool               bDoDeflection, bHitWhipAttachment, bHitVehicleDriver;

    if (bDebugMode && !bHasDeflected)
    {
        if (Pawn(Other) != none)
        {
            if (Instigator != none)
            {
                Instigator.ClientMessage("Bullet.ProcessTouch on" @ Other.Tag @ " Health =" @ Pawn(Other).Health @ " HitLoc =" @ HitLocation @ "Velocity =" @ VSize(Velocity));
            }

            Log(Tag @ ">>> Bullet.ProcessTouch on" @ Pawn(Other).PlayerReplicationInfo.PlayerName @ " Health =" @ Pawn(Other).Health @ " HitLoc =" @ HitLocation @
                " Velocity =" @ VSize(Velocity) @ " Instigator =" @ Instigator.Tag);
        }
        else
        {
            Log(Tag @ ">>> Bullet.ProcessTouch on" @ Other.Tag @ " HitLoc =" @ HitLocation @ " Velocity =" @ VSize(Velocity) @ " Instigator =" @ Instigator.Tag);
        }
    }

    // Exit without doing anything if we hit something we don't want to count a hit on
    if (Other == none || SavedTouchActor == Other || Other.bDeleteMe || !Other.bBlockHitPointTraces ||
        Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    if (bDebugMode && !bHasDeflected)
    {
        Log(">>> Bullet.ProcessTouch: passed initial 'do nothing' checks");
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);

    // We hit a VehicleWeapon // added this block to handle VehicleWeapon 'driver' hit detection much better (very similar to a shell)
    if (HitVehicleWeapon != none)
    {
        // We hit the player's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the player
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
        // We didn't hit the player's collision box, so show the bullet impact effects
        else if (Level.NetMode != NM_DedicatedServer)
        {
            VehEffect = Spawn(class'ROVehicleHitEffect',,, HitLocation, rotator(Normal(Velocity)));
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
        Log(">>> Bullet.ProcessTouch: V =" @ V @ " Velocity =" @ Velocity @ "(bHitVehicleDriver =" @ bHitVehicleDriver $ ")");

        if (Pawn(Other) != none && Instigator != none)
        {
            Instigator.ClientMessage("Bullet.ProcessTouch: V =" @ V @ " Velocity =" @ Velocity @ "(bHitVehicleDriver =" @ bHitVehicleDriver $ ")");
        }
    }

    // If the bullet collides right after launch, it doesn't have any velocity yet - use the rotation instead & give it the default speed
    if (V < 25.0)
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> Bullet.ProcessTouch: V < 25, GetAxes");
        }

        GetAxes(Rotation, X, Y, Z);
        V = default.Speed;
    }
    else
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> Bullet.ProcessTouch: V >= 25, GetAxes");
        }

        GetAxes(rotator(Velocity), X, Y, Z);
    }

    // We hit the WhipAttachment around a player pawn
    if (ROBulletWhipAttachment(Other) != none)
    {
        if (bDebugMode && !bHasDeflected)
        {
            Log(">>> Bullet.ProcessTouch: hit ROBulletWhipAttachment");
        }

        if (Other.Base.bDeleteMe)
        {
            return;
        }

        // Set WhizType for possible bullet snap sound
        if (!bHasDeflected)
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure) - let's check against the firer's location instead
            if (OrigLoc == vect(0.0, 0.0, 0.0))
            {
                OrigLoc = Instigator.Location;
            }

            BulletDistance = VSize(Location - OrigLoc) / 60.352; // calculate distance travelled by bullet in metres

            // If it's FF at close range, we won't suppress, so send a different WT through
            if (BulletDistance < 10.0 && InstigatorController != none && Other != none && DHPawn(Other.Base) != none &&
                DHPawn(Other.Base).Controller != none && InstigatorController.SameTeamAs(DHPawn(Other.Base).Controller))
            {
                WhizType = 3;
            }
            // Bullets only "snap" after a certain distance in reality, same goes here
            else if (BulletDistance < 20.0 && WhizType == 1)
            {
                WhizType = 2;
            }
        }

        // Check if we hit the player pawn's various body hit points
        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation,, WhizType);

        if (!bHasDeflected)
        {
            if (bDebugMode)
            {
                Log(">>> Bullet.ProcessTouch: HitPointTrace returned" @ Other);
            }

            if (Other == none)
            {
                WhizType = default.WhizType; // reset for the next collision

                return;
            }
        }

        HitPawn = DHPawn(Other);

        // Didn't actually hit the player pawn, so just flag that we hit the WhipAttachment
        if (HitPawn == none)
        {
            bHitWhipAttachment = true;
        }
    }

    if (!bHasDeflected)
    {
        if (bDebugMode)
        {
            Log(">>> Bullet.ProcessTouch: V =" @ V @ " (MinPenetrateVelocity * ScaleFactor) =" @ MinPenetrateVelocity * ScaleFactor);
        }

        if (V > MinPenetrateVelocity * ScaleFactor)
        {
            // Do any damage
            if (Role == ROLE_Authority)
            {
                UpdateInstigator();

                // Damage a player pawn
                if (HitPawn != none)
                {
                    if (bDebugMode)
                    {
                        Log(">>> Bullet.ProcessTouch: ProcessLocationalDamage on HitPawn" @ HitPawn.Tag);
                    }

                    if (!HitPawn.bDeleteMe)
                    {
                        HitPawn.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType, HitPoints);
                    }
                }
                else
                {
                    // Added to call TakeDamage directly on a vehicle's 'Driver' if we hit him
                    if (bHitVehicleDriver)
                    {
                        if (VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                        {
                            if (bDebugMode)
                            {
                                Log(">>> Bullet.ProcessTouch: VehicleWeaponPawn.Driver.TakeDamage on" @ VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.Tag);
                            }

                            VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
                        }
                    }
                    // Damage something else
                    else
                    {
                        if (bDebugMode)
                        {
                            Log(">>> Bullet.ProcessTouch: Other.TakeDamage on" @ Other.Tag);
                        }

                        // Fail-safe to make certain bProjectilePenetrated is always false for a bullet
                        if (HitVehicleWeapon != none && DHTreadCraft(HitVehicleWeapon.Base) != none)
                        {
                            DHTreadCraft(HitVehicleWeapon.Base).bProjectilePenetrated = false;
                        }

                        Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
                    }
                }
            }
            else
            {
                if (bDebugMode)
                {
                    Log(">>> Bullet.ProcessTouch: no damage on net client");
                }
            }
        }

        if (bDebugMode && Pawn(Other) != none)
        {
            if (Instigator != none)
            {
                Instigator.ClientMessage("Bullet.ProcessTouch: RESULT on" @ Other.Tag @ " Health =" @ Pawn(Other).Health @ " HitLoc =" @ HitLocation);
            }

            Log(self @ ">>> Bullet.ProcessTouch: RESULT on" @ Pawn(Other).PlayerReplicationInfo.PlayerName @ " Health =" @ Pawn(Other).Health @ " HitLoc =" @ HitLocation);
        }
    }

    if (bDebugMode)
    {
        Log(">>> ------------------------------------------------------------------------------------------------------------"); // separating line in log
    }

    if (!bHitWhipAttachment)
    {
        // bDoDeflection is true means this must be a tracer that has hit a VehicleWeapon & not on dedicated server - so deflect unless bullet speed is low
        if (bDoDeflection && VSizeSquared(Velocity) > 500000.0)
        {
            // Added this trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
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
    local RODestroyableStaticMesh DestroMesh;
    local ROVehicleHitEffect      VehEffect;

    // Hit WallHitActor that we've already hit & recorded
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

    // Do any damage
    if (Role == ROLE_Authority && !bHasDeflected)
    {
        UpdateInstigator();

        // Have to use special damage for vehicles, otherwise it doesn't register for some reason
        if (ROVehicle(Wall) != none)
        {
            // Fail-safe to make certain bProjectilePenetrated is always false for a bullet
            if (DHTreadCraft(Wall) != none)
            {
                DHTreadCraft(Wall).bProjectilePenetrated = false;
            }

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
            VehEffect = Spawn(class'ROVehicleHitEffect',,, Location, rotator(-HitNormal));
            VehEffect.InitHitEffects(Location, HitNormal);
        }
        else if (ImpactEffect != none)
        {
            Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
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

    // Removed the section that used to "Give the bullet a little time to play the hit effect client side before destroying the bullet"

    // Finally destroy this bullet, or maybe deflect if is tracer
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

// New function to update Instigator reference to ensure damage is attributed to correct player, as player may have switched to different pawn since firing, e.g. changed vehicle position
simulated function UpdateInstigator()
{
    if (InstigatorController != none)
    {
        Instigator = InstigatorController.Pawn;
    }
    else
    {
        Instigator = none;
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
    ImpactEffect=class'DH_Effects.DHBulletHitEffect'
    WhizSoundEffect=class'DH_Effects.DHBulletWhiz'

    // Tracer properties (won't affect ordinary bullet):
    DrawScale=2.0
    TracerPullback=150.0
    bBounce=true
    Bounces=2
    DampenFactor=0.1
    DampenFactorParallel=0.05
}
