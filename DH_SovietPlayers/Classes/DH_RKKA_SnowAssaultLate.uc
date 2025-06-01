//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAssaultLate extends DH_RKKA_SnowAssault;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
