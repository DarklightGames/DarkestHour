//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak36Cannon extends DHATGunCannon;

var bool bIsHEATLoaded;

replication
{
    reliable if (Role == ROLE_Authority)
        bIsHEATLoaded;
}

simulated function SetAttachmentsHidden(bool bNewHidden)
{
    local int i;

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        if (VehicleAttachments[i].Actor != none)
        {
            VehicleAttachments[i].Actor.bHidden = bNewHidden;
        }
    }
}

function OnReloadFinished(int AmmoIndex)
{
    if (AmmoIndex == 2)
    {
        bIsHEATLoaded = true;
    }
    
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetAttachmentsHidden(!bIsHEATLoaded);
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    SetAttachmentsHidden(!bIsHEATLoaded);
}

simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    super.FlashMuzzleFlash(bWasAltFire);
    
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetAttachmentsHidden(true);
    }
}

defaultproperties
{
    VehicleAttachments(0)=(AttachBone="MUZZLE",StaticMesh=StaticMesh'DH_Pak36_stc.STIELGRANATE_41')

    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak36_anm.pak36_turret_ext'
    //Skins(0)=Texture'DH_Pak36_tex.pak38_ext_yellow'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.pak36_turret_yaw_collision',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.pak36_turret_pitch_collision',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.pak36_turret_barrel_collision',AttachBone="BARREL")
    GunnerAttachmentBone="GUN_YAW"
    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    BeginningIdleAnim="idle"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=128.0,RotationAxis=AXIS_X)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=128.0,RotationAxis=AXIS_X)

    AnimationDrivers(0)=(Channel=1,BoneName="PITCH_DRIVER_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=30,RotationType=ROTATION_Pitch)

    DriverAnimationChannel=2
    DriverAnimationChannelBone="CAMERA_COM"

    // Turret movement
    MaxPositiveYaw=5460 // 30 degrees
    MaxNegativeYaw=-5460
    YawStartConstraint=-5460
    YawEndConstraint=5460
    CustomPitchUpLimit=4550     // +25 degrees
    CustomPitchDownLimit=64626  // -5 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Pak36CannonShell'
    SecondaryProjectileClass=class'DH_Pak36CannonShellAPCR'
    TertiaryProjectileClass=class'DH_Pak36CannonShellHEAT'

    ProjectileDescriptions(0)="AP-HE-T"
    ProjectileDescriptions(1)="APCR-T"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="PzGr.36"
    nProjectileDescriptions(1)="PzGr.40"
    nProjectileDescriptions(2)="StGr.41"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=2

    MaxPrimaryAmmo=40
    MaxSecondaryAmmo=8
    MaxTertiaryAmmo=4

    SecondarySpread=0.00165
    TertiarySpread=0.0130

    // Weapon fire
    WeaponFireAttachmentBone="MUZZLE"
    WeaponFireOffset=1.0

    //Anims
    ShootLoweredAnim="shoot"
    ShootRaisedAnim="shoot"

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3 seconds reload for a lower caliber AT gun
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    // Cannon range settings
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

    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
}
