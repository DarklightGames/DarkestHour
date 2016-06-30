//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreenTelogreikaAntiTankEarly extends DH_ROSU_RKK_GreenTelogreikaAntiTank;

defaultproperties
{
    PrimaryWeaponType=WT_PTRD
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_PTRDWeapon',Amount=1,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
    Grenades(0)=None
    InfoText="PT-Soldat were armed with special anti-tank rifles firing large caliber armor piercing rounds. while not very effective against the heavily armored areas of tanks, the anti-tank rifles could be used to exploit the more weakly armored areas of enemy vehicles."
}
