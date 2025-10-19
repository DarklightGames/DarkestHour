//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatAssaultLate extends DH_RKKA_GreatcoatAssaultEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownBagLatePawn',Weight=3.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreyBagLatePawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietGreatcoatBrownLatePawn',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietGreatcoatGreyLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
}
