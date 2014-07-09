class DH_M2MortarVehicleWeapon extends DH_MortarVehicleWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
     MuzzleBoneName="Muzzle"
     ElevationMaximum=85.000000
     ElevationMinimum=40.000000
     FireSound=SoundGroup'DH_WeaponSounds.Mortars.6cmFireSG'
     SpreadYawMin=728.000000
     SpreadYawMax=364.000000
     YawBone="Vehicle_attachment01"
     GunnerAttachmentBone="com_player"
     RotationsPerSecond=0.015625
     ProjectileClass=Class'DH_Mortars.DH_M2MortarProjectileHE'
     MaxPositiveYaw=1274
     MaxNegativeYaw=-1274
     bLimitYaw=True
     InitialPrimaryAmmo=24
     InitialSecondaryAmmo=4
     PrimaryProjectileClass=Class'DH_Mortars.DH_M2MortarProjectileHE'
     SecondaryProjectileClass=Class'DH_Mortars.DH_M2MortarProjectileSmoke'
     Mesh=SkeletalMesh'DH_Mortars_3rd.M2_Mortar_turret'
}
