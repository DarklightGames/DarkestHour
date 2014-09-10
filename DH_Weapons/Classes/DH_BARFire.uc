//=============================================================================
// DH_BARFire
//=============================================================================
class DH_BARFire extends DH_AutomaticFire;

var(FireAnims)  name        SightUpFireIronAnim;
var(FireAnims)  name        SightUpFireIronLoopAnim;
var(FireAnims)  name        SightUpFireIronEndAnim;

function ModeTick(float dt)
{
    Super.ModeTick(dt);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

//**************************************************************************************************

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
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_none,FireVolume,,,,false);
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
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-28.000000)
     PreLaunchTraceDistance=2624.000000
     TracerFrequency=5
     DummyTracerClass=Class'DH_Weapons.DH_BARClientTracer'
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire02'
     FireVolume=512.000000
     maxVerticalRecoilAngle=1150
     maxHorizontalRecoilAngle=125
     PctStandIronRecoil=0.800000
     PctCrouchRecoil=0.650000
     PctCrouchIronRecoil=0.450000
     PctProneIronRecoil=0.250000
     PctBipodDeployRecoil=0.010000
     PctRestDeployRecoil=0.050000
     RecoilRate=0.075000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=20.000000,Z=-2.000000)
     ShellRotOffsetIron=(Pitch=500)
     ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
     bReverseShellSpawnDirection=true
     PreFireAnim="Shoot1_start"
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.200000
     AmmoClass=Class'DH_Weapons.DH_BARAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=150.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_BARBullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=150.000000
     SpreadStyle=SS_Random
}
