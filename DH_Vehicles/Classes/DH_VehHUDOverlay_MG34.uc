//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_VehHUDOverlay_MG34 extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg34_1st.ukx

defaultproperties
{
    Mesh=SkeletalMesh'Axis_Mg34_1st.MG_34_Mesh'
    Skins(0)=texture'Weapons1st_tex.Arms.hands'
    Skins(1)=texture'Weapons1st_tex.Arms.GermanTankerSleeves'
    Skins(2)=Shader'Weapons1st_tex.MG.mg34_s'
    Skins(3)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}
