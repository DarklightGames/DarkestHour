//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WKAntiTank extends DH_Kriegsmarine;

defaultproperties
{
    MyName="Anti-tank soldier"
    AltName="PaK-Soldat"
    Article="an "
    PluralName="Anti-tank soldiers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
    Limit=2
}
