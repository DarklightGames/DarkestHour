//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHSquadLeader_Snow extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowHeerPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    Headgear(0)=Class'DH_HeerHelmetSnow'
    Headgear(1)=Class'DH_HeerHelmetCover'
    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_MP38Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    HandType=Hand_Gloved
}
