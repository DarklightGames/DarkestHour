//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHSquadLeaderC extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanCamoHeerPawn',Weight=8.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSniperHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.german_sleeves'
    Headgear(0)=Class'ROGermanHat'
    Headgear(1)=Class'DH_HeerHelmetTwo'
    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.7

    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_MP38Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
