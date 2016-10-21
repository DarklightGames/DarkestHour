//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RedSmokeWeapon extends DHExplosiveWeapon;

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
    ItemName="M16 Red Smoke Grenade"
    FireModeClass(0)=class'DH_Equipment.DH_RedSmokeFire'
    FireModeClass(1)=class'DH_Equipment.DH_RedSmokeTossFire'
    AttachmentClass=class'DH_Equipment.DH_RedSmokeAttachment'
    PickupClass=class'DH_Equipment.DH_RedSmokePickup'
    Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.RedSmokeGrenade'
    InventoryGroup=8
}
