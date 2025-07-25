//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DTmg_VehHUDOverlay extends VehicleHUDOverlay;

defaultproperties
{
    Mesh=SkeletalMesh'Allies_Dt_1st.dt'
    Skins(0)=Texture'Weapons1st_tex.hands'
    Skins(1)=Texture'Weapons1st_tex.russian_sleeves'
    Skins(2)=Texture'Weapons1st_tex.dtmg'
    Skins(3)=Texture'Weapons1st_tex.dtmg_lense'
    HighDetailOverlay=Shader'Weapons1st_tex.dtmg_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
