//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RG42GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="RG42 Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_F1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_F1GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_F1GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_F1GrenadePickup'

    Mesh=SkeletalMesh'DH_RG42_1st.RG42'
//    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.f1grenade_s'
//    bUseHighDetailOverlayIndex=true
//    HighDetailOverlayIndex=2

    HandNum=1
    SleeveNum=0

    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0

    GroupOffset=0
}

