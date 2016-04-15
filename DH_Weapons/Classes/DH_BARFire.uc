//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BARFire extends DHAutomaticFire;

var(FireAnims)  name        SightUpFireIronAnim;
var(FireAnims)  name        SightUpFireIronLoopAnim;
var(FireAnims)  name        SightUpFireIronEndAnim;

function ModeTick(float dt)
{
    super.ModeTick(dt);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

function PlayFiring()
{
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
    SightUpFireIronAnim="SightUp_iron_shoot_loop"
    SightUpFireIronLoopAnim="SightUp_iron_shoot_loop"
    SightUpFireIronEndAnim="SightUp_iron_shoot_end"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-28.0)
    PreLaunchTraceDistance=2624.0 // 43.5m (revert to usual distance, as auto weapons use half the usual)
    TracerFrequency=5
    TracerProjectileClass=class'DH_BARTracerBullet'
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire02'
    FireVolume=512.0
    maxVerticalRecoilAngle=1600
    maxHorizontalRecoilAngle=450
    PctStandIronRecoil=0.8
    PctCrouchRecoil=0.65
    PctCrouchIronRecoil=0.45
    PctProneIronRecoil=0.25
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.1
    RecoilRate=0.075
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true
    PreFireAnim="Shoot1_start"
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.2
    AmmoClass=class'DH_Weapons.DH_BARAmmo'
    ShakeRotMag=(X=64.0,Y=64.0,Z=180.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.75
    ShakeOffsetMag=(X=4.0,Y=1.0,Z=4.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_BARBullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSTG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=1200.0
    Spread=150.0
    HipSpreadModifier=8.0
    SpreadStyle=SS_Random
}
