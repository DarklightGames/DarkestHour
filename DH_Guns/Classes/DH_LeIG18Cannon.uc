//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_LeIG18Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret'
    Skins(0)=Texture'DH_LeIG18_tex.LeIG18.IG18_1'
    Skins(1)=Texture'DH_LeIG18_tex.LeIG18.IG18_2'
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=1092.0
    MaxNegativeYaw=-1092.0
    YawStartConstraint=-1092.0
    YawEndConstraint=1092.0
    CustomPitchUpLimit=13289
    CustomPitchDownLimit=63715

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="Igr.38 Sprgr"
    nProjectileDescriptions(1)="Igr.38 HL/A"

    ProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    PrimaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'
    InitialPrimaryAmmo=60  // TODO: REPLACE
    InitialSecondaryAmmo=25  // TODO: REPLACE
    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=25
    Spread=0.005
    SecondarySpread=0.00125  // TODO: REPLACE

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=-15  // TODO: REPLACE

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'  // TODO: REPLACE
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'  // TODO: REPLACE
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'  // TODO: REPLACE
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')  // TODO: REPLACE
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')  // TODO: REPLACE
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')  // TODO: REPLACE
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')  // TODO: REPLACE

    bIsArtillery=true

    RangeTable(0)=(Mils=50,Range=100)
    RangeTable(1)=(Mils=85,Range=150)
    RangeTable(2)=(Mils=115,Range=200)
    RangeTable(3)=(Mils=150,Range=250)
    RangeTable(4)=(Mils=180,Range=300)
    RangeTable(5)=(Mils=210,Range=350)
    RangeTable(6)=(Mils=245,Range=400)
    RangeTable(7)=(Mils=280,Range=450)
    RangeTable(8)=(Mils=320,Range=500)
    RangeTable(9)=(Mils=355,Range=550)
    RangeTable(10)=(Mils=400,Range=600)
    RangeTable(11)=(Mils=450,Range=650)
    RangeTable(12)=(Mils=500,Range=700)
    RangeTable(13)=(Mils=570,Range=750)
    RangeTable(14)=(Mils=665,Range=800)
    RangeTable(15)=(Mils=775,Range=820)
    RangeTable(16)=(Mils=890,Range=800)
    RangeTable(17)=(Mils=990,Range=750)
    RangeTable(18)=(Mils=1055,Range=700)
    RangeTable(19)=(Mils=1110,Range=650)
    RangeTable(20)=(Mils=1160,Range=600)
    RangeTable(21)=(Mils=1200,Range=550)
    RangeTable(22)=(Mils=1240,Range=500)
    RangeTable(23)=(Mils=1280,Range=450)
}
