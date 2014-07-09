//-----------------------------------------------------------
//   First Person StuG III MG34 Overlay
//   Skin and coding by Eric "Shurek" Parris (c) 2008
//-----------------------------------------------------------
class DH_Stug3GOverlayMG extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\Axis_Mg34_1st.ukx

defaultproperties
{
     Mesh=SkeletalMesh'Axis_Mg34_1st.MG_34_Mesh'
     Skins(0)=Texture'Weapons1st_tex.Arms.hands'
     Skins(1)=Texture'Weapons1st_tex.Arms.GermanTankerSleeves'
     Skins(2)=Shader'Weapons1st_tex.MG.mg34_s'
     Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}
