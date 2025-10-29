//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWFireteamLeader extends DHGECorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanLuftwaffePawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.FJ_Sleeve'
    Headgear(0)=Class'DH_LWHelmet'
    Headgear(1)=Class'DH_LWHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Kar98NoCoverWeapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
}