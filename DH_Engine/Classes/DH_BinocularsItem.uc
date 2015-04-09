//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BinocularsItem extends BinocularsItem;

var bool bIsMantling;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

simulated function PlayerViewZoom(bool ZoomDirection)
{
    if (ZoomDirection)
    {
        bPlayerViewIsZoomed = true;

        if (Instigator != none && PlayerController(Instigator.Controller) != none)
        {
            PlayerController(Instigator.Controller).SetFOV(PlayerFOVZoom);
        }
    }
    else
    {
        bPlayerViewIsZoomed = false;

        if (Instigator != none && PlayerController(Instigator.Controller) != none)
        {
            PlayerController(Instigator.Controller).ResetFOV();
        }
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
        local int Mode;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
                {
                    if (FireMode[Mode] != none && FireMode[Mode].bIsFiring)
                    {
                        ClientStopFire(Mode);
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

        for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
        {
            if (FireMode[Mode] != none)
            {
                FireMode[Mode].bServerDelayStartFire = false;
                FireMode[Mode].bServerDelayStopFire = false;
            }
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

simulated state LoweringWeapon
{
    // Matt: modified to fix problem that writes many 'accessed none' errors to the log
    // Need to avoid Super from ROWeapon, which only duplicates Super from BinocularsItem but adds unwanted calls on FireMode classes that binoculars don't have
    simulated function EndState()
    {
        if (bUsingSights && Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }

        if (ClientState == WS_PutDown)
        {
            if (Instigator.PendingWeapon == none)
            {
                PlayIdle();

                ClientState = WS_ReadyToFire;
            }
            else
            {
                ClientState = WS_Hidden;

                Instigator.ChangedWeapon();

                if (Instigator.Weapon == self)
                {
                    PlayIdle();

                    ClientState = WS_ReadyToFire;
                }
            }
        }
    }
}

simulated function Fire(float F)
{
    local DHPawn      P;
    local DHPlayer    C;
    local DHRoleInfo RI;

    if (Instigator == none || !Instigator.IsLocallyControlled() || Instigator.Controller == none || !bUsingSights)
    {
       return;
    }

    P = DHPawn(Instigator);
    C = DHPlayer(Instigator.Controller);

    if (P == none || C == none)
    {
        return;
    }

    RI = P.GetRoleInfo();

    if (RI == none)
    {
        return;
    }

    if (RI.bIsMortarObserver)
    {
        C.ServerSaveMortarTarget();
    }
    else if (RI.bIsArtilleryOfficer)
    {
        C.ServerSaveArtilleryPosition();
    }
}

simulated function AltFire(float F)
{
    local DHPawn P;

    if (Instigator == none || !Instigator.IsLocallyControlled())
    {
        return;
    }

    P = DHPawn(Instigator);

    if (P != none && P.GetRoleInfo() != none && P.GetRoleInfo().bIsMortarObserver)
    {
        DHPlayer(Instigator.Controller).ServerCancelMortarTarget();
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPawn   P;
    local DHPlayer C;

    super.BringUp(PrevWeapon);

    if (Instigator == none || !Instigator.IsLocallyControlled())
    {
        return;
    }

    P = DHPawn(Instigator);
    C = DHPlayer(Instigator.Controller);

    if (C != none && P != none && P.GetRoleInfo() != none && P.GetRoleInfo().bIsMortarObserver)
    {
        C.QueueHint(11, true);
    }
}

// Matt: added here to fix "accessed none" error, now that binocs can be dropped
// Binocs don't have any FireModes, so better to remove that block of code instead of adding FireMode != none
function DropFrom(vector StartLocation)
{
    local ROMultiMagAmmoPickup AmmoPickup;
    local Pickup  Pickup, TempPickup;
    local int     DropMagCount, i;
    local rotator R;

    if (!bCanThrow)
    {
        return;
    }

    if (Instigator != none && bUsingSights)
    {
        bUsingSights = false;
        ROPawn(Instigator).SetIronSightAnims(false);
    }

    ClientWeaponThrown();

    if (Instigator != none)
    {
        DetachFromPawn(Instigator);
    }

    Pickup = Spawn(PickupClass,,, StartLocation);

    if (Pickup != none)
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;

        if (Instigator.Health > 0)
        {
            WeaponPickup(Pickup).bThrown = true;
        }
    }

    // Handle multi mag ammo type pickups
    if (class<ROMultiMagAmmoPickup>(AmmoPickupClass(0)) != none && CurrentMagCount > 0)
    {
        R.Yaw = Rand(65536);
        TempPickup = spawn(AmmoPickupClass(0),,, StartLocation, R);
        AmmoPickup = ROMultiMagAmmoPickup(TempPickup);

        if (AmmoPickup == none)
        {
            return;
        }

        AmmoPickup.InitDroppedPickupFor(self);

        AmmoPickup.Velocity.X = Float(Rand(200));
        AmmoPickup.Velocity.Y = Float(Rand(200));
        AmmoPickup.Velocity.Z = Float(Rand(100));

        AmmoPickup.AmmoMags.Length = CurrentMagCount;

        for (i = 0; i < PrimaryAmmoArray.Length; ++i)
        {
            if (i != CurrentMagIndex)
            {
                AmmoPickup.AmmoMags[DropMagCount] = PrimaryAmmoArray[i];
                DropMagCount++;
            }
        }
    }
    // Handle standard/old style ammo pickups
    else
    {
        for (i = 0; i < PrimaryAmmoArray.Length; ++i)
        {
            if (i != CurrentMagIndex)
            {
                DropAmmo(StartLocation, PrimaryAmmoArray[i]);
            }
        }
    }

    Destroy();
}

simulated function bool CanThrow()
{
    return true;
}

defaultproperties
{
    AttachmentClass=class'DH_Engine.DH_BinocularsAttachment'
    bCanThrow=true
    PickupClass=class'DH_Engine.DH_BinocularsPickup'
}
