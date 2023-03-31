//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USSmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="M8 Smoke Grenade"
    FireModeClass(0)=class'DH_Equipment.DH_USSmokeGrenadeFire'
    FireModeClass(1)=class'DH_Equipment.DH_USSmokeGrenadeTossFire'
    PickupClass=class'DH_Equipment.DH_USSmokeGrenadePickup'
    AttachmentClass=class'DH_Equipment.DH_USSmokeGrenadeAttachment'
    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'

    HandNum=0
    SleeveNum=2

    InventoryGroup=4
    GroupOffset=2
    Priority=2

    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0
}

