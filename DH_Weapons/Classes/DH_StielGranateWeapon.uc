//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StielGranateWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Granate_1st.ukx

defaultproperties
{
    FireModeClass(0)=class'DH_Weapons.DH_StielGranateFire'
    FireModeClass(1)=class'DH_Weapons.DH_StielGranateTossFire'
    PickupClass=class'DH_Weapons.DH_StielGranatePickup'
    AttachmentClass=class'DH_Weapons.DH_StielGranateAttachment'
    ItemName="Stielhandgranate 39/43"
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    InventoryGroup=2
    Skins(2)=texture'Weapons1st_tex.Grenades.StielGranate'
}
