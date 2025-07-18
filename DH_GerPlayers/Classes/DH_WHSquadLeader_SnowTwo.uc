//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHSquadLeader_SnowTwo extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanSnowGreatCoatPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSnowHeerPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.snow_sleeves'
    Headgear(0)=Class'DH_HeerHelmetSnowTwo'
    Headgear(1)=Class'DH_HeerHelmetSnowThree'
    Headgear(2)=Class'DH_HeerHelmetSnow'
    Headgear(3)=Class'DH_HeerHelmetCover'
    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.25
    HeadgearProbabilities(2)=0.3
    HeadgearProbabilities(3)=0.05
    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    HandType=Hand_Gloved
}
