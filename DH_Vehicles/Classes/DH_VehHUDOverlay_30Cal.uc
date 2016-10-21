//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_VehHUDOverlay_30Cal extends VehicleHUDOverlay;

#exec OBJ LOAD FILE=..\Animations\DH_30cal_1st.ukx

defaultproperties
{
    Mesh=SkeletalMesh'DH_30Cal_1st.30Cal_S'
    Skins(0)=texture'Weapons1st_tex.Arms.hands'
    Skins(1)=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Skins(2)=texture'DH_Weapon_tex.AlliedSmallArms.30calMain'
    Skins(3)=shader'DH_Weapon_tex.Spec_Maps.30calGrip_s' // TODO: grip specularity shader isn't used in the anim mesh & should be added there
    Skins(4)=texture'DH_Weapon_tex.AmmoPouches.30CalAmmoTin'
    Skins(5)=texture'DH_VehiclesUS_tex.ext_vehicles.Green'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.30calMain_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
