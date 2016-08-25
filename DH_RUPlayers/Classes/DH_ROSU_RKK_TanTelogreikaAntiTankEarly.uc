//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TanTelogreikaAntiTankEarly extends DH_ROSU_RKK_TanTelogreikaAntiTank;

defaultproperties
{
    PrimaryWeaponType=WT_PTRD
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PTRDWeapon',Amount=1,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=none
    GivenItems(0)="DH_Equipment.DHBinocularsItems"
}
