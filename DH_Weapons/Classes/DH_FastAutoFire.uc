//=============================================================================
// DH_FastAutoFire
//=============================================================================
// An automatic fire class for weapons with very high (> 500 rpm)
// cyclic rates. This class and the ROHighROFWeaponAttachment class
// will reduce net bandwidth and CPU overhead
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_FastAutoFire extends DH_AutomaticFire;

//=============================================================================
// Variables
//=============================================================================

// internal class vars
var 	float					LastCalcTime;               // Internal var used to calculate when to replicate the dual shots
var DHHighROFWeaponAttachment	HiROFWeaponAttachment;      // A high ROF WA that this class will use to pack fire info

// Animation
var 	float					LoopFireAnimRate;			// The rate to play the looped fire animation when hipped
var 	float					IronLoopFireAnimRate;       // The rate to play the looped fire animation when deployed or in iron sights

// sound
var 	sound   				FireEndSound;				// The sound to play at the end of the ambient fire sound
var 	float   				AmbientFireSoundRadius;		// The sound radius for the ambient fire sound
var		sound					AmbientFireSound;           // How loud to play the looping ambient fire sound
var		byte					AmbientFireVolume;          // The ambient fire sound

// High ROF system
var 	float					PackingThresholdTime;		// If the shots are closer than this amount, the dual shot will be used
var() class<ROServerBullet> 	ServerProjectileClass; 		// class for the server only projectile for this weapon


//=============================================================================
// Functions
//=============================================================================

// overriden to support packing two shots together to save net bandwidth
function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int projectileID;
    local int SpawnCount;
    local float theta;
    local coords MuzzlePosition;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

	// if weapon in iron sights, spawn at eye position, otherwise spawn at muzzle tip
 	if( Instigator.weapon.bUsingSights || Instigator.bBipodDeployed )
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();
		StartProj = StartTrace + X * ProjSpawnOffset.X;

		// check if projectile would spawn through a wall and adjust start location accordingly
		Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
		if (Other != none )
		{
	   		StartProj = HitLocation;
		}
	}
	else
	{
        MuzzlePosition = Weapon.GetMuzzleCoords();//Weapon.GetBoneCoords('Muzzle');

		// Get the muzzle position and scale it down 5 times (since the model is scaled up 5 times in the editor)
        StartTrace = MuzzlePosition.Origin - Weapon.Location;
		StartTrace = StartTrace * 0.2;
		StartTrace = Weapon.Location + StartTrace;

        //Spawn(class 'ROEngine.RODebugTracer',Instigator,,StartTrace,rotator(MuzzlePosition.XAxis));

		StartProj = StartTrace + MuzzlePosition.XAxis * FAProjSpawnOffset.X;

        //Spawn(class 'ROEngine.RODebugTracer',Instigator,,StartProj,rotator(MuzzlePosition.XAxis));

       	Other = Trace(HitLocation, HitNormal, StartTrace, StartProj, true);// was false to only trace worldgeometry

		// Instead of just checking walls, lets check all actors. That way we won't have rounds
		// spawning on the other side of players and missing them altogether - Ramm 10/14/04
		if( Other != none )
		{
			StartProj = HitLocation;
		}
	}
    Aim = AdjustAim(StartProj, AimError);

	// For free-aim, just use where the muzzlebone is pointing
	if( !Instigator.Weapon.bUsingSights && !Instigator.bBipodDeployed && Instigator.weapon.bUsesFreeAim
		&& Instigator.IsHumanControlled())
	{
		Aim = rotator(MuzzlePosition.XAxis);
	}

    SpawnCount = Max(1, ProjPerFire * int(Load));

    CalcSpreadModifiers();

	if( (DH_MGBase(Owner) != none) && DH_MGBase(Owner).bBarrelDamaged )
	{
		AppliedSpread = 4 * Spread;
	}
	else
	{
		AppliedSpread = Spread;
	}

    switch (SpreadStyle)
    {
        case SS_Random:
           	X = Vector(Aim);
           	for (projectileID = 0; projectileID < SpawnCount; projectileID++)
           	{
              	R.Yaw = AppliedSpread * ((FRand()-0.5)/1.5);
              	R.Pitch = AppliedSpread * (FRand()-0.5);
              	R.Roll = AppliedSpread * (FRand()-0.5);

                HandleProjectileSpawning(StartProj, Rotator(X >> R));
           	}
           	break;

        case SS_Line:
           	for (projectileID = 0; projectileID < SpawnCount; projectileID++)
           	{
              	theta = AppliedSpread*PI/32768*(projectileID - float(SpawnCount-1)/2.0);
              	X.X = Cos(theta);
              	X.Y = Sin(theta);
              	X.Z = 0.0;
              	HandleProjectileSpawning(StartProj, Rotator(X >> Aim));
           	}
           	break;

        default:
           	HandleProjectileSpawning(StartProj, Aim);
    }
}

