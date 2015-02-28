//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WSSAssault extends DH_WaffenSS;

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Stoßtruppe"
    Article="an "
    PluralName="Assault Troopers"
    InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Ass'
    Models(0)="SS_1"
    Models(1)="SS_2"
    Models(2)="SS_3"
    Models(3)="SS_4"
    Models(4)="SS_5"
    Models(5)="SS_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=4
}
