//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaFireteamLeaderLate extends DHSOVCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloLatePawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietFurHat'
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves_tan'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    PrimaryWeapons(2)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
}
