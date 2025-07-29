//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_SnowAssault extends DHCSAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietSnowLatePawn',Weight=1.0)
    Headgear(0)=Class'DH_CSAZFurHatUnfolded'
    SleeveTexture=Texture'Weapons1st_tex.RussianSnow_Sleeves'
    HandType=Hand_Gloved

    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_PPSh41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
}
