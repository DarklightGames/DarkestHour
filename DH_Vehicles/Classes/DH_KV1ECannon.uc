//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_KV1ECannon extends DH_T3476Cannon; // different turret but shares much in common with T34/76 cannon class

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_KV_1and2_anm.KV1b_turret_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_ext'
    Skins(1)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_ext'
    Skins(2)=Texture'DH_VehiclesSOV_tex.int_vehicles.KV1_turret_int'
    Skins(3)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_ext'

    CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.KV1S.KV1b_turret_coll'

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

    // Cannon ammo
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=30
    MaxPrimaryAmmo=54
    MaxSecondaryAmmo=60

    // Weapon fire
    WeaponFireOffset=69.6
    AltFireOffset=(X=-54.5,Y=12.0,Z=-0.5)
}
