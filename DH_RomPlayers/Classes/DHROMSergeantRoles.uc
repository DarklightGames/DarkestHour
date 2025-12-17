//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMSergeantRoles extends DHRomRoles
    abstract;

defaultproperties
{
    bIsLeader=true
    bRequiresSLorASL=true
    MyName="Sergeant"
    AltName="aaa"
    Limit=2
    bSpawnWithExtraAmmo=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP41Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB38Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon')  //add m1912
    //to do: mp28
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')  //?

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
