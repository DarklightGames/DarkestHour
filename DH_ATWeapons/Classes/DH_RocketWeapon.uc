//===================================================================
// RORocketWeapon
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Base class for Rocket Launching weapons
//===================================================================


class DH_RocketWeapon extends DH_ProjectileWeapon
	abstract;

//=============================================================================
// Variables
//=============================================================================

var     ROFPAmmoRound            RocketAttachment;     // The first person ammo round attached to the rocket

simulated function Destroyed()
{
    if (RocketAttachment != none)
        RocketAttachment.Destroy();

	Super.Destroyed();
}

defaultproperties
{
     Priority=8
     InventoryGroup=5
}
