//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StielGranateWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Granate_1st.ukx

defaultproperties
{
    ItemName="Stielhandgranate 39/43"
    FireModeClass(0)=class'DH_Weapons.DH_StielGranateFire'
    FireModeClass(1)=class'DH_Weapons.DH_StielGranateTossFire'
    AttachmentClass=class'DH_Weapons.DH_StielGranateAttachment'
    PickupClass=class'DH_Weapons.DH_StielGranatePickup'
    InventoryGroup=2

    DisplayFOV=80.0
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Grenades.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
