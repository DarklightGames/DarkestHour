//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer_mg_ext'
    Skins(0)=texture'Weapons3rd_tex.German.Mg42_world'
    FireAttachBone="Mg_placement1"
    FireEffectOffset=(X=10.0,Y=0.0,Z=5.0)

    // Movement
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4000
    PitchBone="mg_yaw"
    CustomPitchUpLimit=2730
    CustomPitchDownLimit=64000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    NumMags=8
    FireInterval=0.05
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'

    // Weapon fire
    WeaponFireOffset=2.5
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    AmbientSoundScaling=1.3
    AIInfo(0)=(RefireRate=0.05)
}
