//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1GrenadeWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_M1Grenade_1st.ukx

defaultproperties
{
    ItemName="Mk II Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_M1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_M1GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_M1GrenadePickup'
    InventoryGroup=2

    Mesh=SkeletalMesh'DH_M1Grenade_1st.M1_Grenade'
    Skins(2)=texture'DH_Weapon_tex.AlliedSmallArms.M1Grenade' // TODO: there is no specularity mask for this weapon

    DisplayFOV=90.0
    PlayerViewOffset=(X=15.0,Y=15.0,Z=15.0)

    FuzeLength=4.0
    bHasReleaseLever=true
    LeverReleaseSound=sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
}
