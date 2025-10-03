//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardEngineerLate extends DH_RKKA_StandardEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicBackpackLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicLatePawn',Weight=2.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43PawnA',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43PawnB',Weight=1.0)
    RolePawns(4)=(PawnClass=Class'DH_SovietTunicM43GreenPawnA',Weight=1.0)
    RolePawns(5)=(PawnClass=Class'DH_SovietTunicM43GreenPawnB',Weight=1.0)
    RolePawns(6)=(PawnClass=Class'DH_SovietTunicM43DarkPawnA',Weight=1.0)
    RolePawns(7)=(PawnClass=Class'DH_SovietTunicM43DarkPawnB',Weight=1.0)

    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
}
