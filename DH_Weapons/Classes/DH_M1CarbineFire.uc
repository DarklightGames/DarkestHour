//=============================================================================
// G41Fire
//=============================================================================
// Bullet firing class for the G41 rifle
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_M1CarbineFire extends DH_SemiAutoFire;

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
     FAProjSpawnOffset=(X=-30.000000)
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire03'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=150
     ShellEjectClass=Class'ROAmmo.ShellEject1st556mm'
     ShellIronSightOffset=(X=15.000000)
     ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
     bWaitForRelease=true
     FireAnim="shoot"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=0.200000
     AmmoClass=Class'DH_Weapons.DH_M1CarbineAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=200.000000)
     ShakeRotRate=(X=12500.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_M1CarbineBullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSVT'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=165.000000
     SpreadStyle=SS_Random
}
