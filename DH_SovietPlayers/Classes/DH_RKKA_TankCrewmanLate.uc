//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TankCrewmanLate extends DHSOVTankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTankCrewLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
}
