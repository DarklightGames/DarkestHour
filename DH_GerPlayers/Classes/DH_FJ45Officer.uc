//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJ45Officer extends DH_FJ_1945;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillerieoffizier"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillerieoffiziere"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Off'
    Models(0)="FJO451"
    Models(1)="FJO452"
    Models(2)="FJO453"
    Models(3)="FJO454"
    Models(4)="FJO455"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmet2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
