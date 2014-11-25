//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ServerBullet extends DH_Bullet // Matt: originally extended ROServerBullet
    abstract;


simulated function PostBeginPlay() // TEMP to log
{
    log("Server bullet spawned");
    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    super(ROBullet).PostBeginPlay();

    OrigLoc = Location;
}
/*

// Matt: variables now inherited from DH_Bullet:
var globalconfig bool   bDebugMode;
var globalconfig bool   bDebugROBallistics;
var int                 WhizType;


simulated function PostBeginPlay() // Matt: DH_Bullet does this now
{
    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    super.PostBeginPlay();
}

simulated function ProcessTouch(Actor Other, vector HitLocation) // Matt: was in DH_ServerBullet, but exactly the same as DH_Bullet
{
    local vector             X, Y, Z;
    local float              V;
    local bool               bHitWhipAttachment;
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

    if (Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces)
    {
        return;
    }

    if (bDebugMode)
    {
        Log(">>> ProcessTouch 3");
    }

    if (Level.NetMode != NM_DedicatedServer) // note this is relevant as server bullet is spawned on standalone or listen server
    {
        if (ROVehicleWeapon(Other) != none && !ROVehicleWeapon(Other).HitDriverArea(HitLocation, Velocity))
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

//          if (HitPawn == none) // Matt: added to refactor, replacing various bHitWhipAttachment lines (means we didn't actually register a hit on the player)
//          {
//              bHitWhipAttachment = true;
//          }
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
        if (Role == ROLE_Authority) // Matt: this is a server bullet so will always be authority, so this if/else is unnecessary
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
                if (bDebugMode)
                {
                    Log(">>> ProcessTouch Other.TakeDamage ... " @ Other);
                }

                Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
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

// Matt: removed as all this function override did was remove the spawn hit effects block, which is actually needed by a listen server & won't run on a dedicated server anyway !
simulated function HitWall(vector HitNormal, actor Wall)
{
    local ROVehicleHitEffect      VehEffect; // Matt: added back as needed by listen server
    local RODestroyableStaticMesh DestroMesh;

    if (WallHitActor != none && WallHitActor == Wall)
    {
        return;
    }

    WallHitActor = Wall;
    DestroMesh = RODestroyableStaticMesh(Wall);

    if (Role == ROLE_Authority)
    {
        // Have to use special damage for vehicles, otherwise it doesn't register for some reason - Ramm
        if (ROVehicle(Wall) != none)
        {
            Wall.TakeDamage(Damage - 20.0 * (1.0 - VSize(Velocity) / default.Speed), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
        }
        else if (Mover(Wall) != none || DestroMesh != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
        {
            Wall.TakeDamage(Damage - 20.0 * (1.0 - VSize(Velocity) / default.Speed), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
        }

        MakeNoise(1.0);
    }

    // Spawn the bullet hit effect
//  if (Level.NetMode != NM_DedicatedServer) // Matt: added back as needed by listen server
//  {
//      if (ROVehicle(Wall) != none) // Matt: all this function override does is removed this block, which is actually needed by a listen server & won't run on a dedicated server anyway !
//      {
//          VehEffect = Spawn(class'ROVehicleHitEffect', , , Location, rotator(-HitNormal));
//          VehEffect.InitHitEffects(Location, HitNormal);
//      }
        // Spawn the bullet hit effect client side
//      else if (ImpactEffect != none)
//      {
//          Spawn(ImpactEffect, , , Location, rotator(-HitNormal));
//      }
//  }

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
    RemoteRole=ROLE_None // only exists on the server // Matt: this is what this class is all about really - no replication of bullet actor to clients

//  WScale=1.000000           // Matt: not used
//  PenetrationScale=0.080000 // Matt: not used
//  DistortionScale=0.400000  // Matt: not used
//  WhizType=1                // Matt: now inherited from DH_Bullet
}
