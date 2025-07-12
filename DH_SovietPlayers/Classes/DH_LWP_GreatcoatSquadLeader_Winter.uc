//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatSquadLeader_Winter extends DHPOLSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPGreatcoatBrownSLPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPGreatcoatGreySLPawn_Winter',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPGreatcoatGreyBagPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_LWPCoatSleeves'
    Headgear(0)=Class'DH_LWPcap'
    Headgear(1)=Class'DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_AVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    HandType=Hand_Gloved
}
