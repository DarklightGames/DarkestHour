//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZ_SnowAssault extends DHCSAssaultRoles;  

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowLatePawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_CSAZFurHatUnfolded'
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    HandType=Hand_Gloved

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSh41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
}
