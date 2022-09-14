//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_WirbelwindTank extends DH_PanzerIVGLateTank;

defaultproperties
{
    VehicleNameString="Flakpanzer IV 'Wirbelwind'"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WirbelwindCannonPawn')
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.wirbelwind_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.wirbelwind_turret_look'
    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.Vehicles.wirbelwind'

    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.wirbelwind.Wirbelwind_destro'
    NewVehHitpoints(0)=(PointRadius=2.0,PointBone="turret",PointOffset=(X=0.00,Y=0.00,Z=60.00),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=35.0,PointBone="turret",PointOffset=(X=0.00,Y=0.00,Z=-15.00),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=35.0,PointBone="turret",PointOffset=(X=70.00,Y=0.00,Z=20.00),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
	// Damage
	// compared to pz4: 20mm ammo was unlikely to explode
	AmmoIgnitionProbability=0.2  // 0.75 default
    TurretDetonationThreshold=5000.0 // increased from 1750
}

