//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M2MortarVehicle extends DH_MortarVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
     PlayerResupplyAmounts(0)=6
     PlayerResupplyAmounts(1)=1
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Mortars.DH_M2MortarVehicleWeaponPawn',WeaponBone="Vehicle_attachment")
     VehicleTeam=1
     VehicleNameString="60mm Mortar M2"
     Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_vehicle'
}
