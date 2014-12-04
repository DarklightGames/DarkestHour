//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartCannon extends DH_ROTankCannon;

//Vars for Canister shot
var    int          CSpread; // Spread for canister shot
var    int          ProjPerFire; // Number of projectiles to spawn on each shot
var    bool         bLastShot;  // Prevents shoot effects playing for each projectile spawned

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        local int SpawnCount, ProjectileID;
        local rotator R;
        local vector X;

        if (ProjectileClass == class'DH_TankCannonShellCanisterAmerican')
        {
            SpawnCount = ProjPerFire;// DH_TankCannonShellCanister.ProjPerFire;

            X = vector(WeaponFireRotation);

            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                R.Yaw = CSpread * (FRand()-0.5);
                R.Pitch = CSpread * (FRand()-0.5);
                R.Roll = CSpread * (FRand()-0.5);

                WeaponFireRotation = rotator(X >> R);

                if (projectileID == 0)
                    bLastShot = false;
                if (projectileID == SpawnCount - 1)
                    bLastShot = true;

                if (bGunFireDebug)
                    Log("Firing Canister shot with angle: "@WeaponFireRotation);

                SpawnProjectile(ProjectileClass, false);
            }
        }
        else
            SpawnProjectile(ProjectileClass, false);
    }

    function AltFire(Controller C)
    {
        if (AltFireProjectileClass == none)
            Fire(C);
        else
            SpawnProjectile(AltFireProjectileClass, true);
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
        if (Instigator != none && Instigator.IsHumanControlled())
        {
                  FireRot.Pitch += AddedPitch;
        }

        if (!bAltFire)
                FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);

                // new tank shell dispersion function somwhere here...

        if (bGunFireDebug)
                Log("After pitch corrections FireRot "$FireRot);

    if (bGunFireDebug)
                Log("GetPitchForRange for "$CurrentRangeIndex$" = "$ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));

    if (bDoOffsetTrace)
    {
               Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
               WeaponPawn = VehicleWeaponPawn(Owner);
            if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
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

        if (bCannonShellDebugging)
                Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355 * vector(WeaponFireRotation), WeaponFireLocation, false);


   P = spawn(ProjClass, none,, StartLocation, FireRot);


        if (bGunFireDebug)
                Log("At the moment of spawning FireRot "$FireRot);

   //swap to the next round type after firing (hmm shoudn't I have this moved? Or REMOVED ???)

    if (bLastShot)
    {
        if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
        {
                ProjectileClass = PendingProjectileClass;
                if (bGunFireDebug)
                        Log("Projectile class was changed to PendingProjClass by SpawnProjectile function");
        }
    }

    //log("WeaponFireRotation = "$WeaponFireRotation);

    if (P != none)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

        if (bLastShot)
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

// American tanks must use the actual sight markings to aim!
simulated function int GetRange()
{
    return RangeSettings[0];
}

// Disable clicking sound for range adjustment
function IncrementRange()
{
    if (CurrentRangeIndex < RangeSettings.Length - 1)
    {
        if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
            //ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);

        CurrentRangeIndex++;
    }
}

function DecrementRange()
{
    if (CurrentRangeIndex > 0)
    {
        if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
            //ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);

        CurrentRangeIndex --;
    }
}

defaultproperties
{
     CSpread=500
     ProjPerFire=20
     bLastShot=true
     InitialTertiaryAmmo=15
     TertiaryProjectileClass=class'DH_Vehicles.DH_TankCannonShellCanisterAmerican'
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
     DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer'
     mTracerInterval=0.600000
     bUsesTracers=true
     bAltFireTracersOnly=true
     MinCommanderHitHeight=37.5;
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
     bAmbientAltFireSound=true
     FireInterval=3.000000
     AltFireInterval=0.120000
     EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=true
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
     FireForce="Explosion05"
     ProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
     AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
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
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=3641
     CustomPitchDownLimit=63352
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=64
     InitialSecondaryAmmo=44
     InitialAltAmmo=250
     PrimaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
     SecondaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShellHE'
     Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext'
     Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
     Skins(1)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
     Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
     SoundVolume=80
}
