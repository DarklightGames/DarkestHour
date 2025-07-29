//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardSniperEarly extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicEarlyPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietSidecap'

    PrimaryWeapons(0)=(Item=Class'DH_MN9130ScopedPEWeapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT40ScopedWeapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
}
