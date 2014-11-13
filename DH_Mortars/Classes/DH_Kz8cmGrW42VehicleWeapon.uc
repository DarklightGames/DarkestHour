//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kz8cmGrW42VehicleWeapon extends DH_MortarVehicleWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
     MuzzleBoneName="Muzzle"
     ElevationMaximum=88.000000
     FireSound=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
     SpreadYawMin=728.000000
     SpreadYawMax=364.000000
     YawBone="Vehicle_attachment01"
     GunnerAttachmentBone="com_player"
     RotationsPerSecond=0.007813
     ProjectileClass=Class'DH_Mortars.DH_Kz8cmGrW42ProjectileHE'
     MaxPositiveYaw=1820
     MaxNegativeYaw=-1820
     bLimitYaw=true
     InitialPrimaryAmmo=16
     InitialSecondaryAmmo=4
     PrimaryProjectileClass=Class'DH_Mortars.DH_Kz8cmGrW42ProjectileHE'
     SecondaryProjectileClass=Class'DH_Mortars.DH_Kz8cmGrW42ProjectileSmoke'
     Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_turret'
}

