//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cannone4732Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret'
    Skins(0)=Texture'DH_Cannone4732_tex.cannone4732_body_ext'

    //CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.6pounder.6pounder_turret_coll')
    
    GunnerAttachmentBone="com_player"
    
    ShootAnim="shoot"
    ShootAnimBoneName="barrel"

    // Turret movement
    MaxPositiveYaw=6000
    MaxNegativeYaw=-6000
    YawStartConstraint=-7000.0
    YawEndConstraint=7000.0
    CustomPitchUpLimit=10920    // 60 degrees
    CustomPitchDownLimit=62806  // -15 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_AT57CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_AT57CannonShellHE'

    nProjectileDescriptions(0)="M86 APC"
    nProjectileDescriptions(1)="M303 HE-T"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=8
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=15
    SecondarySpread=0.00125

    // Weapon fire
    AddedPitch=-15

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //3.5 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    ResupplyInterval=3.0

    PitchBone="gun_pitch"
    YawBone="gun_yaw"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="yaw_wheel",Scale=-64.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="pitch_wheel",Scale=64.0,RotationAxis=AXIS_Y)

    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_yaw_collision',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_pitch_collision',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_barrel_collision',AttachBone="BARREL")
}
