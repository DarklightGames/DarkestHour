//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat1435MG extends DHVehicleMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Fiat1435_anm.fiat1435_turret_world'
    YawBone=MG_YAW
    PitchBone=MG_PITCH

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet' // replace: fiat 35 bullet & properties
    InitialPrimaryAmmo=150
    NumMGMags=5
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=class'DH_Weapons.DH_Breda30TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    WeaponFireAttachmentBone=MUZZLE_AC
    WeaponFireOffset=0
}
