//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_VehHUDOverlay_DTmg extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\Allies_Dt_1st.ukx

defaultproperties
{
    Mesh=SkeletalMesh'Allies_Dt_1st.dt'
    Skins(0)=texture'Weapons1st_tex.Arms.hands'
    Skins(1)=texture'Weapons1st_tex.Arms.russian_sleeves'
    Skins(2)=texture'Weapons1st_tex.MG.dtmg'
    Skins(3)=texture'Weapons1st_tex.MG.dtmg_lense'
    HighDetailOverlay=shader'Weapons1st_tex.MG.dtmg_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
