//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatAssaultLate_Winter extends DH_RKKA_GreatcoatAssaultEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownBagLatePawn_Winter',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyLatePawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
}
