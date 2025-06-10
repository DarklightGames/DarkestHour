//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaAssaultEarly_Winter extends DHSOVAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloEarlyPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
}
