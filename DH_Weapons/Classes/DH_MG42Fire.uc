//=============================================================================
// DH_MG42Fire
//=============================================================================
// Bullet firing class for the MG42 Machine Gun
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_MG42Fire extends DH_MGAutomaticFire;

// So we don't have to cast 1200 times per minute :)
var DH_MG42Weapon MGWeapon;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	MGWeapon = DH_MG42Weapon(Weapon);
}

event ModeDoFire()
{
	Super.ModeDoFire();

	if( Level.NetMode != NM_DedicatedServer )
		MGWeapon.UpdateAmmoBelt();
}

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
    if( Level.NetMode != NM_DedicatedServer && Instigator != None && ROPlayer( Instigator.Controller ) != None )
		ROPlayer( Instigator.Controller ).AddBlur( 0.04, 0.1 );
}

defaultproperties
{
     FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
     AmbientFireSoundRadius=750.000000
     AmbientFireSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
     AmbientFireVolume=255
     PackingThresholdTime=0.120000
     ServerProjectileClass=Class'DH_Weapons.DH_MG42Bullet_S'
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-145.000000,Y=-15.000000,Z=-15.000000)
     bUsesTracers=True
     TracerFrequency=7
     DummyTracerClass=Class'DH_Weapons.DH_MG42ClientTracer'
     FireIronAnim="Shoot_Loop"
     FireIronLoopAnim="Shoot_Loop"
     FireIronEndAnim="Shoot_End"
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     RecoilRate=0.031250
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=15.000000,Z=-6.000000)
     ShellRotOffsetIron=(Pitch=-1500)
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.050000
     AmmoClass=Class'DH_Weapons.DHMG250Rd792x57Ammo'
     ShakeRotMag=(X=25.000000,Y=25.000000,Z=25.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=1.750000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'DH_Weapons.DH_MG42Bullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1800.000000
     Spread=125.000000
     SpreadStyle=SS_Random
}
