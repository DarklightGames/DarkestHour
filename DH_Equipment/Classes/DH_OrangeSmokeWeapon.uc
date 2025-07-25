//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OrangeSmokeWeapon extends DHExplosiveWeapon;

// Modified to add a hint about this coloured grenade
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(3, false);
    }
}

function bool CanDeadThrow()
{
    return false;
}

defaultproperties
{
    ItemName="RauchSichtzeichen Orange 160 Signal Grenade"
    NativeItemName="RauchSichtzeichen Orange 160"
    FireModeClass(0)=Class'DH_OrangeSmokeFire'
    FireModeClass(1)=Class'DH_OrangeSmokeTossFire'
    AttachmentClass=Class'DH_OrangeSmokeAttachment'
    PickupClass=Class'DH_OrangeSmokePickup'
    Mesh=SkeletalMesh'DH_GermanSmokeGrenade_1st.OrangeSmokeGrenade'

    InventoryGroup=4
    GroupOffset=4
    Priority=1
}
