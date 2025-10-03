//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaSniperEarly extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloEarlyPawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves_tan'
    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietFurHat'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    PrimaryWeapons(0)=(Item=Class'DH_MN9130ScopedPEWeapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40ScopedWeapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}
