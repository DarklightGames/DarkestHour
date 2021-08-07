//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_SdKfz251_9DCannon extends DHATGunCannon;

defaultproperties
{
    // Don't have a bone for the Pak40 attachment, so this offsets from the hull's 'body' bone to fit correctly onto the pedestal mount
    // Would be easy to add a weapon attachment bone to the hull mesh, but would then need a modified interior mesh to match
    Mesh=SkeletalMesh'DH_Stummel.stummel_ext'
    // WeaponAttachOffset=(X=-42.76,Y=0.3,Z=37.95)
    Skins(0)=Texture'DH_VehiclesGE_tex8.ext_vehicles.stummel_ext'

    MaxPositiveYaw=2300
    MaxNegativeYaw=-2300
    YawStartConstraint=-2300
    YawEndConstraint=2300
    CustomPitchUpLimit=3400
    CustomPitchDownLimit=65275

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHEAT'
    TertiaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellAP'

    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="AP"

    nProjectileDescriptions(0)="Sprgr.Kw.K."
    nProjectileDescriptions(1)="Gr.38 Hl/C"
    nProjectileDescriptions(2)="PzGr.39/43"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=10

    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=10
    MaxTertiaryAmmo=20

    Spread=0.001
    SecondarySpread=0.001
    TertiarySpread=0.001

        // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

    // Cannon range settings
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
}
