//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_LeIG18Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret'
    Skins(0)=texture'DH_LeIG18_tex.LeIG18.IG18_1'
    Skins(1)=texture'DH_LeIG18_tex.LeIG18.IG18_2'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.6pounder.6pounder_turret_coll'  // TODO: REPLACE
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=1092.0
    MaxNegativeYaw=-1092.0
    YawStartConstraint=-1092.0
    YawEndConstraint=1092.0
    CustomPitchUpLimit=13289
    CustomPitchDownLimit=63715

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    PrimaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_AT57CannonShellHE'  // TODO: REPLACE
    InitialPrimaryAmmo=60  // TODO: REPLACE
    InitialSecondaryAmmo=25  // TODO: REPLACE
    SecondarySpread=0.00125  // TODO: REPLACE

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=-15  // TODO: REPLACE

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'  // TODO: REPLACE
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'  // TODO: REPLACE
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'  // TODO: REPLACE
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')  // TODO: REPLACE
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')  // TODO: REPLACE
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')  // TODO: REPLACE
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')  // TODO: REPLACE
}
