//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_AT57Cannon extends DHATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret'
    Skins(0)=texture'DH_Artillery_Tex.6pounder.6pounder'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides 6 pounder's muzzle brake
    Skins(2)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
//  CollisionStaticMesh=StaticMesh'DH_Artillery_stc.6pounder.6pounder_turret_coll' // TODO - make 'turret' col mesh
    BeginningIdleAnim="com_idle_close"
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
    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=25
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0
    AddedPitch=-15

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
