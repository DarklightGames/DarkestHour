//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTankA_M4A176W extends DH_ShermanTank; // later 76mm version with HVAP instead of smoke rounds (but still without muzzle brake or sandbags)

#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc2.usx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnA_76mm')
    RearArmor(1)=(Slope=20.0)
    AmmoIgnitionProbability=0.5 // wet stowage means reduced chance of a hit on an ammo storage location detonating the ammo
    HullFireChance=0.25         // also reduced chance of tank being set on fire by a penetrating hit
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.ShermanM4A1W.ShermanM4A1W_DestA'
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.Sherman76_Body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.sherman_m4a1_76_a'
}
