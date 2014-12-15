//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Bullet extends ROBullet
    config(DH_Penetration)
    abstract;

var int   WhizType; // Sent in HitPointTrace for ROBulletWhipAttachment to only do snaps for supersonic rounds (0 = none, 1 = close supersonic bullet, 2 = subsonic or distant bullet)
var Actor SavedTouchActor; // Matt: added (same as shell) to prevent recurring ProcessTouch on same actor (e.g. was screwing up tracer ricochets from VehicleWeapons like turrets)

var globalconfig bool   bDebugMode;         // If true, give our detailed report in log.
var globalconfig bool   bDebugROBallistics; // If true, set bDebugBallistics to true for getting the arrow pointers

simulated function PostBeginPlay()
{
    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    super.PostBeginPlay();

    OrigLoc = Location;
}

// Matt: emptied out as no longer using Tick to give delayed destruction on a server
simulated function Tick(float DeltaTime)
{
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
        if (Role == ROLE_Authority)
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

    if (!bHitWhipAttachment)
    {
        Destroy();
    }
}

// Matt: modified to use much simpler method for delayed bullet destruction on a server & to include a listen server as well as dedicated
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicleHitEffect      VehEffect;
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

    super(ROBallisticProjectile).HitWall(HitNormal, Wall); // is debug only

    // Don't want to destroy the bullet if its going through something like glass
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        return;
    }

    // Give the bullet a little time to play the hit effect client side before destroying the bullet
    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        LifeSpan = DestroyTime; // bCollided = true; // Matt: setting a short LifeSpan is a much simpler way to give delayed destruction on server, avoiding need to use Tick
        SetCollision(false, false);
        bCollideWorld = false; // Matt: added to prevent continuing calls to HitWall on server, while bullet persists
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
    WhizType=1
    ImpactEffect=class'DH_Effects.DH_BulletHitEffect'
    WhizSoundEffect=class'DH_Effects.DH_BulletWhiz'
}
