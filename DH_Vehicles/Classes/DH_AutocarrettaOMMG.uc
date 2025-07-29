//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AutocarrettaOMMG extends DHVehicleMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_AutocarrettaOM_anm.OM33_TURRET_EXT'
    YawBone=GUN_YAW
    PitchBone=GUN_PITCH
    GunnerAttachmentBone=GUN_PITCH

    bLimitYaw=false
    CustomPitchUpLimit=10010    // +55 degrees
    CustomPitchDownLimit=64808  // -4 degrees

    // Ammo
    ProjectileClass=Class'DH_MG34Bullet' // replace: fiat 35 bullet & properties
    InitialPrimaryAmmo=150
    NumMGMags=5
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=Class'DH_Breda30TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    WeaponFireAttachmentBone=MUZZLE
    WeaponFireOffset=0
}
