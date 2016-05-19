//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSAssault_Autumn extends DH_WaffenSSAutumn;

defaultproperties
{
    MyName="Stoßtruppe"
    AltName="Stoßtruppe"
    Article="an "
    PluralName="Stoßtruppen"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Ass'
    Models(0)="SSA_1"
    Models(1)="SSA_2"
    Models(2)="SSA_3"
    Models(3)="SSA_4"
    Models(4)="SSA_5"
    Models(5)="SSA_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=4
}
