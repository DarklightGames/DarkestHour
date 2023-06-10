//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DTmg_VehHUDOverlay extends VehicleHUDOverlay;

defaultproperties
{
    Mesh=SkeletalMesh'Allies_Dt_1st.dt'
    Skins(0)=Texture'Weapons1st_tex.Arms.hands'
    Skins(1)=Texture'Weapons1st_tex.Arms.russian_sleeves'
    Skins(2)=Texture'Weapons1st_tex.MG.dtmg'
    Skins(3)=Texture'Weapons1st_tex.MG.dtmg_lense'
    HighDetailOverlay=Shader'Weapons1st_tex.MG.dtmg_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
