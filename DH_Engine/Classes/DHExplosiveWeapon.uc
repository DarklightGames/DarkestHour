//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHExplosiveWeapon extends ROExplosiveWeapon
    abstract;

var bool bIsMantling;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

//Override to allow for grenades to drop with spread (so they aren't inside eachother)
function DropFrom(vector StartLocation)
{
    local int i;
    local Pickup Pickup;
    local rotator R;

    if (!bCanThrow)
    {
        return;
    }

    ClientWeaponThrown();

    for (i = 0; i < arraycount(FireMode); ++i)
    {
        if (FireMode[i].bIsFiring)
        {
            StopFire(i);
        }
    }

    if (Instigator != none)
    {
        DetachFromPawn(Instigator);
    }

    // Destroy empty weapons without pickups if needed (panzerfaust, etc)
    if (AmmoAmount(0) < 1)
    {
        Destroy();
    }
    else
    {
        for (i = 0; i < AmmoAmount(0); ++i)
        {
            R.Yaw = Rand(65536);
            Pickup = Spawn(PickupClass,,, StartLocation, R);

            if (Pickup != none)
            {
                Pickup.InitDroppedPickupFor(self);
                Pickup.Velocity = Velocity >> R;
                Pickup.Velocity.X += RandRange(-100.0, 100.0);
                Pickup.Velocity.Y += RandRange(-100.0, 100.0);

                if (Instigator.Health > 0)
                {
                    WeaponPickup(Pickup).bThrown = true;
                }

                Pickup = none;
            }
        }

        Destroy();
    }
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
                for (i = 0; i < arraycount(FireMode); ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim, PutDownTime);
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (i = 0; i < arraycount(FireMode); ++i)
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

function bool IsGrenade()
{
    return true;
}

defaultproperties
{
    PreFireHoldAnim="pre_fire_idle"
    FuzeLength=5.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    PlayerViewOffset=(X=5.0,Y=5.0,Z=0.0)
    BobDamping=1.6
}
