//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RDG1SmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    FireModeClass(0)=Class'DH_RDG1SmokeGrenadeFire'
    FireModeClass(1)=Class'DH_RDG1SmokeGrenadeTossFire'
    PickupClass=Class'DH_RDG1SmokeGrenadePickup'
    AttachmentClass=Class'DH_RDG1SmokeGrenadeAttachment'
    ItemName="RDG-1 Smoke Grenade"
    NativeItemName="RDG-1"
    Mesh=SkeletalMesh'Allies_RGD1_1st.RGD1_mesh'
    PutDownAnim="putaway"

    InventoryGroup=4
    GroupOffset=1
    Priority=2
    DisplayFOV=80.0
}
