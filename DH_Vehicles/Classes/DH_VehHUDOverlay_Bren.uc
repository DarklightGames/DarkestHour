//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_VehHUDOverlay_Bren extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\DH_Bren_1st.ukx

defaultproperties
{
    Mesh=SkeletalMesh'DH_Bren_1st.BrenV'
    Skins(0)=texture'Weapons1st_tex.Arms.hands'
    Skins(1)=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    Skins(2)=texture'DH_Weapon_tex.AlliedSmallArms.BrenGun'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.BrenGun_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
