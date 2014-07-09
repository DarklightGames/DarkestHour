//==============================================================================
// DH_StuartCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M5A1 (Stuart) light tank cannon
//==============================================================================
class DH_StuartCannon extends DH_ROTankCannon;

//Vars for Canister shot
var    int          CSpread; // Spread for canister shot
var    int          ProjPerFire; // Number of projectiles to spawn on each shot
var    bool         bLastShot;  // Prevents shoot effects playing for each projectile spawned

//var    bool         bUsePreLaunchTrace; // Whether or not to do a performance improving trace before potentially spawning projectiles
//var    float        PreLaunchTraceDistance; // Distance to do initial trace

// Special tracer handling for this type of cannon
/*simulated function UpdateTracer()
{
	local rotator SpawnDir;

	if (Level.NetMode == NM_DedicatedServer || !bUsesTracers)
		return;


 	if (Level.TimeSeconds > mLastTracerTime + mTracerInterval)
	{
		if (Instigator != None && Instigator.IsLocallyControlled())
		{
			SpawnDir = WeaponFireRotation;
		}
		else
		{
			SpawnDir = GetBoneRotation(WeaponFireAttachmentBone);
		}

        if (Instigator != None && !Instigator.PlayerReplicationInfo.bBot)
        {
        	SpawnDir.Pitch += AddedPitch;
        }

        Spawn(DummyTracerClass,,, WeaponFireLocation, SpawnDir);

		mLastTracerTime = Level.TimeSeconds;
	}
}
*/

state ProjectileFireMode
{
	function Fire(Controller C)
	{
	    local int SpawnCount, ProjectileID;
	    local rotator InitialRot, R;
	    local vector X;

		if(ProjectileClass == class'DH_TankCannonShellCanisterAmerican')
        {
            SpawnCount = ProjPerFire;// DH_TankCannonShellCanister.ProjPerFire;

            X = vector(WeaponFireRotation);

       	    for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
  	            R.Yaw = CSpread * (FRand()-0.5);
                R.Pitch = CSpread * (FRand()-0.5);
                R.Roll = CSpread * (FRand()-0.5);

                WeaponFireRotation = Rotator(X >> R);

                if( projectileID == 0 )
                    bLastShot = False;
                if( projectileID == SpawnCount - 1)
                    bLastShot = True;

                if(bGunFireDebug)
                    log("Firing Canister shot with angle: "@WeaponFireRotation);

                SpawnProjectile(ProjectileClass, False);
       	    }
        }
        else
            SpawnProjectile(ProjectileClass, False);
	}

	function AltFire(Controller C)
	{
		if (AltFireProjectileClass == None)
		  	Fire(C);
		else
		  	SpawnProjectile(AltFireProjectileClass, True);
	}
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local VehicleWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;
    local rotator FireRot;

        FireRot = WeaponFireRotation;

   if (bGunFireDebug)
        {
                log(self$" SpawnProjectile start, WepFireRot "$WeaponFireRotation);
                Log("FireRot "$FireRot);
                Log("ProjectileClass "$ProjClass);
        }

        // used only for Human players. Lets cannons with non centered aim points have a different aiming location
        if( Instigator != none && Instigator.IsHumanControlled() )
        {
                  FireRot.Pitch += AddedPitch;
        }

        if( !bAltFire )
                FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);

                // new tank shell dispersion function somwhere here...

        if (bGunFireDebug)
                log("After pitch corrections FireRot "$FireRot);

    if( bGunFireDebug )
                log("GetPitchForRange for "$CurrentRangeIndex$" = "$ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));

    if (bDoOffsetTrace)
    {
               Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
               WeaponPawn = VehicleWeaponPawn(Owner);
            if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
            {
                    if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
                        StartLocation = HitLocation;
                else
                        StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
        }
        else
        {
                if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
                        StartLocation = HitLocation;
                else
                        StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
        }
    }
    else
            StartLocation = WeaponFireLocation;

        if( bCannonShellDebugging )
                Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355 * Vector(WeaponFireRotation), WeaponFireLocation, false);


   P = spawn(ProjClass, none, , StartLocation, FireRot);


        if (bGunFireDebug)
                log("At the moment of spawning FireRot "$FireRot);

   //swap to the next round type after firing (hmm shoudn't I have this moved? Or REMOVED ???)

    if( bLastShot )
    {
        if( PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass )
        {
                ProjectileClass = PendingProjectileClass;
                if( bGunFireDebug )
                        log("Projectile class was changed to PendingProjClass by SpawnProjectile function");
        }
    }

    //log("WeaponFireRotation = "$WeaponFireRotation);

    if (P != None)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

        if( bLastShot )
        {
            FlashMuzzleFlash(bAltFire);

            // Play firing noise
            if (bAltFire)
            {
                if (bAmbientAltFireSound)
                {
                    AmbientSound = AltFireSoundClass;
                    SoundVolume = AltFireSoundVolume;
                    SoundRadius = AltFireSoundRadius;
                    AmbientSoundScaling = AltFireSoundScaling;
                }
                else
                    PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
            }
            else
            {
                if (bAmbientFireSound)
                    AmbientSound = FireSoundClass;
                else
                {
                    PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
                }
            }
        }
    }

    return P;
}

