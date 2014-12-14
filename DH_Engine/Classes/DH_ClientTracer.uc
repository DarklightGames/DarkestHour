//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ClientTracer extends DH_ClientBullet
    abstract;

var     class<Emitter>  mTracerClass;
var()   Emitter         mTracer;
var()   float           mTracerPullback;
var     byte            Bounces;
var()   float           DampenFactor;
var()   float           DampenFactorParallel;
var     StaticMesh      DeflectedMesh;

// var()   float        mTracerInterval; // Matt: not used
// var()   Effects      Corona;          // Matt: not used


// Modified to spawn tracer effect
simulated function PostBeginPlay()
{
    if (Level.bDropDetail)
    {
        bDynamicLight = false;
        LightType = LT_None;
    }

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        mTracer = Spawn(mTracerClass, self, , (Location + Normal(Velocity) * mTracerPullback));
    }

    SetRotation(rotator(Velocity));
}

// Modified to keep tracer rotation matched to it's direction of travel
simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    SetRotation(rotator(Velocity));
}

// Modified to add deflection & to remove stuff nor relevant to a clientside 'fake' tracer bullet
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local Vector             X, Y, Z;
    local float              V;
    local bool               bHitWhipAttachment;
    local ROVehicleWeapon    HitVehicleWeapon;
    local ROVehicleHitEffect VehEffect;
//  local DH_Pawn            HitPawn;
    local Vector             TempHitLocation, HitNormal;
    local array<int>         HitPoints;
    local bool               bDeflect;

    if (SavedTouchActor == Other || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces) // Matt: added SavedTouchActor to prevent recurring ProcessTouches
    {
        return;
    }

    SavedTouchActor = Other; // Matt: added
    HitVehicleWeapon = ROVehicleWeapon(Other);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none)
    {
        // We hit the Driver's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the Driver
            if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
            {
            }
            else
            {
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor

                return;
            }
        }
        else if (Level.NetMode != NM_DedicatedServer)
        {
            // Spawn the bullet hit effect // Matt: only if tracer has already deflected, meaning real bullet no longer exists , otherwise we end up doubling up the hit effect
            if (Bounces < default.Bounces)
            {
                VehEffect = Spawn(class'ROVehicleHitEffect', , , HitLocation, rotator(Normal(Velocity)));
                VehEffect.InitHitEffects(HitLocation, Normal(-Velocity));
            }

            bDeflect = true;
        }
    }

    V = VSize(Velocity);

    // If the bullet collides right after launch, it doesn't have any velocity yet.
    // Use the rotation instead and give it the default speed - Ramm
    if (V < 25.0)
    {
        GetAxes(Rotation, X, Y, Z);
        V = default.Speed;
    }
    else
    {
        GetAxes(rotator(Velocity), X, Y, Z);
    }

    if (ROBulletWhipAttachment(Other) != none)
    {
//      bHitWhipAttachment=true;

        if (!Other.Base.bDeleteMe) // Matt: added if/else, same as bullets, as seems just as relevant
        {
            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation, , 1);

//          HitPawn = DH_Pawn(Other);

            if (DH_Pawn(Other) == none) // Matt: added to refactor, replacing various HitPawn & bHitWhipAttachment lines (means we didn't actually register a hit on the player)
            {
                bHitWhipAttachment = true;
            }
        }
        else
        {
            return;
        }
    }

//  if (HitPawn != none)
//  {
//      bHitWhipAttachment = false;
//  }

    if (!bHitWhipAttachment)
    {
        // Must have hit VehicleWeapon so deflect unless bullet speed is low
        if (bDeflect && VSizeSquared(Velocity) > 500000.0)
        {
            // Matt: added this trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
            Trace(TempHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50, true);
            Deflect(HitNormal); // was Deflect(Normal(-Velocity));
        }
        else
        {
            Destroy();
        }
    }
}

// Modified to add deflection (& also remove causing damage, although would not happen on a client anyway as not an authority role)
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicleHitEffect      VehEffect;
//  local RODestroyableStaticMesh DestroMesh;

    if (WallHitActor != none && WallHitActor == Wall)
    {
        // Deflect off wall unless bullet speed is very low
        if (VSizeSquared(Velocity) < 250000.0)
        {
            bBounce = false;
            Bounces = 0;
            Destroy();
        }
        else
        {
            Deflect(HitNormal);
        }

        return;
    }

    WallHitActor = Wall;
//  DestroMesh = RODestroyableStaticMesh(Wall); // Matt: removed as unnecessary

    // Spawn the bullet hit effect // Matt: only if tracer has already deflected, meaning real bullet no longer exists , otherwise we end up doubling up the hit effect
    if (Bounces < default.Bounces && Level.NetMode != NM_DedicatedServer)
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

//  super(ROBallisticProjectile).HitWall(HitNormal, Wall); // Matt: removed as is debug only & not necessary for tracer

    // Don't want to destroy the bullet if its going through something like glass
    if (RODestroyableStaticMesh(Wall) != none && RODestroyableStaticMesh(Wall).bWontStopBullets)
    {
        return;
    }

    // Give the bullet a little time to play the hit effect client side before destroying the bullet // Matt: removed as client tracer will never exist on a server
//  if (Level.NetMode == NM_DedicatedServer)
//  {
//      bCollided = true;
//      SetCollision(false, false);
//  }
//  else
//  {
        // Deflect off wall unless bullet speed is low
        if (VSizeSquared(Velocity) < 500000.0)
        {
            bBounce = false;
            Bounces = 0;
            Destroy();
        }
        else
        {
            Deflect(HitNormal);
        }
//  }
}

// New function to handle tracer deflection off things
simulated function Deflect(vector HitNormal)
{
    local vector VNorm;

    if (mTracer != none && VSizeSquared(Velocity) < 750000.0)
    {
        mTracer.Destroy();
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
    SetPhysics(PHYS_None);
    Destroy();
}

// Modified to destroy the tracer effect
simulated function Destroyed()
{
    if (mTracer != none)
    {
        mTracer.Destroy();
    }

//  if (Corona != none) // Matt: removed as not used
//  {
//      Corona.destroy();
//  }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    DrawScale=2.000000

    mTracerPullback=150.00
    bBounce=true
    Bounces=2
    DampenFactor=0.1
    DampenFactorParallel=0.05

    LightType=LT_Steady
    LightBrightness=90.000000
    LightRadius=10.000000
    LightHue=45
    LightSaturation=128
    LightCone=16
    bDynamicLight=true
    bUnlit=true
    AmbientGlow=254
}
