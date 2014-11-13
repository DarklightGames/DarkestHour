//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_VehMG42Overlay extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\DH_Mg42_1st.ukx

defaultproperties
{
     Mesh=SkeletalMesh'DH_Mg42_1st.VMG42_Mesh'
     Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}
