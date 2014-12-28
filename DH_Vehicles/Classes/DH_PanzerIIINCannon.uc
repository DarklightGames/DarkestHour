//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIINCannon extends DH_ROTankCannon;

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

    if (!bAltFire)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bGunFireDebug)
    {
        Log("After pitch corrections FireRot =" @ FireRot);
        Log("GetPitchForRange for" @ CurrentRangeIndex @ "=" @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
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
    CSpread=550
    ProjPerFire=30
    bLastShot=true
    InitialTertiaryAmmo=14
    TertiaryProjectileClass=class'DH_Vehicles.DH_TankCannonShellCanisterGerman'
    SecondarySpread=0.003900
    ManualRotationsPerSecond=0.040000
    PoweredRotationsPerSecond=0.040000
    FrontArmorFactor=5.700000
    RightArmorFactor=3.000000
    LeftArmorFactor=3.000000
    RearArmorFactor=3.000000
    FrontArmorSlope=15.000000
    RightArmorSlope=25.000000
    LeftArmorSlope=25.000000
    RearArmorSlope=12.000000
    FrontLeftAngle=322.000000
    FrontRightAngle=38.000000
    RearRightAngle=142.000000
    RearLeftAngle=218.000000
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire03'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="Canister"
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=5
//  DummyTracerClass=class'DH_Vehicles.DH_MG34VehicleClientTracer' // deprecated
    AltTracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    AltFireTracerFrequency=7
//  mTracerInterval=0.495867 // deprecated
    bUsesTracers=true
    bAltFireTracersOnly=true
//  MaxDriverHitAngle=2.8 // Matt: deprecated (was used in BelowDriverAngle function, now deprecated, & variable replaced by MinCommanderHitHeight used in re-worked HitDriverArea)
    MinCommanderHitHeight=34.5
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-5.000000,Z=17.000000))
    VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=-5.000000,Z=-5.000000))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=110.000000
    AltFireOffset=(X=12.000000,Y=18.000000,Z=4.000000)
    RotationsPerSecond=0.040000
    bAmbientAltFireSound=true
    Spread=0.001350
    FireInterval=4.000000
    AltFireInterval=0.070580
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AltFireSoundScaling=3.000000
    RotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(Z=50.000000)
    ShakeRotRate=(Z=1000.000000)
    ShakeRotTime=4.000000
    ShakeOffsetMag=(Z=1.000000)
    ShakeOffsetRate=(Z=100.000000)
    ShakeOffsetTime=10.000000
    AltShakeRotMag=(X=1.000000,Y=1.000000,Z=1.000000)
    AltShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    AltShakeRotTime=2.000000
    AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeOffsetTime=2.000000
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64080
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=10
    InitialAltAmmo=150
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHEAT'
    Mesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(2)=texture'axis_vehicles_tex.int_vehicles.panzer3_int'
    SoundVolume=130
    SoundRadius=200.000000
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
