//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PzLehrFireteamLeader extends DHGECorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_PanzerLehrPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.pzlehr_sleeve'
    Headgear(0)=Class'DH_HeerHelmetOne'
    Headgear(1)=Class'DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
}
