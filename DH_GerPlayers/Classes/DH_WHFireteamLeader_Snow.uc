//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHFireteamLeader_Snow extends DHGECorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowHeerPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueHeerPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.12thSS_Sleeve' //to do:
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetSnow'
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    HandType=Hand_Gloved
}
