//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarVehicle extends DHMortarVehicle;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Weapons.DH_M2MortarVehicleWeaponPawn',WeaponBone="Mortar_Attachment")
    VehicleNameString="60mm Mortar M2"
    VehicleTeam=1
    VehicleHudImage=Texture'DH_Mortars_tex.HUD.m2'
}
