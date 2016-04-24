//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WKAntiTank extends DH_Kriegsmarine;

defaultproperties
{
    bIsATGunner=true
    MyName="Anti-tank soldier"
    AltName="PaK-Soldat"
    Article="an "
    PluralName="Anti-tank soldiers"
    MenuImage=texture'DHGermanCharactersTex.Icons.Pak-soldat'
    Models(0)="WK_1"
    Models(1)="WK_2"
    Models(2)="WK_3"
    Models(3)="WK_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
    PrimaryWeaponType=WT_SMG
    Limit=2
}
