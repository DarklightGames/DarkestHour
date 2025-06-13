//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PzLehrSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_PanzerLehrPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.pzlehr_sleeve'
    Headgear(0)=Class'DH_HeerHelmetOne'
    Headgear(1)=Class'ROGermanHat'
    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3

    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
