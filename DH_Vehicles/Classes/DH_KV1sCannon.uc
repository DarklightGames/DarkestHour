//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_KV1sCannon extends DH_T3476Cannon; // different turret but shares much in common with T34/76 cannon class

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_KV_anm.KV1S_turret_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.KV1_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.kv1_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.kv1_int_s'
    CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.KV1S.KV1S_turret_collision'

    // Turret armor
    FrontArmorFactor=8.2
    LeftArmorFactor=7.5
    RightArmorFactor=7.5
    RearArmorFactor=7.5
    LeftArmorSlope=15.0
    RightArmorSlope=15.0
    RearArmorSlope=15.0
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=138.0
    RearLeftAngle=222.0

    // Turret movement
    ManualRotationsPerSecond=0.025
    PoweredRotationsPerSecond=0.0778 // 28 degrees per sec
    CustomPitchUpLimit=5097 // +28/-5 degrees
    CustomPitchDownLimit=64626

    // Cannon ammo
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=30
    MaxPrimaryAmmo=54
    MaxSecondaryAmmo=60

    // Weapon fire
    WeaponFireOffset=62.0
    AltFireOffset=(X=-54.0,Y=12.0,Z=-0.5)
}
