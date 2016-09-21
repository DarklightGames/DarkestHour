//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatPanzerGrenadier extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="Anti-tank soldier"
    AltName="PaK-Soldat"
    Article="an "
    PluralName="Anti-tank soldiers"
    InfoText="PaK-Soldat - Difficulty: Advanced||Mid war the German army introduced a powerful new anti-tank weapon. The Panzerfaust or 'Tank-Fist' used a shaped charge to penetrate the armor of enemy tanks. Armed with this weapon, the standard infantry soldier was now a serious threat to enemy armor."
    menuImage=texture'InterfaceArt_tex.SelectMenus.Pak-soldat'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_ATWeapons.DH_PanzerFaustWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_SMG
}
