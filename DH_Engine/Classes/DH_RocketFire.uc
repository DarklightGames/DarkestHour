//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_RocketFire extends DH_ProjectileFire
    abstract;

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
    local rotator WeaponRotation;
    local vector  WeaponLocation, HitLocation, HitNormal, ExhaustDirection, ExhaustReflectDirection;
    local float   ExhaustLength;
    local Actor   HitActor;
    local RODestroyableStaticMesh DSM;

    if (Instigator.bIsCrawling || !Weapon.bUsingSights)
    {
        return;
    }

    super.ModeDoFire();

    WeaponLocation = Weapon.ThirdPersonActor.Location;
    WeaponRotation = Weapon.ThirdPersonActor.Rotation;
    ExhaustDirection = vector(WeaponRotation);
    ExhaustLength = 400.0;

    HitActor = Trace(HitLocation, HitNormal, WeaponLocation - ExhaustDirection * 300.0, WeaponLocation, false);
    DSM = RODestroyableStaticMesh(HitActor);

    // Check if the firer is too close to an object and if so, simulate exhaust spreading out along, and reflecting from, the wall
    // Do not reflect off players or breakable objects like windows
    if (HitActor != none && DHPawn(HitActor) == none && DSM == none)
    {
        ExhaustLength = VSize(HitLocation - WeaponLocation); // exhaust stream length when it hit an object
        ExhaustReflectDirection = 2.0 * (HitNormal * ExhaustDirection) * HitNormal - ExhaustDirection; // vector back towards firer from hit object

        if (ExhaustLength < 200.0)
        {
            Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius * 3.0, ExhaustDamageType, ExhaustMomentumTransfer, HitLocation + ExhaustReflectDirection * ExhaustLength / 2.0);
        }
    }

    if (ExhaustLength > 100.0)
    {
       Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 100.0);
    }

    if (ExhaustLength > 200.0)
    {
       Weapon.HurtRadius(ExhaustDamage / 2.0, ExhaustDamageRadius * 2.0, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 200.0);
    }

    if (ExhaustLength >= 400.0)
    {
       Weapon.HurtRadius(ExhaustDamage / 3.0, ExhaustDamageRadius * 3.0, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation - ExhaustDirection * 300.0);
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
    ExhaustDamage=200.0
    ExhaustDamageRadius=50.0
    ExhaustMomentumTransfer=100.0
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-25.0)
    AddedPitch=-100
    bUsePreLaunchTrace=false
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    maxVerticalRecoilAngle=800
    maxHorizontalRecoilAngle=400
    bWaitForRelease=true
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.6
    ShakeRotMag=(X=50.0,Y=50.0,Z=500.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
    ShakeRotTime=6.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    BotRefireRate=0.5
    WarnTargetPct=0.9
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=2000.0
    Spread=450.0
    SpreadStyle=SS_Random
}

