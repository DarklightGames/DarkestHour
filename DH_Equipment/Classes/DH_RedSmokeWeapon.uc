//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    FireModeClass(0)=Class'DH_RedSmokeFire'
    FireModeClass(1)=Class'DH_RedSmokeTossFire'
    AttachmentClass=Class'DH_RedSmokeAttachment'
    PickupClass=Class'DH_RedSmokePickup'

    Mesh=SkeletalMesh'DH_M8Grenade_1st.M8'
    Skins(1)=Texture'DH_M8Grenade_tex.M16red'

    HandNum=0
    SleeveNum=2

    InventoryGroup=4
    GroupOffset=3
    Priority=1

    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0

    FuzeLengthRange=(Min=2.0,Max=2.0)
}
