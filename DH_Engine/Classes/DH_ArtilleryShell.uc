//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ArtilleryShell extends ROArtilleryShell;

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (DH_VehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

//  super.Touch(Other); // doesn't work as this function & Super are singular functions, so have to re-state Super from Projectile here

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        LastTouched = Other;

        if (Velocity == vect(0,0,0) || Other.IsA('Mover'))
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

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  Victims;
    local float  damageScale, dist;
    local vector dir;
    local ROPawn P;

    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    foreach VisibleCollidingActors(class'Actor', Victims, DamageRadius, HitLocation)
    {
        // If hit collision mesh actor then switch to actual VehicleWeapon
        if (DH_VehicleWeaponCollisionMeshActor(Victims) != none)
        {
            Victims = Victims.Owner;
            log(Tag @ "HurtRadius: hit a DH_VehicleWeaponCollisionMeshActor, so switched hit actor to" @ Victims.Tag); // TEMP
        }

        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if (Victims != self && HurtWall != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            if (P == Victims)
            {
                continue;
            }

            dir = Victims.Location - HitLocation;
            dist = FMax(1.0, VSize(dir));
            dir = dir / dist;
            damageScale = 1.0 - FMax(0.0, (dist - Victims.CollisionRadius) / DamageRadius);

            P = ROPawn(Victims);

            if (P == none)
            {
                P = ROPawn(Victims.Base);
            }

            if (P != none)
            {
                damageScale *= P.GetExposureTo(Location + 50.0 * -Normal(PhysicsVolume.Gravity));

                if (damageScale <= 0.0)
                {
                    continue;
                }
            }

            if (Instigator == none || Instigator.Controller == none)
            {
                Victims.SetDelayedDamageInstigatorController(InstigatorController);
            }

            if (Victims == LastTouched)
            {
                LastTouched = none;
            }

            Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

            if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
            {
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
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
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        }

        Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

        if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
        {
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
        }
    }

    bHurtEntry = false;
}

defaultproperties
{
}
