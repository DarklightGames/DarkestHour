//=============================================================================
// C96Fire
//=============================================================================

class DH_C96Fire extends DH_FastAutoFire;

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

/* =================================================================================== *
* FireLoop
* 	This state handles looping the firing animations and ambient fire sounds as well
*	as firing rounds.
*
* modified by: Ramm 1/17/05
*
* Overridden here to allow semi auto fire sound handling for a fastauto weapon class
* This is an extremely messy and inefficient way of doing this, however it works - Ch!cken
* =================================================================================== */
state FireLoop
{
    function BeginState()
    {
	local DH_ProjectileWeapon RPW;

    if (ROWeapon(Weapon).UsingAutoFire())
    {
		NextFireTime = Level.TimeSeconds - 0.1; //fire now!

        RPW = DH_ProjectileWeapon(Weapon);

		if (!RPW.bUsingSights && !Instigator.bBipodDeployed)
        	weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, TweenTime);
        else
        	Weapon.LoopAnim(FireIronLoopAnim, IronLoopFireAnimRate, TweenTime);

		PlayAmbientSound(AmbientFireSound);
    }
    }

	function ServerPlayFiring()
    {
    if (!ROWeapon(Weapon).UsingAutoFire())
    {
//	    if (FireSounds.Length > 0)
    	    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_none,FireVolume,,,,false);
    }
    }

    function PlayFiring()
    {
    if (!ROWeapon(Weapon).UsingAutoFire())
    {
	if (Weapon.Mesh != none)
	{
		if (FireCount > 0)
		{
			if (Weapon.bUsingSights && Weapon.HasAnim(FireIronLoopAnim))
			{
			 	Weapon.PlayAnim(FireIronLoopAnim, FireAnimRate, 0.0);
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
			if (Weapon.bUsingSights)
			{
			 	Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
			}
			else
			{
				Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
			}
		}

//         if (FireSounds.Length > 0)
         	Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_none,FireVolume,,,,false);

         ClientPlayForceFeedback(FireForce);  // jdf

         FireCount++;
    }
    }
    }

    function PlayFireEnd()
    {
    if (!ROWeapon(Weapon).UsingAutoFire())
    {
	    if (Weapon.bUsingSights && Weapon.HasAnim(FireIronEndAnim))
     	{
      	 	Weapon.PlayAnim(FireIronEndAnim, FireEndAnimRate, FireTweenTime);
        }
        else if (Weapon.HasAnim(FireEndAnim))
        {
        	Weapon.PlayAnim(FireEndAnim, FireEndAnimRate, FireTweenTime);
        }
    }
    }


    function EndState()
    {
    if (ROWeapon(Weapon).UsingAutoFire())
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
        Weapon.PlayOwnedSound(FireEndSound,SLOT_none,FireVolume,,AmbientFireSoundRadius);
        Weapon.StopFire(ThisModeNum);

        //If we are not switching weapons, go to the idle state
        if (!Weapon.IsInState('LoweringWeapon'))
            ROWeapon(Weapon).GotoState('Idle');
    }
    }

    function StopFiring()
    {
        if (Level.NetMode == NM_DedicatedServer && HiROFWeaponAttachment.bUnReplicatedShot == true)
        {
			HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;
         	if (HiROFWeaponAttachment.DualShotCount == 255)
         	{
				HiROFWeaponAttachment.DualShotCount = 254;
			}
			else
			{
			    HiROFWeaponAttachment.DualShotCount = 255;
			}
			HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1;
    	}

        GotoState('');
    }

    function ModeTick(float dt)
    {
	    Super.ModeTick(dt);

		// WeaponTODO: See how to properly reimplement this
		if (!bIsFiring || ROWeapon(Weapon).IsBusy() || !AllowFire() || (DH_MGBase(Weapon) != none && DH_MGBase(Weapon).bBarrelFailed))  // stopped firing, magazine empty or barrel overheat
        {
			GotoState('');
			return;
		}
    }
}

defaultproperties
{
     FireEndSound=SoundGroup'DH_WeaponSounds.c96.C96_FireEnd01'
     AmbientFireSoundRadius=750.000000
     AmbientFireSound=SoundGroup'DH_WeaponSounds.c96.C96_FireLoop01'
     AmbientFireVolume=255
     ServerProjectileClass=Class'DH_Weapons.DH_C96Bullet_S'
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-20.000000)
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=75
     RecoilRate=0.050000
     ShellEjectClass=Class'ROAmmo.ShellEject1st9x19mm'
     ShellRotOffsetIron=(Pitch=5000)
     PreFireAnim="Shoot1_start"
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.066666
     AmmoClass=Class'DH_Weapons.DH_C96Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=150.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.500000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_C96Bullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stPistol'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=400.000000
     SpreadStyle=SS_Random
}
