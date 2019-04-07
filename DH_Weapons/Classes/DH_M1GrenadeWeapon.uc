//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M1GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="Mk II Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_M1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_M1GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_M1GrenadePickup'

    Mesh=SkeletalMesh'DH_M1Grenade_1st.M1_Grenade'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Grenade' // TODO: there is no specularity mask for this weapon

    DisplayFOV=90.0
    PlayerViewOffset=(X=15.0,Y=15.0,Z=15.0)

    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0

    GroupOffset=1
}