// This function handles combining the shots and when to replicate them
function HandleProjectileSpawning(vector SpawnPoint, rotator SpawnAim)
{
	if( Level.NetMode == NM_Standalone )
	{
	   super(DH_ProjectileFire).SpawnProjectile(SpawnPoint, SpawnAim);
	   return;
	}

	if( HiROFWeaponAttachment == none )
	{
		HiROFWeaponAttachment = DHHighROFWeaponAttachment(Weapon.ThirdPersonActor);
	}

	SpawnProjectile(SpawnPoint, SpawnAim);

	if( Level.NetMode == NM_Standalone )
	{
	   return;
	}
	else if((Level.TimeSeconds - LastCalcTime ) > PackingThresholdTime)
	{
		HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
		HiROFWeaponAttachment.bUnReplicatedShot = true;
	}
	else
	{
		if( HiROFWeaponAttachment.bFirstShot )
		{
			HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
			HiROFWeaponAttachment.bFirstShot = false;
			HiROFWeaponAttachment.bUnReplicatedShot = true;
		}
		else
		{
			HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;
			HiROFWeaponAttachment.SavedDualShot.Secondshot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
			HiROFWeaponAttachment.bFirstShot = true;

			// Skip 255 as we will use it for a special trigger
			if( HiROFWeaponAttachment.DualShotCount < 254 )
			{
				HiROFWeaponAttachment.DualShotCount ++;
			}
			else
			{
				HiROFWeaponAttachment.DualShotCount = 1;
			}
			HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1;

			HiROFWeaponAttachment.bUnReplicatedShot = false;
		}
	}

	LastCalcTime = Level.TimeSeconds;
}

// Plays the animation at the end of firing the weapon
function PlayFireEnd()
{
	local DH_ProjectileWeapon RPW;

	RPW = DH_ProjectileWeapon(Weapon);

	if ( RPW.HasAnim(FireEndAnim) && !RPW.bUsingSights && !Instigator.bBipodDeployed )
		RPW.PlayAnim(FireEndAnim, FireEndAnimRate, TweenTime);
	else if ( RPW.HasAnim(FireIronEndAnim) && ( RPW.bUsingSights || Instigator.bBipodDeployed))
		RPW.PlayAnim(FireIronEndAnim, FireEndAnimRate, TweenTime);
}

// Sends the fire class to the looping state
function StartFiring()
{
   GotoState('FireLoop');
}

// Handles toggling the weapon attachment's ambient sound on and off
function PlayAmbientSound(Sound aSound)
{
	local WeaponAttachment WA;

	WA = WeaponAttachment(Weapon.ThirdPersonActor);

    if ( Weapon == none || (WA == none))
        return;

	if(aSound == None)
	{
		WA.SoundVolume = WA.default.SoundVolume;
		WA.SoundRadius = WA.default.SoundRadius;
	}
	else
	{
		WA.SoundVolume = AmbientFireVolume;
		WA.SoundRadius = AmbientFireSoundRadius;
	}

    WA.AmbientSound = aSound;
}

// Make sure we are in the fire looping state when we fire
event ModeDoFire()
{
	if( !ROWeapon(Owner).IsBusy() && AllowFire() && IsInState('FireLoop'))
	{
	    Super.ModeDoFire();
	}
//    else if( abs(ROWeaponPtr.mouseClickTime - Level.TimeSeconds ) < 0.02 )
//    {
//		PlayWeaponEmptySound();
//    }
}

