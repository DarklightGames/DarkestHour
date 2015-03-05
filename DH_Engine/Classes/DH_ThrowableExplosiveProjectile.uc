//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ThrowableExplosiveProjectile extends ROThrowableExplosiveProjectile
    abstract;

var float          ExplosionSoundRadius;
var class<Emitter> ExplodeDirtEffectClass;
var class<Emitter> ExplodeSnowEffectClass;
var class<Emitter> ExplodeMidAirEffectClass;


// Modified to optimise
simulated function Tick(float DeltaTime)
{
    if (!bAlreadyExploded)
    {
        FuzeLengthTimer -= DeltaTime;

        if (FuzeLengthTimer <= 0.0)
        {
            bAlreadyExploded = true;
            Explode(Location, vect(0.0, 0.0, 1.0));
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
    local vector        TraceHitLocation, TraceHitNormal;
    local Actor         TraceHitActor;

    if (bHurtEntry)
    {
        return;
    }

    // Just return if the player switches teams after throwing the explosive - this prevent people TK exploiting by switching teams
    if (Role == ROLE_Authority)
    {
        if (Instigator == none || Instigator.Controller == none)
        {
            if (InstigatorController.PlayerReplicationInfo.Team.TeamIndex != ThrowerTeam)
            {
                Destroy();
                return;
            }
        }
        else
        {
            if (Instigator.Controller.PlayerReplicationInfo.Team.TeamIndex != ThrowerTeam)
            {
                Destroy();
                return;
            }
        }
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
        if (Victims != self && Hurtwall != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
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
                for (i = 0; i < CheckedROPawns.Length; ++i)
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

                damageScale *= P.GetExposureTo(Location + 15.0 * -Normal(PhysicsVolume.Gravity));

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

// Modified to add SetRotation
simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));

        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker');
            Fear.SetCollisionSize(DamageRadius, 200.0);
            Fear.StartleBots();
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Matt: added handling if projectile hits a weak destroyable mesh (e.g. glass), so that it breaks the mesh & continues its flight, instead of bouncing off
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local vector        VNorm;
    local ESurfaceTypes ST;
    local int           i;

    DestroMesh = RODestroyableStaticMesh(Wall);

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            DestroMesh.TakeDamage(DestroMesh.Health + 1, Instigator, Location, MomentumTransfer * Normal(Velocity), class'DHWeaponBashDamageType');

            // But it will only take damage if it's vulnerable to a weapon bash - so check if it's been reduced to zero Health & if so then we'll exit without deflecting
            if (DestroMesh.Health < 0)
            {
                return;
            }
        }
        // Problem is that a client needs to know right now whether or not the mesh will break, so it can decide whether or not to bounce off
        // So as a workaround we'll loop through the meshes TypesCanDamage array & check if the server's weapon bash DamageType will have broken the mesh
        else
        {
            for (i = 0; i < DestroMesh.TypesCanDamage.Length; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                if (DestroMesh.TypesCanDamage[i] == class'DHWeaponBashDamageType' || ClassIsChildOf(class'DHWeaponBashDamageType', DestroMesh.TypesCanDamage[i]))
                {
                    return;
                }
            }
        }
    }

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    Bounces--;

    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall with damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Speed = VSize(Velocity);
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1);
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

//  super.Touch(Other); // doesn't work as this function & Super are singular functions, so have to re-state Super from Projectile here

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        LastTouched = Other;

        if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover'))
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

// Matt: modified to call HitWall for all hit actors, so grenades etc bounce off things like turrets or other players
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector TempHitLocation, HitNormal;

    if (Other == Instigator || Other.Base == Instigator)
    {
        return;
    }

    if (ROBulletWhipAttachment(Other) == none)
    {
        Trace(TempHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true); // get a reliable HitNormal for a deflection
        HitWall(HitNormal, Other);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
    Destroy();
}

simulated function Destroyed()
{
    local int           i;
    local vector        Start;
    local ESurfaceTypes ST;

    WeaponLight();

    PlaySound(ExplosionSound[Rand(3)], , 5.0, , ExplosionSoundRadius, 1.0, true);

    Start = Location + 32.0 * vect(0.0, 0.0, 1.0);

    if (ShrapnelCount > 0 && Role == ROLE_Authority)
    {
        for (i = 0; i < ShrapnelCount; ++i)
        {
            Spawn(class'ROShrapnelChunk', , '', Start);
        }
    }

    DoShakeEffect();

    if (EffectIsRelevant(Location, false))
    {
        // If the projectile is still moving we'll need to spawn a different explosion effect
        if (Physics == PHYS_Falling)
        {
            Spawn(ExplodeMidAirEffectClass, , , Start, rotator(vect(0.0, 0.0, 1.0)));
        }
        // If the projectile has stopped and is on the ground we'll spawn a ground explosion effect and spawn some dirt flying out
        else if (Physics == PHYS_None)
        {
            GetHitSurfaceType(ST, vect(0.0, 0.0, 1.0));

            if (ST == EST_Snow || ST == EST_Ice)
            {
                Spawn(ExplodeSnowEffectClass, , , Start, rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecalSnow, self, , Location, rotator(-vect(0.0, 0.0, 1.0)));
            }
            else
            {
                Spawn(ExplodeDirtEffectClass, , , Start, rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecal, self, , Location, rotator(-vect(0.0, 0.0, 1.0)));
            }
        }
    }

    super.Destroyed();
}

// Gets the surface type of the surface the projectile has collided with
simulated function GetHitSurfaceType(out ESurfaceTypes ST, vector HitNormal)
{
    local vector   HitLoc, HitNorm;
    local Material HitMat;

    Trace(HitLoc, HitNorm, Location - (HitNormal * 16.0), Location, false, , HitMat);

    if (HitMat == none)
    {
        ST = EST_Default;
    }
    else
    {
        ST = ESurfaceTypes(HitMat.SurfaceType);
    }
}

// Gets the DampenFactors and hit sound for the surface the projectile hits
simulated function GetDampenAndSoundValue(ESurfaceTypes ST)
{
    switch (ST)
    {
        case EST_Default:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.5;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Rock:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Dirt:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Metal:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Wood:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.4;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Plant:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.1;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Flesh:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.3;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Ice:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Snow:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Water:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = sound'Inf_Weapons.ShellRifleWater';
            break;

        case EST_Glass:
            DampenFactor = 0.3;
            DampenFactorParallel = 0.55;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;
    }
}

simulated function WeaponLight(); // empty function; can be subclassed

simulated function PhysicsVolumeChange(PhysicsVolume Volume)
{
    if (Volume.bWaterVolume)
    {
        Velocity *= 0.25;
    }
}

defaultproperties
{
    bBounce=true
    Bounces=5
    MaxSpeed=1500.0
    MomentumTransfer=8000.0
    TossZ=150.0
    DampenFactor=0.05
    DampenFactorParallel=0.8
    Physics=PHYS_Falling
    bFixedRotationDir=true
    FailureRate=0.01 // failure rate is default to 1 in 100
    ShrapnelCount=0
    ImpactSound=sound'Inf_Weapons_Foley.grenadeland'
    ExplosionSoundRadius=300.0
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'
    DrawType=DT_StaticMesh
    bDynamicLight=false
    LightType=LT_Pulse
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=200
    LightHue=30
    LightSaturation=150
    LightRadius=5.0
}
