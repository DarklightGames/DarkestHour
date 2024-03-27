//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RG42GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="RG-42 Grenade"
    NativeItemName="RG-42 Granata"
    FireModeClass(0)=class'DH_Weapons.DH_RG42GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RG42GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_RG42GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_RG42GrenadePickup'

    Mesh=SkeletalMesh'DH_RG42_1st.RG42_Mesh'

    bUseHighDetailOverlayIndex=false
    
    HandNum=1
    SleeveNum=0

    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0

    GroupOffset=0
}
