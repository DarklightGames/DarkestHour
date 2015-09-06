//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMinefield_ATMine extends ROMine;

var     Vehicle     HurtVehicle; // records the vehicle that triggered the mine & has already been damaged, so we can avoid HurtRadius() from damaging it again

// Overridden to explode on vehicles only
// Matt: also to handle new collision mesh actor - if touched by col mesh, we switch touching actor to be col mesh's owner & proceed as if we'd been touched by that actor instead
singular function Touch(Actor Other)
{
    local int RandomNum;

    if (Other.IsA('DHCollisionMeshActor'))
    {
        Other = Other.Owner;
    }

    if (Vehicle(Other) == none)
    {
        return;
    }

    if (Role == ROLE_Authority)
    {
        HurtVehicle = Vehicle(Other); // recorded so we can avoid it being damaged again in HurtRadius()

        // Hurt the vehicle itself
        Other.TakeDamage(Damage, none, Location, Location, MyDamageType);

        if (DHArmoredVehicle(Other) != none)
        {
            // Lets possibly de-track the vehicle (80% chance)
            RandomNum = Rand(100);

            if (RandomNum < 80)
            {
                if (vector(Other.Rotation) dot Normal(Location - Other.Location) > 0.0)
                {
                    DHArmoredVehicle(Other).DamageTrack(true);
                }
                else
                {
                    DHArmoredVehicle(Other).DamageTrack(false);
                }
            }
        }

        // Hurt others around it
        HurtRadius(Damage, DamageRadius, MyDamageType, Momentum, Location);

        // Disable mine's collision, as it has exploded
        SetCollision(false, false, false);
    }

    SpawnExplosionEffects();
}

// Modified to avoid re-damaging the vehicle that triggered the mine, & to check whether a vehicle is shielding a hit actor from the blast
// Matt: also to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  Victims, TraceHitActor;
    local vector Direction, TraceHitLocation, TraceHitNormal;
    local float  DamageScale, Distance;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    // Find all colliding actors within blast radius, which the blast should damage
    foreach VisibleCollidingActors(class'Actor', Victims, DamageRadius, HitLocation)
    {
        // If hit collision mesh actor, switch to its owner
        if (Victims.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victims).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victims = Victims.Owner;
        }

        // Don't damage this actor, the vehicle that triggered the mine (already damaged), non-authority actors, or fluids
        if (Victims != self && HurtVehicle != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            // Do a trace to the actor & if there's a vehicle between it & the explosion, don't apply damage
            TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, HitLocation);

            if (Vehicle(TraceHitActor) != none && TraceHitActor != Victims)
            {
                continue;
            }

            // Calculate damage based on distance from explosion
            Direction = Victims.Location - HitLocation;
            Distance = FMax(1.0, VSize(Direction));
            Direction = Direction / Distance;
            DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

            // Damage the actor hit by the blast - if it's a vehicle, check for damage to any occupants
            Victims.TakeDamage(DamageScale * DamageAmount, none, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Direction,
                DamageScale * Momentum * Direction, DamageType);

            if (ROVehicle(Victims) != none && ROVehicle(Victims).Health > 0)
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Victims), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
            }
        }
    }

    // Re-set
    HurtVehicle = none;
    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius()
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
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
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Distance, DamageScale;

    if (P != none)
    {
        HeadBoneCoords = P.GetBoneCoords(P.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((P.HeadHeight + (0.5 * P.HeadRadius)) * P.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
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
            P.TakeDamage(DamageScale * DamageAmount, none, P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction, DamageScale * Momentum * Direction, DamageType);
        }
    }
}

defaultproperties
{
    Damage=525
    DamageRadius=512.0
    MyDamageType=class'DH_LevelActors.DHATMineDamage'
    Momentum=3000.0
    bHidden=true
}
