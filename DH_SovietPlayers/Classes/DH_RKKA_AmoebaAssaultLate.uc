//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaAssaultLate extends DH_RKKA_AmoebaAssaultEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaLatePawn',Weight=1.0)
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_PPS43Weapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_PPSH41_stickWeapon',AssociatedAttachment=Class'ROInventory.ROPPS43AmmoPouch')
}