/* =================================================================================== *
* FireLoop
* 	This state handles looping the firing animations and ambient fire sounds as well
*	as firing rounds.
*
* modified by: Ramm 1/17/05
* =================================================================================== */
state FireLoop
{
    function BeginState()
    {
		local DH_ProjectileWeapon RPW;

		NextFireTime = Level.TimeSeconds - 0.1; //fire now!

        RPW = DH_ProjectileWeapon(Weapon);

		if( !RPW.bUsingSights && !Instigator.bBipodDeployed)
        	weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, TweenTime);
        else
        	Weapon.LoopAnim(FireIronLoopAnim, IronLoopFireAnimRate, TweenTime);

		PlayAmbientSound(AmbientFireSound);
    }

	// Overriden because we play an anbient fire sound
    function PlayFiring() {}
	function ServerPlayFiring() {}

    function EndState()
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
        Weapon.PlayOwnedSound(FireEndSound,SLOT_None,FireVolume,,AmbientFireSoundRadius);
        Weapon.StopFire(ThisModeNum);

        //If we are not switching weapons, go to the idle state
        if ( !Weapon.IsInState('LoweringWeapon') )
            ROWeapon(Weapon).GotoState('Idle');
    }

    function StopFiring()
    {
        if (Level.NetMode == NM_DedicatedServer && HiROFWeaponAttachment.bUnReplicatedShot == true)
        {
			HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;
         	if( HiROFWeaponAttachment.DualShotCount == 255)
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
		if ( !bIsFiring || ROWeapon(Weapon).IsBusy() || !AllowFire() || (DH_MGBase(Weapon) != none && DH_MGBase(Weapon).bBarrelFailed) )  // stopped firing, magazine empty or barrel overheat
        {
			GotoState('');
			return;
		}
    }
}

/* =================================================================================== *
* SpawnProjectile()
* 	Launches a server side only projectile . Also performs a prelaunch trace to see if
* 	we would hit something close before spawning a bullet. This way we don't ever
*	spawn a bullet if we would hit something so close that the ballistics wouldn't
*	matter anyway. Don't use pre-launch trace for things like rocket launchers
*
* modified by: Ramm 1/17/05
* =================================================================================== */
function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile spawnedprojectile;
	local Vector ProjectileDir, End, HitLocation, HitNormal, SnapTraceEnd;
	local Actor Other;
	local ROPawn HitPawn;
	local DHWeaponAttachment WeapAttach;
	local array<int>	HitPoints;

     // do any additional pitch changes before launching the projectile
	Dir.Pitch += AddedPitch;

	// Perform prelaunch trace
	if ( bUsePreLaunchTrace )
	{
		ProjectileDir = Vector(Dir);
		End = Start + PreLaunchTraceDistance * ProjectileDir;
		SnapTraceEnd = Start + SnapTraceDistance * ProjectileDir;

		// Lets avoid all that casting
	     WeapAttach =   DHWeaponAttachment(Weapon.ThirdPersonActor);

		// Do precision hit point pre-launch trace to see if we hit a player or something else
		Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 0);  // WhizType was 1, set to 0 to prevent sound trigger

		if ( Other != None && Other != Instigator && Other.Base != Instigator)
		{
			if ( !Other.bWorldGeometry )
			{
				if( Other.IsA('ROVehicle'))
				{
					Other.TakeDamage(ServerProjectileClass.default.Damage, Instigator, HitLocation, ServerProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ServerProjectileClass.default.MyVehicleDamage);
				}
				else
				{
					HitPawn = ROPawn(Other);

			    	if ( HitPawn != none  )
			    	{
				    	if(!HitPawn.bDeleteMe)
							HitPawn.ProcessLocationalDamage(ServerProjectileClass.default.Damage, Instigator, HitLocation, ServerProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ServerProjectileClass.default.MyDamageType,HitPoints);
			    	}
			    	else
			    	{
						Other.TakeDamage(ServerProjectileClass.default.Damage, Instigator, HitLocation, ServerProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ServerProjectileClass.default.MyDamageType);
					}
				}
			}
			else
			{
				if( RODestroyableStaticMesh(Other) != none )
				{
				    Other.TakeDamage(ServerProjectileClass.default.Damage, Instigator, HitLocation, ServerProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ServerProjectileClass.default.MyDamageType);
				    if( RODestroyableStaticMesh(Other).bWontStopBullets )
				    {
				    	Other = none;
				    }
				}
			}
		}

		// Return because we already hit something
		if ( Other != none )
			return none;
	}

   	if( ServerProjectileClass != none )
       	spawnedprojectile = Spawn(ServerProjectileClass,,, Start, Dir);

    if( spawnedprojectile == none )
        return None;

    return spawnedprojectile;
}

defaultproperties
{
     LoopFireAnimRate=1.000000
     IronLoopFireAnimRate=1.000000
     PackingThresholdTime=0.100000
     NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
}
