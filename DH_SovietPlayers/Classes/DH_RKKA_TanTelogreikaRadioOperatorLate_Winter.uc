//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaRadioOperatorLate_Winter extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloStrapsLatePawn_Winter',Weight=1.0)
    PrimaryWeapons(0)=(Item=Class'DH_MN9130Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    HandType=Hand_Gloved
    Headgear(0)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
	Backpacks(0)=(BackpackClass=Class'DH_SovRadioBackpack',LocationOffset=(X=-0.1))
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
}
