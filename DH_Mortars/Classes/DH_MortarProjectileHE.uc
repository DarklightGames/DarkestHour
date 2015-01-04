//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarProjectileHE extends DH_MortarProjectile
    abstract;

// Sounds
var array<sound> GroundExplosionSounds;
var array<sound> WaterExplosionSounds;
var array<sound> AirExplosionSounds;
var array<sound> SnowExplosionSounds;

// Emitter classes
var class<Emitter> AirExplosionEmitterClass;
var class<Emitter> GroundExplosionEmitterClass;
var class<Emitter> SnowExplosionEmitterClass;
var class<Emitter> WaterExplosionEmitterClass;

// Camera shaking
var vector              ShakeRotMag;      // how far to rot view
var vector              ShakeRotRate;     // how fast to rot view
var float               ShakeRotTime;     // how much time to rot the instigator's view
var vector              ShakeOffsetMag;   // max view offset vertically
var vector              ShakeOffsetRate;  // how fast to offset view vertically
var float               ShakeOffsetTime;  // how much time to offset view
var float               BlurTime;         // How long blur effect should last for this shell
var float               BlurEffectScalar;

simulated function GetExplosionEmitterClass(out class<Emitter> ExplosionEmitterClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionEmitterClass = SnowExplosionEmitterClass;
            return;

        case EST_Snow:
            ExplosionEmitterClass = SnowExplosionEmitterClass;
            return;

        case EST_Water:
            ExplosionEmitterClass = WaterExplosionEmitterClass;
            return;

        default:
            ExplosionEmitterClass = GroundExplosionEmitterClass;
            return;
    }
}

simulated function GetExplosionSound(out sound ExplosionSound, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionSound = SnowExplosionSounds[Rand(SnowExplosionSounds.Length)];
            return;

        case EST_Snow:
            ExplosionSound = SnowExplosionSounds[Rand(SnowExplosionSounds.Length)];
            return;

        case EST_Water:
            ExplosionSound = WaterExplosionSounds[Rand(WaterExplosionSounds.Length)];
            return;

        default:
            ExplosionSound = GroundExplosionSounds[Rand(GroundExplosionSounds.Length)];
            return;
    }
}

simulated function GetExplosionDecalClass(out class<Projector> ExplosionDecalClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionDecalClass = ExplosionDecalSnow;
            return;

        case EST_Snow:
            ExplosionDecalClass = ExplosionDecalSnow;
            return;

        default:
            ExplosionDecalClass = ExplosionDecal;
            return;
    }
}

simulated function BlowUp(vector HitLocation)
{
    local ESurfaceTypes    HitSurfaceType;
    local class<Emitter>   ExplosionEmitterClass;
    local class<Projector> ExplosionDecalClass;
    local sound            ExplosionSound;

    MakeNoise(1.0);
    GetHitSurfaceType(HitSurfaceType);
    GetExplosionEmitterClass(ExplosionEmitterClass, HitSurfaceType);
    GetExplosionDecalClass(ExplosionDecalClass, HitSurfaceType);
    GetExplosionSound(ExplosionSound, HitSurfaceType);
    Spawn(ExplosionEmitterClass, self,, HitLocation);
    Spawn(ExplosionDecalClass, self,, HitLocation, rotator(vect(0.0, 0.0, -1.0)));
    PlaySound(ExplosionSound,, 6.0 * TransientSoundVolume, false, 5248.0, 1.0, true);
    DoShakeEffect();
}

// Explode in water
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume.bWaterVolume)
    {
        Explode(Location, vect(0.0, 0.0, 1.0));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local ROVolumeTest VT;

    VT = Spawn(class'ROVolumeTest',,, HitLocation);

    if (VT.IsInNoArtyVolume())
    {
        bDud = true;
    }

    VT.Destroy();

    if (bDud)
    {
        DoHitEffects(HitLocation, HitNormal);
        Destroy();

        return;
    }

    BlowUp(HitLocation);

    super.Explode(HitLocation, HitNormal);

    Destroy();
}

simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, Scale;

    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();

        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);

            if (Dist < DamageRadius * 2.0)
            {
                Scale = (DamageRadius * 2.0  - Dist) / (DamageRadius * 2.0);
                Scale *= BlurEffectScalar;

                PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victims;
    local float         damageScale, dist;
    local vector        dir;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local int           i;
    local bool          bAlreadyChecked;
    local Controller    C;
    local float         DamageExposure;
    local bool          bAlreadyDead;
    local vector        TraceHitLocation, TraceHitNormal;
    local Actor         TraceHitActor;

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
        }

        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if (Victims != self && HurtWall != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            // do a trace to the actor
            TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, Location);

            // if there's a vehicle between the player and explosion, don't apply damage
            if (Vehicle(TraceHitActor) != none && TraceHitActor != Victims)
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
                for (i = 0; i < CheckedROPawns.Length; i++)
                {
                    if (CheckedROPawns[i] == P)
                    {
                        bAlreadyChecked = true;
                        break;
                    }
                }

                if (bAlreadyChecked)
                {
                    bAlreadyChecked = false;
                    P = none;
                    continue;
                }

                // Check if this pawn is already dead
                if (P.Health > 0)
                {
                    bAlreadyDead = false;
                }
                else
                {
                    bAlreadyDead = true;
                }

                DamageExposure = P.GetExposureTo(Location + 15.0 * -Normal(PhysicsVolume.Gravity));

                damageScale *= DamageExposure;

                CheckedROPawns[CheckedROPawns.Length] = P;

                if (damageScale <= 0.0)
                {
                    P = none;
                    continue;
                }
                else
                {
                    Victims = P;
                    P = none;
                }
            }

            if (Instigator == none || Instigator.Controller == none)
            {
                Victims.SetDelayedDamageInstigatorController(DamageInstigator);
            }

            if (Victims == LastTouched)
            {
                LastTouched = none;
            }

            Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

            if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
            {
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, DamageInstigator, DamageType, Momentum, HitLocation);
            }

            //Give additional points to the observer and the mortarman for working together for a kill!
            if (!bAlreadyDead && Pawn(Victims) != none && Pawn(Victims).Health <= 0 && DamageInstigator.GetTeamNum() != Pawn(Victims).GetTeamNum())
            {
                GetClosestMortarTargetController(C);

                if (C != none)
                {
                    DarkestHourGame(Level.Game).ScoreMortarSpotAssist(C, DamageInstigator);
                }
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
        }

        dir = Victims.Location - HitLocation;
        dist = FMax(1.0, VSize(dir));
        dir = dir / dist;
        damageScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1.0 - FMax(0.0, (dist - Victims.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            Victims.SetDelayedDamageInstigatorController(DamageInstigator);
        }

        Victims.TakeDamage(damageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, damageScale * Momentum * dir, DamageType);

        if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
        {
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, DamageInstigator, DamageType, Momentum, HitLocation);
        }
    }

    bHurtEntry = false;
}

simulated function GetClosestMortarTargetController(out Controller C)
{
    local DHGameReplicationInfo GRI;
    local float  Distance, ClosestDistance;
    local int i, ClosestIndex;

    ClosestIndex = 255;
    ClosestDistance = 5250.0; // 100 meters

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    if (DamageInstigator.GetTeamNum() == 0)
    {
        for (i = 0; i < ArrayCount(GRI.GermanMortarTargets); i++)
        {
            if (GRI.GermanMortarTargets[i].Controller == none || GRI.GermanMortarTargets[i].bCancelled != 0)
            {
                continue;
            }

            Distance = VSize(Location - GRI.GermanMortarTargets[i].Location);

            if (Distance <= ClosestDistance)
            {
                ClosestDistance = Distance;
                ClosestIndex = i;
            }
        }

        if (ClosestIndex == 255)
        {
            return;
        }

        C = GRI.GermanMortarTargets[ClosestIndex].Controller;
    }
    else
    {
        for (i = 0; i < ArrayCount(GRI.AlliedMortarTargets); i++)
        {
            if (GRI.AlliedMortarTargets[i].Controller == none || GRI.AlliedMortarTargets[i].bCancelled != 0)
            {
                continue;
            }

            Distance = VSize(Location - GRI.AlliedMortarTargets[i].Location);

            if (Distance <= ClosestDistance)
            {
                ClosestDistance = Distance;
                ClosestIndex = i;
            }
        }

        if (ClosestIndex == 255)
        {
            return;
        }

        C = GRI.AlliedMortarTargets[ClosestIndex].Controller;
    }
}

simulated function Destroyed()
{
    if (!bDud && Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
    }

    super.Destroyed();
}

defaultproperties
{
    AirExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    GroundExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    SnowExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    WaterExplosionEmitterClass=class'ROEffects.ROArtilleryWaterEmitter'
}
