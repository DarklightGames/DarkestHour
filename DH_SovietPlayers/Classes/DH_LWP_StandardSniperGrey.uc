//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardSniperGrey extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicSLGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicMixBGreyPawn',Weight=1.0)
    Headgear(0)=Class'DH_LWPcap'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_MN9130ScopedWeapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}
