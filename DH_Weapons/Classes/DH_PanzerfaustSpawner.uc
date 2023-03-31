//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerfaustSpawner extends DHInventorySpawner;

defaultproperties
{
    Mesh=Mesh'DH_Construction_anm.GER_panzerfaust_box'
    Skins(0)=Material'DH_Construction_tex.Ammo.GER_panzerfaust_box'
    WeaponClass=class'DH_Weapons.DH_PanzerFaustWeapon'
    PickupBoneNames(0)="panzerfaust.001"
    PickupBoneNames(1)="panzerfaust.002"
    PickupBoneNames(2)="panzerfaust.003"
    PickupBoneNames(3)="panzerfaust.004"
    PickupCount=2
    PickupsMax=2
}

