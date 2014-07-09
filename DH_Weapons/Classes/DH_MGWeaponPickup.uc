//=============================================================================
// DH_MGWeaponPickup
// started by Antarian on 3/8/04
//
// Copyright (C) 2004 Jeffrey Nakai
//
// Base class for MG pickups, we need extra variables here to support barrel
//	heating
//
// Future Idea:  Have steam coming off the pickup
//=============================================================================
class DH_MGWeaponPickup extends ROWeaponPickup
   abstract;

var		float		DH_MGCelsiusTemp, DH_MGCelsiusTemp2;
var		float		BarrelCoolingRate;
var		bool		bBarrelFailed, bBarrelFailed2, bHasSpareBarrel;
var		int         RemainingBarrel;


function InitDroppedPickupFor(Inventory Inv)
{
		//WeaponTODO: reimplement this

    local DHWeapon W;
    W = DHWeapon(Inv);

    if( (DH_MGBase(W) != none) && (DH_MGBase(W).BarrelArray[DH_MGBase(W).ActiveBarrel] != none) )
    {
    	DH_MGCelsiusTemp = DH_MGBase(W).BarrelArray[DH_MGBase(W).ActiveBarrel].DH_MGCelsiusTemp;
    	BarrelCoolingRate = DH_MGBase(W).BarrelArray[DH_MGBase(W).ActiveBarrel].BarrelCoolingRate;
		bBarrelFailed = DH_MGBase(W).BarrelArray[DH_MGBase(W).ActiveBarrel].bBarrelFailed;

		if( DH_MGBase(W).RemainingBarrels > 1)
		{
            if( DH_MGBase(W).ActiveBarrel == 0 )
    	        RemainingBarrel = 1;
	        else
	            RemainingBarrel = 0;

            DH_MGCelsiusTemp2 = DH_MGBase(W).BarrelArray[RemainingBarrel].DH_MGCelsiusTemp;
            bHasSpareBarrel = True;
		}
    }

    super.InitDroppedPickupFor(Inv);
}


function Tick( float dt )
{
	// make sure it's run on the
	if( Role < ROLE_Authority )
		return;

	// continue to lower the barrel temp
	DH_MGCelsiusTemp -= dt * BarrelCoolingRate;

    if( bHasSpareBarrel )
        DH_MGCelsiusTemp2 -= dt * BarrelCoolingRate;
}

defaultproperties
{
}
