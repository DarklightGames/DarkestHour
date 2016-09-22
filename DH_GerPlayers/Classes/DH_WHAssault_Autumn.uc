//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHAssault_Autumn extends DH_HeerAutumn;

defaultproperties
{
    MyName="Assault Troop"
    AltName="Stoßtruppe"
    Article="an "
    PluralName="Assault Troopers"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetNoCover'
    Limit=4
}
