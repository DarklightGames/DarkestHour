//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardSquadLeaderLate extends DH_RKKA_StandardSquadLeaderEarly;

defaultproperties
{

    RolePawns(0)=(PawnClass=Class'DH_SovietTunicSergeantLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicM43SergeantPawnA',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43SergeantGreenPawnA',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43SergeantDarkPawnA',Weight=1.0)
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
}
