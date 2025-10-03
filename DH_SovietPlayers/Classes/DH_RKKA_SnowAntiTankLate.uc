//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAntiTankLate extends DH_RKKA_SnowAntiTank;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietSnowLatePawn',Weight=1.0)
    PrimaryWeapons(0)=(Item=Class'DH_PTRDWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"

    Headgear(0)=Class'DH_SovietHelmetSnow'
}
