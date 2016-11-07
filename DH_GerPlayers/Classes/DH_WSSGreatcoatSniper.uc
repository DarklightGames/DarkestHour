//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatSniper extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Sniper"
    AltName="SS Scharfschütze"
    Article="a "
    PluralName="SS Snipers"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98ScopedWeapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43ScopedWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon')
    Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
    Limit=1
}
