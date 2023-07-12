//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MG34_VehHUDOverlay extends VehicleHUDOverlay;

defaultproperties
{
    Mesh=SkeletalMesh'Axis_Mg34_1st.MG_34_Mesh'
    Skins(0)=Texture'Weapons1st_tex.Arms.hands'
    Skins(1)=Texture'Weapons1st_tex.Arms.GermanTankerSleeves'
    Skins(2)=Shader'Weapons1st_tex.MG.mg34_s' // can't specify specularity shader as HighDetailOverlay as includes opacity mask, which doesn't seem to work with HDO system
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides the bipod that shouldn't be there in a vehicle-mounted MG overlay
}
