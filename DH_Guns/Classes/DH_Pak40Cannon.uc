//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Pak40Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.RO_BC_pak40'
    Skins(1)=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    Skins(2)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'
//  CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_turret_coll' // TODO - make 'turret' col mesh
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=5825
    MaxNegativeYaw=-5825
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=4005
    CustomPitchDownLimit=64623

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellHE'
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=42
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=1.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'

    // Cannon range settings
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000

    // Miscellaneous
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
}
