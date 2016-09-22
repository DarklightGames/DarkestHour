//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHSniper_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
    MyName="Sniper"
    AltName="Scharfschütze"
    Article="a "
    PluralName="Snipers"
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43ScopedWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=1
}
