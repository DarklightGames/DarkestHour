//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMAssaultRoles extends DHRomRoles
    abstract;

defaultproperties
{
    MyName="Assault"
    AltName="aaa"
    bSpawnWithExtraAmmo=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Mab38Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch') //to do: MP28
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_Mab38weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MP41Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')

    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
