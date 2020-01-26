//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName = "Molotov"
    DisplayFOV = 70.0
    bUseHighDetailOverlayIndex = true
    HighDetailOverlayIndex = 2
    GroupOffset = 3

    AttachmentClass = class'DH_Weapons.DH_MolotovAttachment'
    PickupClass = class'DH_Weapons.DH_MolotovPickup'
    FireModeClass(0) = class'DH_Weapons.DH_MolotovFire'
    FireModeClass(1) = class'DH_Weapons.DH_MolotovTossFire'
    
    Mesh = SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay = shader'Weapons1st_tex.Grenades.stiel_s'
}
