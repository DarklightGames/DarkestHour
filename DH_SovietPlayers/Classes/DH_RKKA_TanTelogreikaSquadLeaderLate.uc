//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaSquadLeaderLate extends DH_RKKA_TanTelogreikaSquadLeaderEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloSLLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')

    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietFurHat'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
