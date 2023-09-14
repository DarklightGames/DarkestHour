//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRocketFire extends DHProjectileFire
    abstract;

var     bool                bCausesExhaustDamage;    // rocket exhaust causes backblast damage
var     float               ExhaustLength;           // length of the exhaust back blast (in Unreal units)
var     float               ExhaustDamage;           // damage caused by exhaust
var     float               ExhaustMomentumTransfer; // momentum from exhaust to inflict on players
var     class<DamageType>   ExhaustDamageType;       // damage type for exhaust

// Modified to prevent firing if RocketWeapon's CanFire() says no
simulated function bool AllowFire()
{
    // Skip CanFire() check on the server to avoid situations where a client
    // can get a green light to fire before the server does
    if (Weapon != none && Weapon.Role == ROLE_Authority)
    {
        return super.AllowFire();
    }

    return DHRocketWeapon(Weapon) != none &&
           DHRocketWeapon(Weapon).CanFire() &&
           super.AllowFire();
}

// Modified to add exhaust damage & to call PostFire() on the Weapon
event ModeDoFire()
{
    local vector WeaponLocation, ExhaustDirection, HitLocation, HitNormal, ExhaustReflectDirection;
    local Actor  HitActor;

    super.ModeDoFire();

    if (Weapon == none)
    {
        return;
    }

    if (bCausesExhaustDamage && Weapon.ThirdPersonActor != none)
    {
        WeaponLocation = Weapon.ThirdPersonActor.Location;
        ExhaustDirection = -vector(Weapon.ThirdPersonActor.Rotation);

        // Check if the exhaust backblast hit an object behind the firer
        HitActor = Trace(HitLocation, HitNormal, WeaponLocation + (ExhaustDirection * 0.75 * default.ExhaustLength), WeaponLocation, false);

        // The backblast did hit something, not counting players or breakable objects
        if (HitActor != none && !HitActor.IsA('DHPawn') && !HitActor.IsA('RODestroyableStaticMesh'))
        {
            ExhaustLength = VSize(HitLocation - WeaponLocation); // reduce exhaust length, as it hit something

            // If fired pretty close to the hit object (approx 3.3m by default), simulate a nasty backblast reflecting off the surface (& spreading out along it, if an angled hit)
            // This causes full exhaust damage & by default the damage centre is approx 0.8m out from the hit surface, with a radius of 2.5m
            if (ExhaustLength < 0.5 * default.ExhaustLength)
            {
                ExhaustReflectDirection = 2.0 * (HitNormal * -ExhaustDirection) * HitNormal + ExhaustDirection;
                Weapon.HurtRadius(ExhaustDamage, 0.375 * default.ExhaustLength, ExhaustDamageType, ExhaustMomentumTransfer, HitLocation + (ExhaustReflectDirection * 0.125 * default.ExhaustLength));
            }
        }
        // Otherwise exhaust didn't hit anything, so exhaust is full length
        else
        {
            ExhaustLength = default.ExhaustLength;
        }

        // Full exhaust damage to anything in a small area just behind the weapon
        if (ExhaustLength > 0.25 * default.ExhaustLength)
        {
            Weapon.HurtRadius(ExhaustDamage, 0.125 * default.ExhaustLength, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation + (ExhaustDirection * 0.25 * default.ExhaustLength));
        }

        // Half exhaust damage to anything in a medium sized area further back from the weapon
        if (ExhaustLength > 0.5 * default.ExhaustLength)
        {
            Weapon.HurtRadius(ExhaustDamage / 2.0, 0.25 * default.ExhaustLength, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation + (ExhaustDirection * 0.5 * default.ExhaustLength));
        }

        // Third exhaust damage to anything in a quite large area towards the end of the exhaust stream
        if (ExhaustLength > 0.75 * default.ExhaustLength)
        {
            Weapon.HurtRadius(ExhaustDamage / 3.0, 0.375 * default.ExhaustLength, ExhaustDamageType, ExhaustMomentumTransfer, WeaponLocation + (ExhaustDirection * 0.75 * default.ExhaustLength));
        }
    }

    Weapon.PostFire();
}

// Modified so when ironsighted we use the appropriate animation from RocketWeapon's range settings
function PlayFiring()
{
    local DHRocketWeapon RocketWeapon;
    local name           Anim;

    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            if (!IsPlayerHipFiring())
            {
                RocketWeapon = DHRocketWeapon(Weapon);

                if (RocketWeapon != none && RocketWeapon.RangeSettings.Length > 0)
                {
                    if (Instigator != none && Instigator.bBipodDeployed)
                    {
                        Anim = RocketWeapon.RangeSettings[RocketWeapon.RangeIndex].BipodFireAnim;
                    }
                    else
                    {
                        Anim = RocketWeapon.RangeSettings[RocketWeapon.RangeIndex].IronFireAnim;
                    }
                }
                else
                {
                    Anim = FireIronAnim;
                }
            }
            else
            {
                Anim = FireAnim;
            }

            if (Weapon.HasAnim(Anim))
            {
                Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
            }
        }

        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
    }

    ClientPlayForceFeedback(FireForce);
}

defaultproperties
{
    bUsePreLaunchTrace=false
    FAProjSpawnOffset=(X=-25.0)
    bWaitForRelease=true
    FireRate=2.6

    Spread=450.0
    MaxVerticalRecoilAngle=800
    MaxHorizontalRecoilAngle=400
    AimError=2000.0

    bCausesExhaustDamage=true
    ExhaustLength=400.0
    ExhaustDamage=200.0
    ExhaustMomentumTransfer=100.0

    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
    FireForce="RocketLauncherFire"
    FireAnim=""

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=500.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
    ShakeRotTime=6.0
}
