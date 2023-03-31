//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTankA_M4A176W extends DH_ShermanTank; // later 76mm version with HVAP instead of smoke rounds (but still without muzzle brake or sandbags)

defaultproperties
{
    VehicleNameString="M4A1(76) Sherman"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnA_76mm')
    RearArmor(1)=(Slope=20.0)
    AmmoIgnitionProbability=0.35 // wet stowage means reduced chance of a hit on an ammo storage location detonating the ammo
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.ShermanM4A1W.ShermanM4A1W_DestA'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.Sherman76_Body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a1_76_a'
}
