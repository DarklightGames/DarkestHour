//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

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
        {
            GoToState('RaisingWeapon');
        }
        else
        {
            SetTimer(0.2, false);
        }
    }

    simulated function BeginState()
    {
        local int i;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; i++)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim,PutDownTime);
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; i++)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        if (ClientState == WS_PutDown)
        {
            ClientState = WS_Hidden;
        }
    }
}

defaultproperties
{
}
