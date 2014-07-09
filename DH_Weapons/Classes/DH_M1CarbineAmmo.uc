//=============================================================================
// G41Ammo
//=============================================================================
// Ammo class for the G43
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_M1CarbineAmmo extends ROAmmunition;

defaultproperties
{
     MaxAmmo=16
     InitialAmount=15
     PickupClass=Class'DH_Weapons.DH_M1CarbineAmmoPickup'
     IconMaterial=Texture'DH_InterfaceArt_tex.weapon_icons.Carbine_ammo'
     IconCoords=(X1=445,Y1=75,X2=544,Y2=149)
     ItemName="M1 Carbine mag"
}
