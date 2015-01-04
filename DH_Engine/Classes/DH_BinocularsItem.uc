//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
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
        PlayerController(Instigator.Controller).SetFOV(PlayerFOVZoom);
    }
    else
    {
        bPlayerViewIsZoomed = false;

        if (Instigator.Controller != none)
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
                    if (FireMode[Mode].bIsFiring)
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
            FireMode[Mode].bServerDelayStartFire = false;
            FireMode[Mode].bServerDelayStopFire = false;
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
    local DH_Pawn     P;
    local DHPlayer    C;
    local DH_RoleInfo RI;

    if (Instigator == none || !Instigator.IsLocallyControlled() || Instigator.Controller == none || !bUsingSights)
    {
       return;
    }

    P = DH_Pawn(Instigator);
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
    local DH_Pawn P;

    if (Instigator == none || !Instigator.IsLocallyControlled())
    {
        return;
    }

    P = DH_Pawn(Instigator);

    if (P != none && P.GetRoleInfo() != none && P.GetRoleInfo().bIsMortarObserver)
    {
        DHPlayer(Instigator.Controller).ServerCancelMortarTarget();
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local DH_Pawn  P;
    local DHPlayer C;

    super.BringUp(PrevWeapon);

    if (Instigator == none || !Instigator.IsLocallyControlled())
    {
        return;
    }

    P = DH_Pawn(Instigator);
    C = DHPlayer(Instigator.Controller);

    if (C != none && P != none && P.GetRoleInfo() != none && P.GetRoleInfo().bIsMortarObserver)
    {
        C.QueueHint(11, true);
    }
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
