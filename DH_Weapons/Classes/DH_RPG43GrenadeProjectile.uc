//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeProjectile extends DH_StielGranateProjectile;

#exec OBJ LOAD File=Inf_WeaponsTwo.uax

var     float               DestroyTimer;
var     float               SurfaceAngleRadian;
var     float               RPG43PenetrationAbility;
var     bool                bCalledDestroy;
var     bool                bIsHEATRound;
var     class<DamageType>   GrenadeImpactDamage;

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ESurfaceTypes ST;
    local vector        VNorm;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    // Return here, this was causing the famous "Nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    Bounces--;

    if (int(VSize(Velocity)) >= (820 + Rand(81)))
    {
        // Let's check if we hit a vehicle (but not passenger pawn)
        if (Wall.IsA('SVehicle') && !Wall.IsA('ROPassengerPawn'))
        {
            // Let's damage the vehicle if we hit a top & flat surface
            if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) < SurfaceAngleRadian)
            {
                Wall.TakeDamage(Damage * 1.5, none, Location, Location, MyDamageType); // hurt the vehicle itself
                Explode(Location,vect(0.0, 0.0, 0.0));
            }
            else // else lets check if the armor is too thick to damage
            {
                Explode(Location,vect(0.0, 0.0, 0.0));
            }
        }
        // We didn't hit a vehicle & ground can be softer, so let's require more impact speed to explode
        else if (int(VSize(Velocity)) >= (950 + Rand(101)))
        {
            Explode(Location,vect(0.0, 0.0, 0.0));
        }

        return; // because we exploded, let's end the function here
    }

    // We didn't hit the wall hard enough so lets try bouncing
    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall w/damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + ((Velocity - VNorm) * DampenFactorParallel);
        Speed = VSize(Velocity);
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150.0 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // increase volume of impact
    }
}

// Overrided because there is no fuse on this grenade
simulated function Tick(float DeltaTime)
{
    // Count down on the destroy timer
    DestroyTimer -= DeltaTime;

    if (DestroyTimer <= 0.0 && !bCalledDestroy)
    {
        bCalledDestroy = true;
        bAlreadyExploded = true; // make sure it doesn't explode on destroy
        Reset(); // delete the actor
    }
}

// Overrideen to support bAlreadyExploded variable
simulated function Destroyed()
{
    local ESurfaceTypes ST;
    local vector        Start;

    if (bAlreadyExploded)
    {
        return;
    }

    PlaySound(ExplosionSound[Rand(3)],, 5.0);
    Start = Location + (32.0 * vect(0.0, 0.0, 1.0));

    DoShakeEffect();

    if (EffectIsRelevant(Location,false))
    {
        // if the grenade is still moving we'll need to spawn a different explosion effect
        if (Physics == PHYS_Falling)
        {
            Spawn(class'GrenadeExplosion_midair',,, Start, rotator(vect(0.0, 0.0, 1.0)));
        }

        // If the grenade has stopped & is on the ground we'll spawn a ground explosion effect & spawn some dirt flying out
        else if (Physics == PHYS_None)
        {
            GetHitSurfaceType(ST, vect(0.0, 0.0, 1.0));

            if (ST == EST_Snow || ST == EST_Ice)
            {
                Spawn(ExplodeDirtEffectClass,,, Start, rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecalSnow, self,, Location, rotator(-vect(0.0, 0.0, 1.0)));
            }
            else
            {
                Spawn(ExplodeDirtEffectClass,,, Start, rotator(vect(0.0, 0.0, 1.0)));
                Spawn(ExplosionDecal, self,, Location, rotator(-vect(0.0, 0.0, 1.0)));
            }
        }
    }

    super.Destroyed();
}

defaultproperties
{
    bIsHEATRound=true
    //compile error  GrenadeImpactDamage=class'DH_Vehicles.DH_TankShellImpactDamage'
    RPG43PenetrationAbility=7.6
    SurfaceAngleRadian=0.1195555555555556
    DestroyTimer=15.0 // used in case the grenade didn't hit hard enough to explode (will stay around for a bit for effect)
//  SmokeSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    ExplodeDirtEffectClass=class'ROEffects.GrenadeExplosion'
    ExplosionSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    ExplosionSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    ExplosionSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    Damage=200.0
    DamageRadius=250.0
    MyDamageType=class'DH_Weapons.DH_RPG43GrenadeDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.RPG43_Tossed'
    bAlwaysRelevant=true
    LifeSpan=30.0
    SoundVolume=255
    SoundRadius=200.0
    FuzeLengthTimer=0.0
    Speed=900.0
    bUseCollisionStaticMesh=true
}
