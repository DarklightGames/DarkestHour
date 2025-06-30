//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardFireteamLeaderLate extends DHSOVCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicSergeantLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicM43SergeantPawnB',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43SergeantGreenPawnB',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43SergeantDarkPawnB',Weight=1.0)
    Headgear(0)=Class'DH_SovietSidecap'
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'

    PrimaryWeapons(2)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
}
