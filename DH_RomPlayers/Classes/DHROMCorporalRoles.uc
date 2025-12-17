//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMCorporalRoles extends DHRomRoles
    abstract;

defaultproperties
{ 
    bRequiresSLorASL=true
    MyName="Corporal"
    AltName="aaa"
    Limit=2
    bSpawnWithExtraAmmo=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP41Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB38Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    //to do: mp28
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon')  //add m1912
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8

}
