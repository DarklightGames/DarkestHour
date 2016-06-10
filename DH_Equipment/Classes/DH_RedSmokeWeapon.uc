//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RedSmokeWeapon extends DHExplosiveWeapon;

function bool CanDeadThrow()
{
    return false;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(3, false);
    }
}

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DH_RedSmokeFire'
    FireModeClass(1)=class'DH_Equipment.DH_RedSmokeTossFire'
    PickupClass=class'DH_Equipment.DH_RedSmokePickup'
    AttachmentClass=class'DH_Equipment.DH_RedSmokeAttachment'
    ItemName="M16 Red Smoke Grenade"
    Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.RedSmokeGrenade'
    InventoryGroup=8
}
