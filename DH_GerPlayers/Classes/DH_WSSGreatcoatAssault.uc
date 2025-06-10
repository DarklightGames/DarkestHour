//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSGreatcoatAssault extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    DetachedArmClass=Class'SeveredArmGerGreat'
    DetachedLegClass=Class'SeveredLegGerGreat'
    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_STG44Weapon',AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
