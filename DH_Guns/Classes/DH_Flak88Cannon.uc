//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flak88Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_turret'
    Skins(0)=Texture'MilitaryAxisSMT.Artillery.flak_88'
    Skins(1)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'
//  CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Flak88.Flak88_turret_coll' // TODO - make 'turret' col mesh - although this one is tricky as so much 'turret' pitches up & down

    // Turret movement
    bHasTurret=true // not really a turret, but this is an easy way of making the player's view turn with the rotating gun
    bLimitYaw=false
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64500

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_Flak88CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Flak88CannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Schw.Sprgr.Patr."

    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=5
    MaxPrimaryAmmo=15
    MaxSecondaryAmmo=10
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=9.0
    ShootLoweredAnim="shoot_open" // as this model doesn't have the usual 'shoot_close' animation, but using 'shoot_close' has the same effect

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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

    ResupplyInterval=12.0
}
