//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaAssaultLate_Winter extends DH_RKKA_TanTelogreikaAssaultEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloLatePawn_Winter',Weight=1.0)
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
    Headgear(0)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
}
