//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHSquadLeader_Greatcoat extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    DetachedArmClass=Class'SeveredArmGerGreat'
    DetachedLegClass=Class'SeveredLegGerGreat'
    Headgear(0)=Class'DH_HeerHelmetOne'
    Headgear(1)=Class'ROGermanHat'

    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.2

    PrimaryWeapons(0)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
