//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreenTelogreikaEngineerLate extends DH_RKKA_GreenTelogreikaEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreenTeloLatePawn',Weight=1.0)

    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
}
