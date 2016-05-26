//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSAssault extends DH_WaffenSS;

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Stoﬂtruppe"
    Article="an "
    PluralName="Assault Troopers"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Ass'
    Models(0)="SS_1"
    Models(1)="SS_2"
    Models(2)="SS_3"
    Models(3)="SS_4"
    Models(4)="SS_5"
    Models(5)="SS_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=4
}
