//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSFireteamLeader_Winter extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowSSPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetSnow'
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M712Weapon')
    HandType=Hand_Gloved
}
