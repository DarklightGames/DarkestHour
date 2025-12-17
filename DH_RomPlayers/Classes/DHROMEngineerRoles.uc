//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMEngineerRoles extends DHRomRoles
    abstract;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="aaa"
    Limit=2
    bSpawnWithExtraAmmo=false
    AddedRoleRespawnTime=5
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Vz24Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')

    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon') //replace with candle
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8

}
