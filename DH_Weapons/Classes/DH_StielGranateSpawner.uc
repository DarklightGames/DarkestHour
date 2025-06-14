//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StielGranateSpawner extends DHInventorySpawner;

defaultproperties
{
    Mesh=Mesh'DH_Construction_anm.GER_grenade_box'
    Skins(0)=Material'DH_Construction_tex.GER_grenade_box'
    WeaponClass=Class'DH_StielGranateWeapon'
    PickupBoneNames(0)="grenade.001"
    PickupBoneNames(1)="grenade.002"
    PickupBoneNames(2)="grenade.003"
    PickupBoneNames(3)="grenade.004"
    PickupBoneNames(4)="grenade.005"
    PickupBoneNames(5)="grenade.006"
    PickupBoneNames(6)="grenade.007"
    PickupCount=15
    PickupsMax=15
}

