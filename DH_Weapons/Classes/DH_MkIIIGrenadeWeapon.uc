//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MkIIIGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="Mk III Grenade"

    FireModeClass(0)=class'DH_Weapons.DH_MkIIIGrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_MkIIIGrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_MkIIIGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_MkIIIGrenadePickup'

    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'
    Skins(1)=Texture'DH_M8Grenade_tex.Mk3.Mk3'

    HandNum=0
    SleeveNum=2

    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0

    GroupOffset=0
}
