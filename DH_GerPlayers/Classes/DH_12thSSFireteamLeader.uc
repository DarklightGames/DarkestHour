//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_12thSSFireteamLeader extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=Class'DH_German12thSSPawnB',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M712Weapon')
}
