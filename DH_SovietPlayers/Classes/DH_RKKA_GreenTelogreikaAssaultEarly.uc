//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreenTelogreikaAssaultEarly extends DHSOVAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreenTeloEarlyPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves_Green'

    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
}
