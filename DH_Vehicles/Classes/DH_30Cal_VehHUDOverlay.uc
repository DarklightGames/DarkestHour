//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_30Cal_VehHUDOverlay extends VehicleHUDOverlay;

defaultproperties
{
    Mesh=SkeletalMesh'DH_30Cal_1st.30Cal_S'
    Skins(0)=Texture'Weapons1st_tex.Arms.hands'
    Skins(1)=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.30calMain'
    Skins(3)=Shader'DH_Weapon_tex.Spec_Maps.30calGrip_s' // TODO: grip specularity shader isn't used in the anim mesh & should be added there
    Skins(4)=Texture'DH_Weapon_tex.AmmoPouches.30CalAmmoTin'
    Skins(5)=Texture'DH_VehiclesUS_tex.ext_vehicles.Green'
    HighDetailOverlay=Shader'DH_Weapon_tex.Spec_Maps.30calMain_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
