//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeProjectile extends DHGrenadeProjectile;

#exec OBJ LOAD File=Inf_WeaponsTwo.uax

//var   float               PenetrationAbility;  // TODO: not used (should be)
var     class<DamageType>   GrenadeImpactDamage;

// Modified to skip explosion effects in the Super if the grenade is simply destroying itself after its LifeSpan expires
simulated function Destroyed()
{
    if (bAlreadyExploded) // only set if grenade detonates on impact
    {
        super.Destroyed();
    }
}

// Disabled as this grenade does not use a timed fuze
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Modified to remove 'Fear' stuff, as grenade does not explode after landing (if fails to detonate on impact)
simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, class'UUnits'.static.UnrealToRadians(Rotation.Yaw)))));
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Modified to handle possible explosion on impact, depending on impact speed
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local ESurfaceTypes ST;
    local vector        VNorm;
    local int           ImpactSpeed, i;
    local bool          bExplodeOnImpact;

    // Return here, this was causing the famous "nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

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

    ImpactSpeed = int(VSize(Velocity));

    // Grenade hit a vehicle & will explode if impact speed is high enough
    if (ROVehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
    {
        if (ImpactSpeed >= (820 + Rand(81)))
        {
/*
            // We hit an armored vehicle but failed to penetrate // WIP - problem is we can't pass self, as requires a DHAntiVehicleProjectile
            if ((Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), PenetrationAbility))
                || (Wall.IsA('DHVehicleCannon') && !DHVehicleCannon(Wall).ShouldPenetrate(self, Location, Normal(Velocity), PenetrationAbility)))
            {
                // no damage, maybe a failed to penetrate effect
            }
            else [damage vehicle]
*/
            // Damage the vehicle if we hit pretty square on (impact angle < 6.85 degrees, expressed in radians)
            // TODO - crazy, no penetration checks, work something out based on HEAT!!
            if (Role == ROLE_Authority && Acos(HitNormal dot vect(0.0, 0.0, 1.0)) < 0.119555)
            {
                Wall.TakeDamage(Damage * 1.5, none, Location, Location, GrenadeImpactDamage);
            }

            bExplodeOnImpact = true;
        }
    }
    // We didn't hit a vehicle & ground can be softer, so let's require more impact speed to explode
    else if (ImpactSpeed >= (950 + Rand(101)))
    {
        bExplodeOnImpact = true;
    }

    if (bExplodeOnImpact)
    {
        Explode(Location,vect(0.0, 0.0, 0.0));

        return;
    }

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST); // gets the deflect dampen factor & the hit sound, based on the type of surface the projectile hit

    Bounces--;

    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall with damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + ((Velocity - VNorm) * DampenFactorParallel);
        Speed = VSize(Velocity);
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150.0 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1);
    }
}

// Modified to flag bAlreadyExploded so Destroyed() function knows grenade hasn't just disappeared after LifeSpan after failing to detonate on impact
simulated function Explode(vector HitLocation, vector HitNormal)
{
    bAlreadyExploded = true;

    super.Explode(HitLocation, HitNormal);
}

defaultproperties
{
//  PenetrationAbility=7.6
    GrenadeImpactDamage=class'DH_Engine.DHShellImpactDamageType' // TODO - switch this to a suitable HEAT type
    MyDamageType=class'DH_Weapons.DH_RPG43GrenadeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.RPG43_Tossed'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    Damage=200.0
    DamageRadius=250.0
    FuzeLengthTimer=0.0
    Speed=900.0
    LifeSpan=15.0 // used in case the grenade didn't hit hard enough to explode (will stay around for a bit for effect, then disappear)
}
