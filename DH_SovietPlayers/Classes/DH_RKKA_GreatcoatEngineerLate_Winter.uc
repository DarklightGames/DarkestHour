//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatEngineerLate_Winter extends DH_RKKA_GreatcoatEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownBagLatePawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreyLatePawn_Winter',Weight=1.0)
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    Headgear(0)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    HandType=Hand_Gloved
}
