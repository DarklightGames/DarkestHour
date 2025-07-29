//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanLuftwaffePawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.FJ_Sleeve'
    Headgear(0)=Class'DH_LWHelmet'
    Headgear(1)=Class'DH_LWHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M712Weapon')
}
