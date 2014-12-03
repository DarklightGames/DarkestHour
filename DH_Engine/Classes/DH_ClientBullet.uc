//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ClientBullet extends DH_Bullet // Matt: originally extended ROClientBullet
    abstract;

// Matt: variables now inherited from DH_Bullet:
// var globalconfig bool   bDebugMode;
// var globalconfig bool   bDebugROBallistics;
// var int                 WhizType;


// Matt: this is the function from the original parent ROClientBullet, with a couple of things added from DH_Bullet
simulated function PostBeginPlay()
{
    local Vector HitNormal;
    local Actor  TraceHitActor;

    if (bDebugROBallistics) // from DH_Bullet
    {
        bDebugBallistics = true;
    }

    Acceleration = vect(0.0,0.0,0.0); // new in this class, not sure what it does, maybe something native
    Velocity = vector(Rotation) * Speed;
    BCInverse = 1.0 / BallisticCoefficient;

    if (bDebugBallistics && ROPawn(Instigator) != none) // ROPawn added in this class
    {
        FlightTime = 0.0;
        OrigLoc = Location;

        TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), Location + (Instigator.CollisionRadius + 5.0) * vector(Rotation), true);
        Log("Debug tracing: TraceHitActor=" @ TraceHitActor);

        if (TraceHitActor.IsA('ROBulletWhipAttachment'))
        {
            TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), TraceHitLoc + 5.0 * vector(Rotation), true);
        }

        // super slow debugging (added back in this class - was commented out in ROBallisticProjectile)
        Spawn(class'DH_DebugTracerGreen', self, , TraceHitLoc, Rotation);
    }

    OrigLoc = Location; // from DH_Bullet, as seems necessary for WhizType handling, but wasn't originally being inherited
}
/*
// Matt: this was in DH_ClientBullet, but it's now exactly the same as DH_Bullet & so is pointless
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

    if (bDebugMode && Pawn(Other) != none)
    {
        if (Instigator != none)
        {
            Instigator.ClientMessage("ProcessTouch" @ Other @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health @ "Velocity" @ VSize(Velocity));
        }

        Log(self @ " >>> ProcessTouch" @ Pawn(Other).PlayerReplicationInfo.PlayerName @ "HitLoc" @ HitLocation @ "Health" @ Pawn(Other).Health @ "Velocity" @ VSize(Velocity));
    }

    if (bDebugMode)
    {
        Log(">>>" @ Other @ "==" @ Instigator @ "||" @ Other.Base @ "==" @ Instigator @ "||" @ !Other.bBlockHitPointTraces);
    }

    if (SavedTouchActor == Other || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces)
    {
        return;
    }

    if (bDebugMode)
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
        }
    }

    V = VSize(Velocity);

    if (bDebugMode)
    {
        Log(">>> ProcessTouch 4" @ Other);
    }

    if (bDebugMode && Pawn(Other) != none)
    {
        if (Instigator != none)
        {
            Instigator.ClientMessage("ProcessTouch Velocity" @ VSize(Velocity) @ Velocity);
        }

        Log(self @ ">>> ProcessTouch Velocity" @ VSize(Velocity) @ Velocity);
    }

    // If the bullet collides right after launch, it doesn't have any velocity yet.
    // Use the rotation instead and give it the default speed - Ramm
    if (V < 25.0)
    {
        if (bDebugMode)
        {
            Log(">>> ProcessTouch 5a ... V < 25");
        }

        GetAxes(Rotation, X, Y, Z);
        V = default.Speed;
    }
    else
    {
        if (bDebugMode)
        {
            Log(">>> ProcessTouch 5b ... GetAxes");
        }

        GetAxes(rotator(Velocity), X, Y, Z);
    }

    if (ROBulletWhipAttachment(Other) != none)
    {
        if (bDebugMode)
        {
            Log(">>> ProcessTouch ROBulletWhipAttachment ... ");
        }

//      bHitWhipAttachment = true;

        if (!Other.Base.bDeleteMe)
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure)
            // Lets check against the firer's location instead
            if (OrigLoc == vect(0.0,0.0,0.0))
            {
                OrigLoc = Instigator.Location;
            }

            BulletDistance = VSize(Location - OrigLoc) / 60.352; // Calculate distance travelled by bullet in metres

            // If it's FF at close range, we won't suppress, so send a different WT through
            if (BulletDistance < 10.0 && Instigator != none && Instigator.Controller != none && Other != none && DH_Pawn(Other.Base) != none && 
                DH_Pawn(Other.Base).Controller != none && Instigator.Controller.SameTeamAs(DH_Pawn(Other.Base).Controller))
            {
                WhizType = 3;
            }
            else if (BulletDistance < 20.0 && WhizType == 1) // Bullets only "snap" after a certain distance in reality, same goes here
            {
                WhizType = 2;
            }

            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation, , WhizType);

            if (bDebugMode)
            {
                Log(">>> ProcessTouch HitPointTrace ... " @ Other);
            }

            if (Other == none)
            {
                WhizType = default.WhizType; // Reset for the next collision

                return;
            }

            HitPawn = DH_Pawn(Other);

            if (HitPawn == none) // Matt: added to refactor, replacing various bHitWhipAttachment lines (means we didn't actually register a hit on the player)
            {
                bHitWhipAttachment = true;
            }
        }
        else
        {
            return;
        }
    }

    if (bDebugMode)
    {
        Log(">>> ProcessTouch MinPenetrateVelocity ... " @ V @ ">" @ (MinPenetrateVelocity * ScaleFactor));
    }

    if (V > MinPenetrateVelocity * ScaleFactor)
    {
        if (Role == ROLE_Authority) // Matt: this is a client bullet, so this block is irrelevant
        {
            if (HitPawn != none)
            {
                // Hit detection debugging
                if (bDebugMode)
                {
                    Log(">>> ProcessTouch ProcessLocationalDamage ... " @ HitPawn);
                }

                if (!HitPawn.bDeleteMe)
                {
                    HitPawn.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);
                }

//              bHitWhipAttachment = false;
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

//          if (HitPawn != none)
//          {
//              bHitWhipAttachment = false;
//          }
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

    if (!bHitWhipAttachment)
    {
        Destroy();
    }
}

// Matt: all this function override does is remove the TakeDamage block, but that won't execute on a net client anyway, so this override is pointless
simulated function HitWall(vector HitNormal, actor Wall)
{
    local ROVehicleHitEffect      VehEffect;
    local RODestroyableStaticMesh DestroMesh;

    if (WallHitActor != none && WallHitActor == Wall)
    {
        return;
    }

    WallHitActor = Wall;
    DestroMesh = RODestroyableStaticMesh(Wall);

//  if (Role == ROLE_Authority) // Matt: all this function override does is remove this block, but it won't do anything on a client anyway, so the override is pretty pointless
//  {
        // Have to use special damage for vehicles, otherwise it doesn't register for some reason - Ramm
//      if (ROVehicle(Wall) != none)
//      {
//          Wall.TakeDamage(Damage - 20.0 * (1.0 - VSize(Velocity) / default.Speed), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
//      }
//      else if (Mover(Wall) != none || DestroMesh != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
//      {
//          Wall.TakeDamage(Damage - 20.0 * (1.0 - VSize(Velocity) / default.Speed), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
//      }

//      MakeNoise(1.0);
//  }

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

    super(ROBallisticProjectile).HitWall(HitNormal, Wall);

    // Don't want to destroy the bullet if its going through something like glass
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        return;
    }

    // Give the bullet a little time to play the hit effect client side before destroying the bullet
    if (Level.NetMode == NM_DedicatedServer)
    {
        bCollided = true;
        SetCollision(false, false);
    }
    else
    {
        Destroy();
    }
}
*/

defaultproperties
{
//  WScale=1.000000           // Matt: not used
//  PenetrationScale=0.080000 // Matt: not used
//  DistortionScale=0.400000  // Matt: not used
//  WhizType=1                // Matt: now inherited from DH_Bullet

    ImpactEffect=class'DH_Effects.DH_BulletHitEffect'
    WhizSoundEffect=class'DH_Effects.DH_BulletWhiz'
}
