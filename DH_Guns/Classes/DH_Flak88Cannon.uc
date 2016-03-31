//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak88Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_turret'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.flak_88'
    Skins(1)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'
//  CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Flak8.Flak88_turret_coll' // TODO - make 'turret' col mesh - although this one is tricky as so much 'turret' pitches up & down

    // Turret movement
    bHasTurret=true // Matt: not really a turret, but this is an easy way of making the player's view turn with the rotating gun
    bLimitYaw=false
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_Flak88CannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_Flak88CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Flak88CannonShellHE'
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=42
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=9.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
//  SoundRadius=300.0 // TODO: maybe change to 300 as this uses default 200, but is a powerful gun & this does not match tiger's 300

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
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000

    // Miscellaneous
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
}
