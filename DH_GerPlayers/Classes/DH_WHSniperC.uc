//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHSniperC extends DH_HeerCamo;

defaultproperties
{
    MyName="Sniper"
    AltName="Scharfschütze"
    Article="a "
    PluralName="Snipers"
    Models(0)="WH_C7"
    Models(1)="WH_C8"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_Sniper
    Limit=2
}
