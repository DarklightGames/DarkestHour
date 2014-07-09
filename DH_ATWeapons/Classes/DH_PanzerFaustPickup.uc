//=============================================================================
// PanzerFaustPickup
//=============================================================================
// PanzerFaust Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_PanzerFaustPickup extends PanzerFaustPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: Panzerfaust 60"
     InventoryType=Class'DH_ATWeapons.DH_PanzerFaustWeapon'
     PickupMessage="You got the Panzerfaust 60."
}
