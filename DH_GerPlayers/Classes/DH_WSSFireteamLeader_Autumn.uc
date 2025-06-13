//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSFireteamLeader_Autumn extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=Class'DH_GermanAutumnSmockSSPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_GermanAutumnSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M712Weapon')
}
