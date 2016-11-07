//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatFireteamLeader extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Fireteam Leader"
    AltName="SS Rottenführer"
    Article="a "
    PluralName="SS Fireteam Leaders"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(3)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon')
    Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetNoCover'
    Limit=2
}
