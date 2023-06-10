//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    ItemName="M16 Signal Grenade"
    FireModeClass(0)=class'DH_Equipment.DH_RedSmokeFire'
    FireModeClass(1)=class'DH_Equipment.DH_RedSmokeTossFire'
    AttachmentClass=class'DH_Equipment.DH_RedSmokeAttachment'
    PickupClass=class'DH_Equipment.DH_RedSmokePickup'

    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'
    Skins(1)=Texture'DH_M8Grenade_tex.m16.M16red'

    HandNum=0
    SleeveNum=2

    InventoryGroup=4
    GroupOffset=3
    Priority=1

    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0
}
