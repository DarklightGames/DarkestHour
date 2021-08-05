//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M3GunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M3AT_anm.gun'
    Skins(0)=Texture'DH_M3AT_tex.gun.M3_Light_AT_Gun'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.M5.M5_gun_collision' // TODO: replace
    bAttachColMeshToPitchBone=true // because the gun shield also tilts back & forth when the gun is elevated // TODO: but query whether shield should move (pretty sure not)
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=4096 // 22.5 degrees traverse
    MaxNegativeYaw=-4096
    YawStartConstraint=-4500
    YawEndConstraint=4500
    CustomPitchUpLimit=5460 // 30/-5 degrees elevation/depression
    CustomPitchDownLimit=64625

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_M3CannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_M3CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_M3CannonShellHE'

    nProjectileDescriptions(0)="M62 APC" // TODO: replace
    nProjectileDescriptions(1)="M42A1 HE-T" // TODO: replace

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=10
    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=30
    SecondarySpread=0.00135

    // Weapon fire
    WeaponFireOffset=10.0
    AddedPitch=20

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3.9 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')
}
