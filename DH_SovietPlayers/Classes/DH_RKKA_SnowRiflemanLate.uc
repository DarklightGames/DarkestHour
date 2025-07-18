//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowRiflemanLate extends DH_RKKA_SnowRifleman;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietSnowLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=Class'DH_MN9130Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')

    Headgear(0)=Class'DH_SovietHelmetSnow'
}
