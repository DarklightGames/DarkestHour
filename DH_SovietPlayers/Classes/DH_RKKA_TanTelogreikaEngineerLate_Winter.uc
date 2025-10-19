//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaEngineerLate_Winter extends DH_RKKA_TanTelogreikaEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloLatePawn_Winter',Weight=1.0)
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    HandType=Hand_Gloved
    Headgear(0)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
}
