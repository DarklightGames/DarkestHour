//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMinefield_ATMine extends ROMine;

// Overridden to explode on vehicles only // Matt: also modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
singular function Touch(Actor Other)
{
    local int RandomNum;

    if (DH_VehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

    if (Pawn(Other) == none || Vehicle(Other) == none)
    {
        return;
    }
    
    if (Role == ROLE_Authority)
    {
        // Hurt the vehicle itself
        Other.TakeDamage(Damage, none, Location, Location, MyDamageType);

        if (DH_ROTreadCraft(Other) != none)
        {
            // Lets possibly de-track the vehicle (80% chance)
            RandomNum = Rand(100);

            if (RandomNum < 80)
            {
                if (vector(Other.Rotation) dot Normal(Location - Other.Location) > 0.0)
                {
                    DH_ROTreadCraft(Other).DamageTrack(true);
                }
                else
                {
                    DH_ROTreadCraft(Other).DamageTrack(false);
                }
            }
        }

        // Hurt others around it
        HurtRadius(Damage, DamageRadius, MyDamageType, Momentum, Location);

        SetCollision(false, false, false);
    }

    SpawnExplosionEffects();
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  Victims, LastTouched;
    local float  damageScale, dist;
    local vector dir;
    local vector TraceHitLocation, TraceHitNormal;
    local Actor  TraceHitActor;

    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    foreach VisibleCollidingActors(class 'Actor', Victims, DamageRadius, HitLocation)
    {
        // If hit collision mesh actor then switch to actual VehicleWeapon
        if (DH_VehicleWeaponCollisionMeshActor(Victims) != none)
        {
            Victims = Victims.Owner;
            log(Tag @ "HurtRadius: hit a DH_VehicleWeaponCollisionMeshActor, so switched hit actor to" @ Victims.Tag); // TEMP
        }

        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if (Victims != self && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            // if there's a vehicle between the player and explosion, don't apply damage
            TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, Location);

            if (Vehicle(TraceHitActor) != none && TraceHitActor != Victims)
            {
                continue;
            }

            dir = Victims.Location - HitLocation;
            dist = FMax(1.0, VSize(dir));
            dir = dir / dist;
            damageScale = 1.0 - FMax(0.0, (dist - Victims.CollisionRadius) / DamageRadius);

            if (Victims == LastTouched)
            {
                LastTouched = none;
            }

            Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

            if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
            {
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
            }
        }
    }

    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Victims = LastTouched;
        LastTouched = none;

        // If hit collision mesh actor then switch to actual VehicleWeapon
        if (DH_VehicleWeaponCollisionMeshActor(Victims) != none)
        {
            Victims = Victims.Owner;
            log(Tag @ "HurtRadius part II: hit a DH_VehicleWeaponCollisionMeshActor, so switched hit actor to" @ Victims.Tag); // TEMP
        }

        dir = Victims.Location - HitLocation;
        dist = FMax(1.0, VSize(dir));
        dir = dir / dist;
        damageScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1.0 - FMax(0.0, (dist - Victims.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            Victims.SetDelayedDamageInstigatorController(Instigator.Controller);
        }

        Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

        if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
        {
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
        }
    }

    bHurtEntry = false;
}

defaultproperties
{
    Damage=525
    DamageRadius=512.0
    MyDamageType=class'DH_LevelActors.DHATMineDamage'
    Momentum=3000.0
    bHidden=true
}
