//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    ItemName="RauchSichtzeichen Orange 160"
    FireModeClass(0)=class'DH_Equipment.DH_OrangeSmokeFire'
    FireModeClass(1)=class'DH_Equipment.DH_OrangeSmokeTossFire'
    AttachmentClass=class'DH_Equipment.DH_OrangeSmokeAttachment'
    PickupClass=class'DH_Equipment.DH_OrangeSmokePickup'
    Mesh=SkeletalMesh'DH_GermanSmokeGrenade_1st.OrangeSmokeGrenade'

    InventoryGroup=4
    GroupOffset=3
    Priority=1
}
