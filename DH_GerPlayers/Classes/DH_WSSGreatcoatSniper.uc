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
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43ScopedWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
    Limit=1
}
