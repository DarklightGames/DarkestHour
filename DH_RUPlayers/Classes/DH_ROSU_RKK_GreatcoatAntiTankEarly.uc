//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreatcoatAntiTankEarly extends DH_ROSU_RKK_GreatcoatAntiTank;

defaultproperties
{
    PrimaryWeaponType=WT_PTRD
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PTRDWeapon',Amount=1,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    GivenItems(0)="DH_Equipment.DHBinocularsItems"
    Grenades(0)=none
}
