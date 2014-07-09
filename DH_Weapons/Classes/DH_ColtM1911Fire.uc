//=============================================================================
// DH_ColtM1911Fire
//=============================================================================

class DH_ColtM1911Fire extends DH_PistolFire;

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
     FireLastAnim="shoot_last"
     FireIronLastAnim="Iron_Shoot_Last"
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-15.000000)
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Colt45.Colt45_Fire01'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=75
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x25mm'
     ShellIronSightOffset=(X=10.000000)
     ShellHipOffset=(Y=3.000000)
     ShellRotOffsetHip=(Pitch=2500,Yaw=4000)
     bReverseShellSpawnDirection=True
     bWaitForRelease=True
     FireAnim="shoot"
     TweenTime=0.000000
     FireRate=0.200000
     AmmoClass=Class'DH_Weapons.DH_ColtM1911Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=1.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_ColtM1911Bullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stPistol'
     aimerror=800.000000
     Spread=430.000000
     SpreadStyle=SS_Random
}
