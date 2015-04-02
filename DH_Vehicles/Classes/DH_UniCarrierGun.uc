//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_UniCarrierGun extends DHMountedTankMG; // Matt: was UniCarrierGun

defaultproperties
{
    NumMags=20
    HUDOverlayReloadAnim="reload_empty"
    ReloadDuration=7.0
    TracerProjectileClass=class'DH_BrenVehicleTracerBullet'
    TracerFrequency=5
	VehHitpoints(0)=(PointRadius=9.0,PointHeight=0.0,PointScale=1.0,PointBone=com_attachment,PointOffset=(X=6.0,Y=-6.0,Z=22.0))
	VehHitpoints(1)=(PointRadius=15.0,PointHeight=0.0,PointScale=1.0,PointBone=com_attachment,PointOffset=(X=4.0,Y=-5.0,Z=2.0))
    hudAltAmmoIcon=texture'DH_InterfaceArt_tex.weapon_icons.Bren_ammo'
    YawBone="Gun_protection"
    PitchBone="Gun_protection"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="Tip"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=0.0
    RotationsPerSecond=0.5
    bInstantFire=false // override inherited from ROMountedTankMG (all MGs have this)
    Spread=0.002
    FireInterval=0.125
    AltFireInterval=0.125
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleBrenMGEmitter'
    FireSoundClass=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_BrenVehicleBullet'
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=5.0,Y=5.0,Z=5.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=50.0,Y=50.0,Z=50.0)
    AIInfo[0]=(bLeadTarget=true,bFireOnRelease=true,AimError=800.0,RefireRate=0.125)
    CustomPitchUpLimit=3500
    CustomPitchDownLimit=63000
    MaxPositiveYaw=7500
    MaxNegativeYaw=-7000
    bLimitYaw=true
    InitialPrimaryAmmo=30
    Mesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_ext'
    bCollideActors=true
    bCollideWorld=false
    bProjTarget=true
    bBlockActors=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}
