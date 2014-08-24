//=============================================================================
// DH_STG44Fire
//=============================================================================
// Bullet firing class for the STG44 rifle
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_STG44Fire extends DH_AutomaticFire;

function ModeTick(float dt)
{
    Super.ModeTick(dt);

    // WeaponTODO: See how to properly reimplement this
    if (bIsFiring && !AllowFire() /*|| bNowWaiting */)  // stopped firing, magazine empty or barrel overheat
    {
        Weapon.StopFire(ThisModeNum);
    }
}

simulated function HandleRecoil()
{
    local rotator NewRecoilRotation;
    local ROPlayer ROP;
    local ROPawn ROPwn;

    if (Instigator != none)
    {
        ROP = ROPlayer(Instigator.Controller);
        ROPwn = ROPawn(Instigator);
    }

    if (ROP == none || ROPwn == none)
        return;

    if (!ROP.bFreeCamera)
    {
        NewRecoilRotation.Pitch = RandRange(maxVerticalRecoilAngle * 0.75, maxVerticalRecoilAngle);
        NewRecoilRotation.Yaw = RandRange(maxHorizontalRecoilAngle * 0.75, maxHorizontalRecoilAngle);

        if (Rand(2) == 1)
            NewRecoilRotation.Yaw *= -1;

        if (Instigator.Physics == PHYS_Falling)
        {
            NewRecoilRotation *= 3;
        }

        // WeaponTODO: Put bipod and resting modifiers in here
        if (Instigator.bIsCrouched)
        {
            NewRecoilRotation *= PctCrouchRecoil;

            // player is crouched and in iron sights
            if (Weapon.bUsingSights)
            {
                NewRecoilRotation *= PctCrouchIronRecoil;
            }
        }
        else if (Instigator.bIsCrawling)
        {
            NewRecoilRotation *= PctProneRecoil;

            // player is prone and in iron sights
            if (Weapon.bUsingSights)
            {
                NewRecoilRotation *= PctProneIronRecoil;
            }
        }
        else if (Weapon.bUsingSights)
        {
            NewRecoilRotation *= PctStandIronRecoil;
        }

        if (ROPwn.bRestingWeapon)
            NewRecoilRotation *= PctRestDeployRecoil;

        if (Instigator.bBipodDeployed)
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if (ROPwn.LeanAmount != 0)
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        // Need to set this value per weapon
        ROP.SetRecoil(NewRecoilRotation,RecoilRate);
    }

// Add Fire Blur
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Instigator != none)
        {
            if (ROPlayer(Instigator.Controller) != none)
            {
                if (Weapon.bUsingSights)
                {
                    ROPlayer(Instigator.Controller).AddBlur(0.1, 0.1);
                }
                else
                {
                    ROPlayer(Instigator.Controller).AddBlur(0.01, 0.1);
                }
            }
        }
    }
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-28.000000)
     PreLaunchTraceDistance=1836.000000
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire03'
     maxVerticalRecoilAngle=700
     maxHorizontalRecoilAngle=200
     RecoilRate=0.075000
     ShellEjectClass=Class'ROAmmo.ShellEject1st556mm'
     ShellIronSightOffset=(X=10.000000,Z=-5.000000)
     ShellRotOffsetIron=(Pitch=2000)
     bReverseShellSpawnDirection=true
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.110000
     AmmoClass=Class'ROAmmo.STG44Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=175.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_STG44Bullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=150.000000
     SpreadStyle=SS_Random
}
