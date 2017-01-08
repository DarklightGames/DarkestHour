//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M7PriestCannon extends DHVehicleCannon;

simulated event Tick(float DeltaTime)
{
    local rotator R;

    super.Tick(DeltaTime);

    R = GetBoneRotation('turret');
    R.Pitch = 0;

    SetBoneRotation('gunsight', R);
}

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_M7Priest_anm.ext_turret'
    Skins(0)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    Skins(1)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest2'
    // CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_turret_75mm_Coll'  // TODO:

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=5.1
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=316.0
    FrontRightAngle=44.0
    RearRightAngle=136.0
    RearLeftAngle=224.0

    bLimitYaw=true
    MaxPositiveYaw=5461             // 30 degrees
    MaxNegativeYaw=-2730            // -15 degrees

    // Turret movement
    ManualRotationsPerSecond=0.02
    CustomPitchUpLimit=6371         // 35 degrees
    CustomPitchDownLimit=64625      // -5 degrees

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellHE'
    PrimaryProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellSmoke'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=45
    InitialSecondaryAmmo=40
    InitialTertiaryAmmo=5
    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Weapon fire
    WeaponFireOffset=18.0
    AddedPitch=68

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'

    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')

    ShootLoweredAnim="fire_close"
    ShootRaisedAnim="fire_open"

    BeginningIdleAnim="com_close_idle"
}
