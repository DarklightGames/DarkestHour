//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FG42Fire extends DHAutomaticFire;

var(FireAnims)  name        SightUpFireIronAnim;
var(FireAnims)  name        SightUpFireIronLoopAnim;
var(FireAnims)  name        SightUpFireIronEndAnim;

function PlayFiring()
{
    local DH_FG42Weapon SightStatus;

    SightStatus = DH_FG42Weapon(Owner);

    if (Weapon.Mesh != none)
    {
        if (FireCount > 0)
        {
            if ((Weapon.bUsingSights || Instigator.bBipodDeployed) && Weapon.HasAnim(FireIronLoopAnim))
            {
                if (Instigator.bBipodDeployed && Weapon.HasAnim(SightUpFireIronLoopAnim))
                {
                    Weapon.PlayAnim(SightUpFireIronLoopAnim, FireAnimRate, 0.0);
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
                else
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }
        else
        {
            if (Weapon.bUsingSights || Instigator.bBipodDeployed)
            {
                if (Instigator.bBipodDeployed && Weapon.HasAnim(SightUpFireIronLoopAnim))
                {
                    Weapon.PlayAnim(SightUpFireIronAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
                }
            }
            else
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

function PlayFireEnd()
{
    local DH_FG42Weapon SightStatus;

    SightStatus = DH_FG42Weapon(Owner);

    if ((Weapon.bUsingSights || Instigator.bBipodDeployed) && Weapon.HasAnim(FireIronEndAnim))
    {
        if (Instigator.bBipodDeployed && Weapon.HasAnim(SightUpFireIronEndAnim))
        {
            Weapon.PlayAnim(SightUpFireIronEndAnim, FireEndAnimRate, FireTweenTime);
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
    SightUpFireIronAnim="deploy_shoot_end"
    SightUpFireIronLoopAnim="deploy_shoot_end"
    SightUpFireIronEndAnim="deploy_shoot_end"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-28.0)
    PreLaunchTraceDistance=2624.0 // 43.5m (revert to usual distance, as auto weapons use half the usual)
    TracerFrequency=5
    TracerProjectileClass=class'DH_FG42TracerBullet'
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire02'
    FireVolume=512.0
    maxVerticalRecoilAngle=900
    maxHorizontalRecoilAngle=180
    PctStandIronRecoil=0.42
    PctCrouchRecoil=0.75
    PctCrouchIronRecoil=0.32
    PctProneIronRecoil=0.22
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.1
    RecoilRate=0.075
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.08
    AmmoClass=class'DH_Weapons.DH_FG42Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.75
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_FG42Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSTG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=1200.0
    Spread=160.0
    SpreadStyle=SS_Random
}
