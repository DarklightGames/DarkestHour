//=============================================================================
// DH_EnfieldNo4ScopedFire
//=============================================================================

class DH_EnfieldNo4ScopedFire extends DH_BoltFire;

simulated function HandleRecoil()
{
	local rotator NewRecoilRotation;
	local ROPlayer ROP;
	local ROPawn ROPwn;

    if( Instigator != none )
    {
		ROP = ROPlayer(Instigator.Controller);
		ROPwn = ROPawn(Instigator);
	}

    if( ROP == none || ROPwn == none )
    	return;

	if( !ROP.bFreeCamera )
	{
      	NewRecoilRotation.Pitch = RandRange( maxVerticalRecoilAngle * 0.75, maxVerticalRecoilAngle );
     	NewRecoilRotation.Yaw = RandRange( maxHorizontalRecoilAngle * 0.75, maxHorizontalRecoilAngle );

      	if( Rand( 2 ) == 1 )
         	NewRecoilRotation.Yaw *= -1;

        if( Instigator.Physics == PHYS_Falling )
        {
      		NewRecoilRotation *= 3;
        }

		// WeaponTODO: Put bipod and resting modifiers in here
	    if( Instigator.bIsCrouched )
	    {
	        NewRecoilRotation *= PctCrouchRecoil;

			// player is crouched and in iron sights
	        if( Weapon.bUsingSights )
	        {
	            NewRecoilRotation *= PctCrouchIronRecoil;
	        }
	    }
	    else if( Instigator.bIsCrawling )
	    {
	        NewRecoilRotation *= PctProneRecoil;

	        // player is prone and in iron sights
	        if( Weapon.bUsingSights )
	        {
	            NewRecoilRotation *= PctProneIronRecoil;
	        }
	    }
	    else if( Weapon.bUsingSights )
	    {
	        NewRecoilRotation *= PctStandIronRecoil;
	    }

        if( ROPwn.bRestingWeapon )
        	NewRecoilRotation *= PctRestDeployRecoil;

        if( Instigator.bBipodDeployed )
		{
			NewRecoilRotation *= PctBipodDeployRecoil;
		}

		if( ROPwn.LeanAmount != 0 )
		{
			NewRecoilRotation *= PctLeanPenalty;
		}

		// Need to set this value per weapon
 		ROP.SetRecoil(NewRecoilRotation,RecoilRate);
 	}

// Add Fire Blur
    if( Level.NetMode != NM_DedicatedServer )
    {
    	if( Instigator != None )
    	{
    		if( ROPlayer( Instigator.Controller ) != None )
    		{
			    if( Weapon.bUsingSights )
			    {
			    	ROPlayer( Instigator.Controller ).AddBlur( 0.1, 0.1 );
			    }
			    else
			    {
			    	ROPlayer( Instigator.Controller ).AddBlur( 0.01, 0.1 );
			    }
			}
		}
    }
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-35.000000)
     FireIronAnim="Scope_Shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=100
     PctRestDeployRecoil=0.250000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=10.000000,Y=3.000000,Z=-5.000000)
     bWaitForRelease=True
     FireAnim="shoot_last"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.400000
     AmmoClass=Class'DH_Weapons.DH_EnfieldNo4Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_EnfieldNo4ScopedBullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=500.000000
     Spread=30.000000
     SpreadStyle=SS_Random
}
