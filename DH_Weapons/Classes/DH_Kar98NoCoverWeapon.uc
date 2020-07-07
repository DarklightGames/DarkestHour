//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_Kar98NoCoverWeapon extends DH_Kar98Weapon;

defaultproperties
{

    FireModeClass(0)=class'DH_Weapons.DH_Kar98NoCoverFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98NoCoverMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Kar98NoCoverAttachment'
    PickupClass=class'DH_Weapons.DH_Kar98NoCoverPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k_mesh_nocover'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.k98_sniper_s'

}
