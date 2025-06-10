//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardAssaultEarly extends DHSOVAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicBackpackEarlyPawn',Weight=6.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicBackpackEarlyDarkPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicEarlyPawn',Weight=6.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicEarlyDarkPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
}
