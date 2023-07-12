//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuH42Cannon extends DH_Stug3GCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_turret_ext'

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_StuH42CannonShellHEAT'

    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="Sprgr.Patr."
    nProjectileDescriptions(1)="F.H.Gr.Nb."
    nProjectileDescriptions(2)="Gr.38 Hl/C"

    InitialPrimaryAmmo=18
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=6
    MaxTertiaryAmmo=10
    Spread=0.0015
    SecondarySpread=0.00357
    TertiarySpread=0.00275

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-18.0,Y=23.0,Z=30.0)

    //Sounds
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')

    // Weapon fire & sounds
    WeaponFireOffset=-53.5
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
}
