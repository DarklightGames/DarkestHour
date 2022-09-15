//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_AT57Cannon extends DHATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret'
    Skins(0)=Texture'DH_Artillery_Tex.6pounder.6pounder'
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides 6 pounder's muzzle brake
    Skins(2)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.6pounder.6pounder_turret_coll')
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=6000
    MaxNegativeYaw=-6000
    YawStartConstraint=-7000.0
    YawEndConstraint=7000.0
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64626

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_AT57CannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_AT57CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_AT57CannonShellHE'

    nProjectileDescriptions(0)="M86 APC"
    nProjectileDescriptions(1)="M303 HE-T"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=8
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=15
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0
    AddedPitch=-15

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //3.5 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    ResupplyInterval=3.0
}
