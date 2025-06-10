//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarVehicle extends DHMortarVehicle;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M2MortarVehicleWeaponPawn',WeaponBone="Mortar_Attachment")
    VehicleNameString="60mm Mortar M2"
    VehicleTeam=1
    VehicleHudImage=Texture'DH_Mortars_tex.HUD.m2'
}
