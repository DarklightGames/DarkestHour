//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GreaseGunWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M3 Grease Gun"
    SwayModifyFactor=0.65 // -0.05
    FireModeClass(0)=Class'DH_GreaseGunFire'
    FireModeClass(1)=Class'DH_GreaseGunMeleeFire'
    AttachmentClass=Class'DH_GreaseGunAttachment'
    PickupClass=Class'DH_GreaseGunPickup'

    Mesh=SkeletalMesh'DH_M3GreaseGun_1st.M3GreaseGun'

    DisplayFOV=80.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=55.0
    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9
    PutDownAnim="putaway"
    FirstSelectAnim="draw_first"
}
