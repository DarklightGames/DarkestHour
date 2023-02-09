//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1GarandFire extends DHSemiAutoFire;

var     array<sound>    FirePingSounds;   // an array of the last round firing sound with ping

// Modified to play firing sound including a clip eject ping when firing last round
function ServerPlayFiring()
{
    if (DH_M1GarandWeapon(Weapon) != none && DH_M1GarandWeapon(Weapon).WasLastRound())
    {
        Weapon.PlayOwnedSound(FirePingSounds[Rand(FirePingSounds.Length)], SLOT_None, FireVolume,,,, false);
    }
    else
    {
        super.ServerPlayFiring();
    }
}

// Modified to play firing sound including clip eject ping, & play firing animation including clip ejection, when firing last round
function PlayFiring()
{
    local DH_M1GarandWeapon Garand;
    local name              Anim;
    local sound             FiringSound;
    local bool              bLastRound;

    Garand = DH_M1GarandWeapon(Weapon);

    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            if (Garand != none && Garand.bIsLastRound)
            {
                if (Weapon.bUsingSights)
                {
                    Anim = FireIronLastAnim;
                }
                else
                {
                    Anim = FireLastAnim;
                }
            }
            else
            {
                if (Weapon.bUsingSights)
                {
                    Anim = FireIronAnim;
                }
                else
                {
                    Anim = FireAnim;
                }
            }

            if (Weapon.HasAnim(Anim))
            {
                Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
            }
        }

        if (Garand != none)
        {
            if (Instigator != none && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
            {
                bLastRound = Garand.bIsLastRound;
            }
            else
            {
                bLastRound = Garand.WasLastRound();
            }
        }

        if (bLastRound)
        {
            FiringSound = FirePingSounds[Rand(FirePingSounds.Length)];
        }
        else
        {
            FiringSound = FireSounds[Rand(FireSounds.Length)];
        }

        if (FiringSound != none)
        {
            Weapon.PlayOwnedSound(FiringSound, SLOT_None, FireVolume,,,, false);
        }
    }

    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M1GarandBullet'
    AmmoClass=class'DH_Weapons.DH_M1GarandAmmo'
    FireRate=0.215
    Spread=50.0
    MaxVerticalRecoilAngle=760
    MaxHorizontalRecoilAngle=200
    
    //Recoil
    RecoilRate=0.06
    RecoilCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=3.0,OutVal=1.4),(InVal=12.0,OutVal=1.4),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=12.0
    
    FireSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire03'
    FirePingSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing01'
    FirePingSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing02'
    FirePingSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    ShellHipOffset=(X=0,Y=-3,Z=0)
    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
    MuzzleOffset=(X=10)
}
