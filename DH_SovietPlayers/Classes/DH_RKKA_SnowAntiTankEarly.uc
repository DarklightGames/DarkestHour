//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAntiTankEarly extends DH_RKKA_SnowAntiTank;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PTRDWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=none)
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
}
