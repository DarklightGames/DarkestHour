//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAntiTankEarly extends DH_RKKA_SnowAntiTank;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_PTRDWeapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=none)
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"

    Headgear(0)=Class'DH_SovietHelmetSnow'
}
