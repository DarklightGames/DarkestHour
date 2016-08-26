//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TanTelogreikaEngineer extends DH_ROSU_RKK_TanTelogreika;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[1];
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Saper"
    Article="a "
    PluralName="Combat Engineers"
    PrimaryWeaponType=WT_SMG
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPD40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPS43Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Weapons.DH_RDG1GrenadeWeapon',Amount=1)
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietSidecap'
    bEnhancedAutomaticControl=true
    limit=2
}
