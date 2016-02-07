//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell95mmCannon extends DH_CromwellCannon;

// Modified to override RangeSettings array to give maximum range setting of 1600m
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    RangeSettings.Length = 9;
}

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHEAT'
    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=5
    Spread=0.0 // 0.006 // apparently a very inaccurate weapon
    SecondarySpread=0.0 // 0.006
    TertiarySpread=0.0 // 0.006
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"
    WeaponFireOffset=-37.2
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01' // same as 105mm howitzers
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadSoundOne=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01' // as Sherman 105mm
    ReloadSoundTwo=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02'
    ReloadSoundThree=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03'
    ReloadSoundFour=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04'
    CustomPitchDownLimit=64900 // slightly reduced so bigger barrel & counterweight clear hull fixtures
    Mesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_ext'
}
