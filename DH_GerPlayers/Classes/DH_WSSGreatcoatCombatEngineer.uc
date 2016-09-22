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
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
    Limit=1
}
