//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardRiflemanLate extends DHPOLRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicBackpackLatePawn',Weight=5.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicLatePawn',Weight=2.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicMixLatePawn',Weight=2.0)
    Headgear(0)=Class'DH_LWPcap'
    Headgear(1)=Class'DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_MN9130Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_m44Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_kar98Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}
