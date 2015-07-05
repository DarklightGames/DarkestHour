//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Kz8cmGrW42VehicleWeapon extends DHMortarVehicleWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    MuzzleBoneName="Muzzle"
    ElevationMaximum=88.0
    FireSound=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
    SpreadYawMin=728.0
    SpreadYawMax=364.0
    YawBone="Vehicle_attachment01"
    GunnerAttachmentBone="com_player"
    RotationsPerSecond=0.007813
    ProjectileClass=class'DH_Mortars.DH_Kz8cmGrW42ProjectileHE'
    MaxPositiveYaw=1820
    MaxNegativeYaw=-1820
    bLimitYaw=true
    InitialPrimaryAmmo=16
    InitialSecondaryAmmo=4
    PrimaryProjectileClass=class'DH_Mortars.DH_Kz8cmGrW42ProjectileHE'
    SecondaryProjectileClass=class'DH_Mortars.DH_Kz8cmGrW42ProjectileSmoke'
    Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed'
}

