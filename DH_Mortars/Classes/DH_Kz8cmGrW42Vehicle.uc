//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kz8cmGrW42Vehicle extends DH_MortarVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
     PlayerResupplyAmounts(0)=4
     PlayerResupplyAmounts(1)=1
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Mortars.DH_Kz8cmGrW42VehicleWeaponPawn',WeaponBone="Vehicle_attachment01")
     VehicleNameString="Kurz 8cm Granatwerfer 42"
     Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_vehicle'
}
