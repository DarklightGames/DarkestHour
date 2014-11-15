//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_RocketFire extends DH_ProjectileFire;

var array<name>         FireIronAnims;

var float               ExhaustDamage;
var float               ExhaustDamageRadius;
var float               ExhaustMomentumTransfer;
var class<DamageType>   ExhaustDamageType;

var DH_RocketWeapon     RocketWeapon;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    RocketWeapon = DH_RocketWeapon(Weapon);
}

event ModeDoFire()
{
    local vector WeaponLocation;
    local rotator WeaponRotation;
    local vector HitLocation, HitNormal, ExhaustDirection, ExhaustReflectDirection;
    local float ExhaustLength;
    local Actor HitActor;
    local RODestroyableStaticMesh DSM;

    if (Instigator.bIsCrawling || !Weapon.bUsingSights)
    {
        return;
    }

    super.ModeDoFire();

    WeaponLocation = Weapon.ThirdPersonActor.Location;
    WeaponRotation = Weapon.ThirdPersonActor.Rotation;
    ExhaustDirection = vector(WeaponRotation);
    ExhaustLength = 400;

    HitActor = Trace(HitLocation, HitNormal, WeaponLocation - ExhaustDirection * 300, WeaponLocation, false);
    DSM = RODestroyableStaticMesh(HitActor);

    // Check if the firer is too close to an object and if so, simulate exhaust spreading out along, and reflecting from, the wall
    // Do not reflect off players or breakable objects like windows
    if (HitActor != none && DH_Pawn(HitActor) == none && DSM == none)
    {
        ExhaustLength = VSize(HitLocation - WeaponLocation); // Exhaust stream length when it hit an object
        ExhaustReflectDirection = 2 * (HitNormal * ExhaustDirection) * HitNormal - ExhaustDirection; // vector back towards firer from hit object

        if (ExhaustLength < 200)
        {
            Weapon.HurtRadius(ExhaustDamage,
                              ExhaustDamageRadius * 3,
                              ExhaustDamageType,
                              ExhaustMomentumTransfer,
                              HitLocation + ExhaustReflectDirection * ExhaustLength / 2);
        }
    }

    if (ExhaustLength > 100)
    {
       Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 100);
    }

    if (ExhaustLength > 200)
    {
       Weapon.HurtRadius(ExhaustDamage / 2, ExhaustDamageRadius * 2, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 200);
    }

    if (ExhaustLength >= 400)
    {
       Weapon.HurtRadius(ExhaustDamage / 3, ExhaustDamageRadius * 3, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 300);
    }

    Weapon.PostFire();
}

function PlayFiring()
{
    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

    if (RocketWeapon != none)
    {
        Weapon.PlayAnim(FireIronAnims[RocketWeapon.RangeIndex], FireAnimRate, FireTweenTime);
    }

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

defaultproperties
{
    FireIronAnims(0)="iron_shoot"
    FireIronAnims(1)="iron_shootMid"
    FireIronAnims(2)="iron_shootFar"
    ExhaustDamage=200.000000
    ExhaustDamageRadius=50.000000
    ExhaustMomentumTransfer=100.000000
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-25.000000)
    AddedPitch=-100
    bUsePreLaunchTrace=false
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    maxVerticalRecoilAngle=800
    maxHorizontalRecoilAngle=400
    bWaitForRelease=true
    TweenTime=0.000000
    FireForce="RocketLauncherFire"
    FireRate=2.600000
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=500.000000)
    ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=7500.000000)
    ShakeRotTime=6.000000
    ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.000000
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=2000.000000
    Spread=450.000000
    SpreadStyle=SS_Random
}

