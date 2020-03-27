//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IncendiaryBottleNo1Spawner extends DHInventorySpawner;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_IncendiaryBottleNo1Weapon'
    PickupCount=7
    PickupsMax=7

    Mesh=Mesh'DH_Construction_anm.RUS_grenade_box'
    Skins(0)=Material'DH_Construction_tex.Ammo.RUS_grenade_box'
    PickupBoneNames(0)="grenade.001"
    PickupBoneNames(1)="grenade.002"
    PickupBoneNames(2)="grenade.003"
    PickupBoneNames(3)="grenade.004"
    PickupBoneNames(4)="grenade.005"
    PickupBoneNames(5)="grenade.006"
    PickupBoneNames(6)="grenade.007"
}
