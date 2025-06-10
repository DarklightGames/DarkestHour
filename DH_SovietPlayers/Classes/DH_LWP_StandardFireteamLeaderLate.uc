//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardFireteamLeaderLate extends DHPOLCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicSLLatePawn',Weight=3.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicSLLatePawnB',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicSLLatePawnC',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_LWPTunicMixLatePawn',Weight=2.0)

    Headgear(0)=Class'DH_LWPcap'
    Headgear(1)=Class'DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')

    SecondaryWeapons(0)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(1)=(Item=Class'DH_Nagant1895Weapon')
    SecondaryWeapons(2)=(Item=Class'DH_ViSWeapon')
}
