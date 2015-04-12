//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M2MortarVehicleWeapon extends DHMortarVehicleWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    MuzzleBoneName="Muzzle"
    ElevationMaximum=85.0
    ElevationMinimum=40.0
    FireSound=SoundGroup'DH_WeaponSounds.Mortars.6cmFireSG'
    SpreadYawMin=728.0
    SpreadYawMax=364.0
    YawBone="Vehicle_attachment01"
    GunnerAttachmentBone="com_player"
    RotationsPerSecond=0.015625
    ProjectileClass=class'DH_Mortars.DH_M2MortarProjectileHE'
    MaxPositiveYaw=1274
    MaxNegativeYaw=-1274
    bLimitYaw=true
    InitialPrimaryAmmo=24
    InitialSecondaryAmmo=4
    PrimaryProjectileClass=class'DH_Mortars.DH_M2MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Mortars.DH_M2MortarProjectileSmoke'
    Mesh=SkeletalMesh'DH_Mortars_3rd.M2_Mortar_turret'
}
