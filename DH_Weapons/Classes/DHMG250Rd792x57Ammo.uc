//=============================================================================
// MG250Rd792x57Ammo
//=============================================================================
// Ammo class for German machine guns using 100 round ammo belts
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DHMG250Rd792x57Ammo extends ROAmmunition;

defaultproperties
{
     MaxAmmo=251
     InitialAmount=250
     PickupClass=Class'DH_Weapons.DHMG250Rd792x57AmmoPickup'
     IconMaterial=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     IconCoords=(X1=445,Y1=75,X2=544,Y2=149)
     ItemName="MG 250 Round 7.92x57 Belt"
}

