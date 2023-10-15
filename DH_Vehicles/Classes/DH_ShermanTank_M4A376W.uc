//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A376W extends DH_ShermanTank_M4A375W; // later 76mm version with HVAP instead of smoke rounds

defaultproperties
{
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_ext_alt'
    VehicleNameString="M4A3(76)W Sherman"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnA_76mm')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_762dest'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3_76w'

    NewVehHitpoints(0)=(PointRadius=2.0,PointBone="turret",PointOffset=(X=65.00,Y=22.00,Z=30.50),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.0,PointBone="turret",PointOffset=(X=0.00,Y=0.00,Z=10.00),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.0,PointBone="turret",PointOffset=(X=35.00,Y=0.00,Z=20.00),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
}

