//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardSniperLate extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicNocoatLatePawn',Weight=3.0)

    Headgear(0)=Class'DH_LWPcap'

    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_MN9130ScopedWeapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}
