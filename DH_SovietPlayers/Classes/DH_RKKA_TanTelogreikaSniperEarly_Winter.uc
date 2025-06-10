//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaSniperEarly_Winter extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloSLEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    Headgear(0)=Class'DH_SovietFurHatUnfolded'
    Headgear(1)=Class'DH_SovietFurHat'
    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.2
    PrimaryWeapons(0)=(Item=Class'DH_MN9130ScopedPEWeapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40ScopedWeapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    HandType=Hand_Gloved
}
