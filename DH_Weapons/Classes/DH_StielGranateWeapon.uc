//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StielGranateWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="StG 24 Grenade"
    NativeItemName="Stielhandgranate 24"
    FireModeClass(0)=class'DH_Weapons.DH_StielGranateFire'
    FireModeClass(1)=class'DH_Weapons.DH_StielGranateTossFire'
    AttachmentClass=class'DH_Weapons.DH_StielGranateAttachment'
    PickupClass=class'DH_Weapons.DH_StielGranatePickup'

    DisplayFOV=80.0
    Mesh=SkeletalMesh'DH_Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    FuzeBurningSound=Sound'DH_WeaponSounds.Stielhandgranate.stieldhandgranate_fuze_burn'

    GroupOffset=3
}