/*state ProjectileFireMode
{
    function Fire(Controller C)
	{
	    local int SpawnCount, ProjectileID;
	    local rotator InitialRot, R;
	    local vector X;

		if(ProjectileClass == class'DH_TankCannonShellCanister')
        {
            SpawnCount = ProjPerFire;// DH_TankCannonShellCanister.ProjPerFire;

            X = vector(WeaponFireRotation);

       	    for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
  	            R.Yaw = CSpread * (FRand()-0.5);
                R.Pitch = CSpread * (FRand()-0.5);
                R.Roll = CSpread * (FRand()-0.5);

                WeaponFireRotation = Rotator(X >> R);

                if(bGunFireDebug)
                    log("Firing Canister shot proj with angle: "@WeaponFireRotation);

                // Only play shooting sound & effects on the first projectile
                if( projectileID == 0 )
                    SpawnCanisterProjectile(ProjectileClass, True);
                else
                    SpawnCanisterProjectile(ProjectileClass, False);
       	    }
        }
        else
            SpawnProjectile(ProjectileClass, False);
	}

	function AltFire(Controller C)
	{
		if (AltFireProjectileClass == None)
		  	Fire(C);
		else
		  	SpawnProjectile(AltFireProjectileClass, True);
	}
}


function Projectile SpawnCanisterProjectile(class<Projectile> ProjClass, bool bPlayShootEffects)
{
    local Projectile P;
    local VehicleWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;
    local rotator FireRot;
    local Vector ProjectileDir, End, PTHitLocation, PTHitNormal;
    local array<int>	HitPoints;
	local Actor Other;
	local DH_Pawn HitPawn;
	local ROWeaponAttachment WeapAttach;

        FireRot = WeaponFireRotation;

   if (bGunFireDebug)
        {
                log(self$" SpawnProjectile start, WepFireRot "$WeaponFireRotation);
                Log("FireRot "$FireRot);
                Log("ProjectileClass "$ProjClass);
        }

        // used only for Human players. Lets cannons with non centered aim points have a different aiming location
        if( Instigator != none && Instigator.IsHumanControlled() )
        {
                  FireRot.Pitch += AddedPitch;
        }

        if (bGunFireDebug)
                log("After pitch corrections FireRot "$FireRot);

    if( bGunFireDebug )
                log("GetPitchForRange for "$CurrentRangeIndex$" = "$ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));

    if (bDoOffsetTrace)
    {
               Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
               WeaponPawn = VehicleWeaponPawn(Owner);
            if (WeaponPawn != None && WeaponPawn.VehicleBase != None)
            {
                    if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
                        StartLocation = HitLocation;
                else
                        StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
        }
        else
        {
                if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
                        StartLocation = HitLocation;
                else
                        StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
        }
    }
    else
            StartLocation = WeaponFireLocation;

        if( bCannonShellDebugging )
                Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355 * Vector(WeaponFireRotation), WeaponFireLocation, false);


    if ( bUsePreLaunchTrace ) // Leaving this function as optional in case we want to disable it for reasons of penetration in future
	{
		ProjectileDir = Vector(FireRot);
		End = StartLocation + PreLaunchTraceDistance * ProjectileDir;

        log("Running Trace");

		// Lets avoid all that casting
//		WeapAttach =  ROWeaponAttachment(Weapon.ThirdPersonActor);

		// Do precision hit point pre-launch trace to see if we hit a player or something else
		Other = Trace(PTHitLocation, PTHitNormal, End, StartLocation);

 		//Instigator.DrawStayingDebugLine(Start, End, 255,0,0);
		// This is a bit of a hack, but it prevents bots from killing other players in most instances
		// Bots with a giant tank mounted shotgun... yeah, I'm leaving this check in place - PsYcH0_Ch!cKeN
		if( !Instigator.IsHumanControlled() && Pawn(Other) != none && Instigator.Controller.SameTeamAs(Pawn(Other).Controller))
		{
			//log(Instigator$"'s shot would hit "$Other$" who is on the same team");
			return none;
		}

		if ( Other != None && Other != Instigator && Other.Base != Instigator)
		{
			if ( !Other.bWorldGeometry )
			{
				// Update hit effect except for pawns (blood) other than vehicles.
				if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume') &&
				 !Other.IsA('ROVehicleWeapon')))
				{
//					WeapAttach.UpdateHit(Other, HitLocation, HitNormal);
				}

				if(Other.IsA('ROVehicleWeapon') && !ROVehicleWeapon(Other).HitDriverArea(HitLocation, ProjectileDir))
				{
//				    WeapAttach.UpdateHit(Other, HitLocation, HitNormal);
				}

				if( Other.IsA('ROVehicle'))
				{
					Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),class<ROBullet>(ProjectileClass).default.MyVehicleDamage);
				}
				else
				{
					HitPawn = DH_Pawn(Other);

			    	if ( HitPawn != none )
			    	{
	                     // Hit detection debugging
						 //log("PreLaunchTrace hit "$HitPawn.PlayerReplicationInfo.PlayerName);
						 //HitPawn.HitStart = Start;
						 //HitPawn.HitEnd = End;
                         if(!HitPawn.bDeleteMe)
						 	HitPawn.ProcessLocationalDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType,HitPoints);

                         // Hit detection debugging
						 //if( Level.NetMode == NM_Standalone)
						 //	  HitPawn.DrawBoneLocation();
			    	}
			    	else
			    	{
						Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType);
					}
				}
			}
			else
			{
				if ( WeapAttach != None )
				{
//					WeapAttach.UpdateHit(Other,HitLocation,HitNormal);
				}

				if( RODestroyableStaticMesh(Other) != none )
				{
				    Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType);
				    if( RODestroyableStaticMesh(Other).bWontStopBullets )
				    {
				    	Other = none;
				    }
				}
			}

			if( PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass )
            {
                ProjectileClass = PendingProjectileClass;
                if( bGunFireDebug )
                        log("Projectile class was changed to PendingProjClass by SpawnProjectile function");
            }

            if( bPlayShootEffects )
            {
                if (bAmbientFireSound)
                    AmbientSound = FireSoundClass;
                else
                {
                    PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
                }
            }
		}

		// Return because we already hit something
		if ( Other != none )
			return none;
	}

    P = spawn(ProjClass, none, , StartLocation, FireRot);

    if(P!=none) log("Spawned Projectile");


        if (bGunFireDebug)
                log("At the moment of spawning FireRot "$FireRot);

   //swap to the next round type after firing (hmm shoudn't I have this moved? Or REMOVED ???)

    if( PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass )
        {
                ProjectileClass = PendingProjectileClass;
                if( bGunFireDebug )
                        log("Projectile class was changed to PendingProjClass by SpawnProjectile function");
        }

    //log("WeaponFireRotation = "$WeaponFireRotation);

    if (P != None)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

        if( bPlayShootEffects )
        {
            if (bAmbientFireSound)
                AmbientSound = FireSoundClass;
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
            }
        }
    }

    return P;
}*/

