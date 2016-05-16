//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
    Mesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_ext'
    ProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Cromwell95mmCannonShellHEAT'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"
    InitialPrimaryAmmo=23
    InitialSecondaryAmmo=23
    InitialTertiaryAmmo=5
    Spread=0.0036
    SecondarySpread=0.0036
    TertiarySpread=0.0036
    WeaponFireOffset=-39.8
    CustomPitchDownLimit=64900 // slightly reduced so bigger barrel & counterweight clear hull fixtures
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01' // same as 105mm howitzers
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01') // as Sherman 105mm
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')
}
