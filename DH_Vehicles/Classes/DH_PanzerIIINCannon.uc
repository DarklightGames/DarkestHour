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

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bGunFireDebug && RangeSettings.Length > 0)
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
    SecondarySpread=0.0039
    ManualRotationsPerSecond=0.04
    FrontArmorFactor=5.7
    RightArmorFactor=3.0
    LeftArmorFactor=3.0
    RearArmorFactor=3.0
    FrontArmorSlope=15.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=12.0
    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0
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
    AltTracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    AltFireTracerFrequency=7
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=34.5
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_player",PointOffset=(X=-5.0,Z=17.0))
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="com_player",PointOffset=(X=-5.0,Z=-5.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=110.0
    AltFireOffset=(X=12.0,Y=18.0,Z=4.0)
    bAmbientAltFireSound=true
    Spread=0.00135
    FireInterval=4.0
    AltFireInterval=0.07058
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.0
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AltFireSoundScaling=3.0
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=1.0,Y=1.0,Z=1.0)
    AltShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
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
    SoundRadius=200.0
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