// American tanks must use the actual sight markings to aim!
simulated function int GetRange()
{
	return RangeSettings[0];
}

// Disable clicking sound for range adjustment
function IncrementRange()
{
	if( CurrentRangeIndex < RangeSettings.Length - 1 )
	{
		if( Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none )
			//ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

		CurrentRangeIndex++;
	}
}

function DecrementRange()
{
	if( CurrentRangeIndex > 0 )
	{
		if( Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none )
			//ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

		CurrentRangeIndex --;
	}
}

defaultproperties
{
     CSpread=500
     ProjPerFire=20
     bLastShot=True
     InitialTertiaryAmmo=15
     TertiaryProjectileClass=Class'DH_Vehicles.DH_TankCannonShellCanister'
     SecondarySpread=0.001450
     ManualRotationsPerSecond=0.040000
     PoweredRotationsPerSecond=0.083000
     FrontArmorFactor=5.100000
     RightArmorFactor=3.200000
     LeftArmorFactor=3.200000
     RearArmorFactor=3.200000
     FrontArmorSlope=10.000000
     FrontLeftAngle=323.000000
     FrontRightAngle=37.000000
     RearRightAngle=143.000000
     RearLeftAngle=217.000000
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
     ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
     CannonFireSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
     CannonFireSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(2)="Canister"
     RangeSettings(1)=400
     RangeSettings(2)=800
     RangeSettings(3)=1200
     RangeSettings(4)=1600
     AddedPitch=18
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=6
     DummyTracerClass=Class'DH_Vehicles.DH_30CalVehicleClientTracer'
     mTracerInterval=0.600000
     bUsesTracers=True
     bAltFireTracersOnly=True
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=10.000000))
     VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-12.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Gun"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=85.000000
     AltFireOffset=(X=26.000000,Y=7.000000,Z=1.000000)
     RotationsPerSecond=0.083000
     bAmbientAltFireSound=True
     FireInterval=3.000000
     AltFireInterval=0.120000
     EffectEmitterClass=Class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=Class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=True
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_StuartCannonShell'
     AltFireProjectileClass=Class'DH_Vehicles.DH_30CalVehicleBullet'
     ShakeRotMag=(Z=50.000000)
     ShakeRotRate=(Z=600.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=6.000000
     AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeRotTime=2.000000
     AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=True,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=3641
     CustomPitchDownLimit=63352
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=64
     InitialSecondaryAmmo=44
     InitialAltAmmo=250
     PrimaryProjectileClass=Class'DH_Vehicles.DH_StuartCannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_StuartCannonShellHE'
     Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext'
     Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
     Skins(1)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
     Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
     SoundVolume=80
}
