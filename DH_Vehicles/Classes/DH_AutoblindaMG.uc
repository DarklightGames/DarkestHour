//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AutoblindaMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_mg_ext'
    FireAttachBone="mg"
    FireEffectOffset=(X=10,Y=40,Z=0)

    // Movement
    MaxNegativeYaw=29028
    MaxPositiveYaw=36508
    CustomPitchUpLimit=3640
    CustomPitchDownLimit=63767

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_Breda38Bullet'
    InitialPrimaryAmmo=24
    NumMGMags=20
    FireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_Breda38BulletTracer'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=27.0
    FireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    FireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)

    GunnerAttachmentBone="GUNNER_ATTACHMENT"
}
