//============================================================================
// ROGrenadeWeapon
// Created by Antarian on 1/11/04 as ROGrenadeWeapon
// Renamed ROExplosiveWeapon by Antarian 1/11/04
//
// Copyright (C) 2003, 2004 Jeffrey Nakai
//
// Has the base weapon info for the red orchestra grenades
//============================================================================

class DH_SatchelChargeMantleWeapon extends SatchelCharge10lb10sWeapon
	abstract;

var bool bIsMantling;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

simulated state StartMantle extends Busy
{
    simulated function Timer()
    {
	    // Stay in this state until the mantle is complete, to keep the weapon lowered without actually switching it
    	if (!bIsMantling)
            GoToState('RaisingWeapon');
        else
            SetTimer(0.2, false);
    }

    simulated function BeginState()
    {
	    local int Mode;

	    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
	    {
	        if (Instigator.IsLocallyControlled())
	        {
	            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	            {
	                if (FireMode[Mode].bIsFiring)
	                    ClientStopFire(Mode);
	            }

				if (ClientState == WS_BringUp)
					TweenAnim(SelectAnim,PutDownTime);
				else if (HasAnim(PutDownAnim))
					PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
	        }

	        ClientState = WS_PutDown;
	    }

	    SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate),false);

	    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	    {
			FireMode[Mode].bServerDelayStartFire = false;
			FireMode[Mode].bServerDelayStopFire = false;
		}
    }

    simulated function EndState()
    {
		if (ClientState == WS_PutDown)
			ClientState = WS_Hidden;
    }
}

defaultproperties
{
}
