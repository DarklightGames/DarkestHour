//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BrenFire extends DH_AutomaticFire;

var(FireAnims)  name        BipodDeployFireAnim;
var(FireAnims)  name        BipodDeployFireLoopAnim;
var(FireAnims)  name        BipodDeployFireEndAnim;

//**************************************************************************************************

function PlayFiring()
{
local   DH_BrenWeapon   BipodStatus;
BipodStatus = DH_BrenWeapon(Owner);

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
                if (Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireLoopAnim))
                {
                    Weapon.PlayAnim(BipodDeployFireLoopAnim, FireAnimRate, FireTweenTime);
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
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_none,FireVolume,,,,false);

    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

function PlayFireEnd()
{
local   DH_BrenWeapon   BipodStatus;
BipodStatus = DH_BrenWeapon(Owner);

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
     BipodDeployFireAnim="deploy_shoot_loop"
     BipodDeployFireLoopAnim="deploy_shoot_loop"
     BipodDeployFireEndAnim="deploy_shoot_end"
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-28.000000)
     PreLaunchTraceDistance=2624.000000
     bUsesTracers=true
     TracerFrequency=5
     DummyTracerClass=Class'DH_Weapons.DH_BARClientTracer'
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire01'
     maxVerticalRecoilAngle=1200
     maxHorizontalRecoilAngle=130
     PctStandIronRecoil=0.800000
     PctCrouchRecoil=0.650000
     PctCrouchIronRecoil=0.450000
     PctProneIronRecoil=0.250000
     PctBipodDeployRecoil=0.010000
     PctRestDeployRecoil=0.050000
     RecoilRate=0.075000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=10.000000,Z=-5.000000)
     ShellRotOffsetIron=(Pitch=-16200)
     bReverseShellSpawnDirection=true
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.120000
     AmmoClass=Class'DH_Weapons.DH_BrenAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=175.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_BrenBullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=125.000000
     SpreadStyle=SS_Random
}
