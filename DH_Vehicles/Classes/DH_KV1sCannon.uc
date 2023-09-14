//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1sCannon extends DH_T3476Cannon; // different turret but shares much in common with T34/76 cannon class

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_KV_anm.KV1S_turret_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.KV1_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.kv1_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.kv1_int_s'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.KV1S.KV1S_turret_collision')

    // Turret armor
    FrontArmorFactor=8.2
    LeftArmorFactor=7.5
    RightArmorFactor=7.5
    RearArmorFactor=7.5
    FrontArmorSlope=5.0  // to do: spherical shape that has different slope depending on elevation
    LeftArmorSlope=15.0
    RightArmorSlope=15.0
    RearArmorSlope=15.0
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=138.0
    RearLeftAngle=222.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0778 // 28 degrees per sec
    CustomPitchUpLimit=5097 // +28/-5 degrees
    CustomPitchDownLimit=64626

    //Sounds
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04')

    AltReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.DP27.dp27_reloadempty01_000',Duration=1.0)
    AltReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.DP27.dp27_reloadempty02_052',Duration=2.0,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.DP27.dp27_reloadempty03_098',Duration=2.0)
    AltReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.DP27.dp27_reloadempty04_158',Duration=0.5,HUDProportion=0.35)

    // Cannon ammo
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=30
    MaxPrimaryAmmo=54
    MaxSecondaryAmmo=60

    PrimaryProjectileClass=class'DH_Vehicles.DH_T3476CannonShellSolid'
    nProjectileDescriptions(0)="BR-350BSP" // 1942 solid shell, after A and before the "proper" B

    // Weapon fire
    WeaponFireOffset=69.6
    AltFireOffset=(X=-54.5,Y=12.0,Z=-0.5)
}
