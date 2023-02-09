//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485Tank_Berlin extends DH_T3485Tank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.T3485_ext_Berlin'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.T3485_ext_Berlin'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.T3485_ext_Berlin_dest'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T3485CannonPawn_Berlin')
}
