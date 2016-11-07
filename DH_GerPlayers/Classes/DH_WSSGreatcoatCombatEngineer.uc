//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatCombatEngineer extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Combat Engineer"
    AltName="SS Sturmpioniere"
    Article="a "
    PluralName="SS Combat Engineers"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon')
    Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
    Limit=1
}
