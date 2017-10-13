//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_FG42Fire extends DHAutomaticFire; // TODO: could maybe use DHFastAutoFire/DHHighROFWeaponAttachment as fires at 750 rpm (higher than PPs-43 SMG's 700 rpm, which does use fast auto)

var     name    BipodDeployFireAnim;
var     name    BipodDeployFireLoopAnim;
var     name    BipodDeployFireEndAnim;

// Modified to handle bipod deployed firing animations
function PlayFiring()
{
    if (Weapon.Mesh != none)
    {
        if (FireCount > 0)
        {
            if ((Weapon.bUsingSights || Instigator.bBipodDeployed) && Weapon.HasAnim(FireIronLoopAnim))
            {
                if (Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireLoopAnim))
                {
                    Weapon.PlayAnim(BipodDeployFireLoopAnim, FireAnimRate, 0.0);
                }
                else
                {
                    Weapon.PlayAnim(FireIronLoopAnim, FireAnimRate, 0.0);
                }
            }
            else
            {
                if (Weapon.HasAnim(FireLoopAnim))
                {
                    Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
                }
                else if (Weapon.HasAnim(FireAnim))
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }
        else
        {
            if (Weapon.bUsingSights || Instigator.bBipodDeployed)
            {
                if (Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireAnim))
                {
                    Weapon.PlayAnim(BipodDeployFireAnim, FireAnimRate, FireTweenTime);
                }
                else if (Weapon.HasAnim(FireIronAnim))
                {
                    Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
                }
            }
            else if (Weapon.HasAnim(FireAnim))
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    if (FireSounds.Length > 0)
    {
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
    }

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

// Modified to handle bipod deployed fire end animation
function PlayFireEnd()
{
    if ((Weapon.bUsingSights || Instigator.bBipodDeployed) && Weapon.HasAnim(FireIronEndAnim))
    {
        if (Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireEndAnim))
        {
            Weapon.PlayAnim(BipodDeployFireEndAnim, FireEndAnimRate, FireTweenTime);
        }
        else
        {
            Weapon.PlayAnim(FireIronEndAnim, FireEndAnimRate, FireTweenTime);
        }
    }
    else if (Weapon.HasAnim(FireEndAnim))
    {
        Weapon.PlayAnim(FireEndAnim, FireEndAnimRate, FireTweenTime);
    }
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_FG42Bullet'
    AmmoClass=class'DH_Weapons.DH_FG42Ammo'
    FireRate=0.08
    FAProjSpawnOffset=(X=-28.0)

    Spread=160.0
    RecoilRate=0.075
    PctStandIronRecoil=0.5
    PctCrouchRecoil=0.75
    PctCrouchIronRecoil=0.4
    PctProneIronRecoil=0.3
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.1
    MaxVerticalRecoilAngle=900
    MaxHorizontalRecoilAngle=180

    FireSounds(0)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire02'

    BipodDeployFireAnim="deploy_shoot_loop"
    BipodDeployFireLoopAnim="deploy_shoot_loop"
    BipodDeployFireEndAnim="deploy_shoot_end"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true

    ShakeRotTime=0.75
}
