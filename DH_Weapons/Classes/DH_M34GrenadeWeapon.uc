//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M34GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="M-34 Impact Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_M34GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_M34GrenadeFire' // no toss fire because it would be utterly useless
    AttachmentClass=class'DH_Weapons.DH_M34GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_M34GrenadePickup'
    Mesh=SkeletalMesh'DH_M34Grenade_1st.M34'
    Skins(0)=Texture'DH_m34grenade_tex.m34.m34' // TODO: there is no specularity mask for this weapon
    handnum=1
    sleevenum=2
    GroupOffset=4
    DisplayFOV=80.0
}
