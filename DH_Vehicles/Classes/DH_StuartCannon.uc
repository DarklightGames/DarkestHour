//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartCannon extends DHTankCannon;

// Vars for canister shot:
var    int          CSpread;     // Spread for canister shot
var    int          ProjPerFire; // Number of projectiles to spawn on each shot
var    bool         bLastShot;   // Prevents shoot effects playing for each projectile spawned


state ProjectileFireMode
{
    function Fire(Controller C)
    {
        local int     SpawnCount, ProjectileID;
        local rotator R;
        local vector  X;

        if (ProjectileClass == TertiaryProjectileClass)
        {
            SpawnCount = ProjPerFire;

            X = vector(WeaponFireRotation);

            for (ProjectileID = 0; ProjectileID < SpawnCount; projectileID++)
            {
                R.Yaw   = CSpread * (FRand() - 0.5);
                R.Pitch = CSpread * (FRand() - 0.5);
                R.Roll  = CSpread * (FRand() - 0.5);

                WeaponFireRotation = rotator(X >> R);

                if (ProjectileID == 0)
                {
                    bLastShot = false;
                }

                if (ProjectileID == (SpawnCount - 1))
                {
                    bLastShot = true;
                }

                if (bGunFireDebug)
                {
                    Log("Firing canister shot with angle:" @ WeaponFireRotation);
                }

                SpawnProjectile(ProjectileClass, false);
            }
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile        P;
    local VehicleWeaponPawn WeaponPawn;
    local vector            StartLocation, HitLocation, HitNormal, Extent;
    local rotator           FireRot;

    FireRot = WeaponFireRotation;

    if (bGunFireDebug)
    {
        Log(self @ "SpawnProjectile start: WepFireRot =" @ WeaponFireRotation);
        Log("FireRot =" @ FireRot);
        Log("ProjectileClass =" @ ProjClass);
    }

    // Used only for Human players - lets cannons with non centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bGunFireDebug && RangeSettings.Length > 0)
    {
        Log("After pitch corrections FireRot =" @ FireRot);
        Log("GetPitchForRange for" @ CurrentRangeIndex @ " = " @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
    }

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = VehicleWeaponPawn(Owner);

        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation,
                WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
    }
    else
    {
        StartLocation = WeaponFireLocation;
    }

    if (bCannonShellDebugging)
    {
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355.0 * vector(WeaponFireRotation), WeaponFireLocation, false);
    }

    P = Spawn(ProjClass, none, , StartLocation, FireRot);

    if (bGunFireDebug)
    {
        Log("At the moment of spawning: FireRot =" @ FireRot);
    }

    // Swap to the next round type after firing (hmm shouldn't I have this moved? or REMOVED ???)
    if (bLastShot && PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
    {
        ProjectileClass = PendingProjectileClass;

        if (bGunFireDebug)
        {
            Log("Projectile class was changed to PendingProjClass by SpawnProjectile function");
        }
    }

    if (P != none)
    {
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

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
                {
                    PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0, , AltFireSoundRadius, , false);
                }
            }
            else
            {
                if (bAmbientFireSound)
                {
                    AmbientSound = FireSoundClass;
                }
                else
                {
                    PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0, , FireSoundRadius, , false);
                }
            }
        }
    }

    return P;
}

defaultproperties
{
    CSpread=500
    ProjPerFire=20
    bLastShot=true
    InitialTertiaryAmmo=15
    TertiaryProjectileClass=class'DH_Vehicles.DH_TankCannonShellCanisterAmerican'
    SecondarySpread=0.00145
    ManualRotationsPerSecond=0.04
    PoweredRotationsPerSecond=0.083
    FrontArmorFactor=5.1
    RightArmorFactor=3.2
    LeftArmorFactor=3.2
    RearArmorFactor=3.2
    FrontArmorSlope=10.0
    FrontLeftAngle=323.0
    FrontRightAngle=37.0
    RearRightAngle=143.0
    RearLeftAngle=217.0
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    CannonFireSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    CannonFireSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(2)="Canister"
    AddedPitch=18
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=6
    AltTracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    AltFireTracerFrequency=5
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=37.5;
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_player",PointOffset=(Z=10.0))
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="com_player",PointOffset=(Z=-12.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=85.0
    AltFireOffset=(X=26.0,Y=7.0,Z=1.0)
    bAmbientAltFireSound=true
    FireInterval=3.0
    AltFireInterval=0.12
    FireSoundVolume=512.0
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireSoundScaling=3.0
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=600.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=6.0
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63352
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=64
    InitialSecondaryAmmo=44
    InitialAltAmmo=250
    PrimaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShellHE'
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
    SoundVolume=80
}
