//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINTank extends DH_PanzerIIILTank;

defaultproperties
{
    VehicleNameString="Panzer III Ausf.N"
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed2'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panzer3n_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panzer3_n'

	AmmoIgnitionProbability=0.75  // 0.75 default; 75mm ammo instead of 50mm

    VehHitpoints(0)=(PointRadius=30.0,PointHeight=32.0,PointOffset=(X=-70.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-30.0,Y=25.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    NewVehHitpoints(0)=(PointRadius=1.50,PointBone="turret",PointOffset=(X=59.00,Y=-17.00,Z=-1.00),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=15.0,PointBone="turret",PointOffset=(X=0.00,Y=0.00,Z=-20.00),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=10.0,PointBone="turret",PointOffset=(X=53.00,Y=-2.00,Z=0.00),NewHitPointType=NHP_GunPitch)
}
