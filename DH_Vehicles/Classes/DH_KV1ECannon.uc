//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_KV1ECannon extends DH_T3476Cannon; // different turret but shares much in common with T34/76 cannon class

// Modified to lower turret mesh a bit since a small amount of daylight could be seen under/through the lower edge
simulated function InitializeVehicleBase()
{
    WeaponAttachOffset = vect(0.0, -3.0, -6.5);

    super.InitializeVehicleBase();
}

defaultproperties
{
    // Turret mesh
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=-1
    HighDetailOverlay=none

    Mesh=SkeletalMesh'DH_KV_1and2_anm.KV1b_turret_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_ext'
    Skins(1)=Texture'DH_VehiclesSOV_tex.int_vehicles.KV1_turret_int'

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.KV1S.KV1b_turret_coll')


    // Turret armor
    FrontArmorFactor=9.3 //just like with other KVs, turret's front armor is complex and cant be modelled properly. Here it is spherical 90mm armor and areas with flat 75mm armor with added 30mm shields
    LeftArmorFactor=10.5
    RightArmorFactor=10.5  //sides are covered in 30mm shields
    RearArmorFactor=7.5
    LeftArmorSlope=15.0
    FrontArmorSlope=20.0
    RightArmorSlope=15.0
    RearArmorSlope=15.0
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=138.0
    RearLeftAngle=222.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0778 // 28 degrees per sec
    CustomPitchUpLimit=5097 // +28/-7 degrees
    CustomPitchDownLimit=64261

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

    // Weapon fire
    WeaponFireOffset=69.6
    AltFireOffset=(X=-86.0,Y=11.5,Z=5.5)
}
