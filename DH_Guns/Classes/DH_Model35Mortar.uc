//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// TODO: maybe make a mortar class that inherits from DHATGun.
class DH_Model35Mortar extends DHATGun;

defaultproperties
{
    VehicleNameString="81/14 Model 35 Mortar"
    Team=0
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_base'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Model35MortarCannonPawn',WeaponBone="TURRET_PLACEMENT")
    bCanBeRotated=true
    bIsArtilleryVehicle=true
    bTeamLocked=false
    CollisionRadius=16.0
    CollisionHeight=8.0
}
