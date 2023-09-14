//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_50Cal_VehHUDOverlay extends VehicleHUDOverlay;

// To put the overlay mesh in the correct position, with a full belt of bullets fed into the gun
simulated function PostBeginPlay()
{
    PlayAnim('Idle');
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_50Cal_1st.50Cal_1st'
    Skins(0)=Texture'DHGermanCharactersTex.Heads.Ger_facef' // player's hands look better using this instead of US character skins (close up view of US hands is poor)
    Skins(1)=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.50CalMain'
    Skins(3)=Texture'DH_Weapon_tex.AmmoPouches.50CalAmmoTin'
}
