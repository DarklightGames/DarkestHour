//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ParachuteItem extends DHWeapon;

var     bool    bUsedParachute;

// Functions emptied out or returning false, as parachute isn't a real weapon
simulated function Fire(float F) {return;}
simulated event ClientStartFire(int Mode) {return;}
simulated event StopFire(int Mode) {return;}
simulated function bool IsFiring(){return false;}
function bool FillAmmo(){return false;}
function bool ResupplyAmmo(){return false;}
exec simulated function ROManualReload() {return;}
simulated function bool IsBusy() {return false;} // not busy in the idle state because we never fire
simulated function bool ShouldUseFreeAim() {return false;}

// Modified so can't switch away from chute while in the air
simulated function bool WeaponCanSwitch()
{
    return Instigator != none && Instigator.Physics != PHYS_Falling;
}

// Modified to prevent sprinting as it interrupts the parachute un/deploy animation
simulated function bool WeaponAllowSprint()
{
    return false;
}

// Modified to remove firing stuff
simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    Instigator = Pawn(Owner);

    bPendingSwitch = bPossiblySwitch;

    if (Instigator == none)
    {
        GotoState('PendingClientWeaponSet');

        return;
    }

    ClientState = WS_Hidden;
    GotoState('Hidden');

    if (Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled())
    {
        return;
    }

    if (Instigator != none && (Instigator.Weapon == self || Instigator.PendingWeapon == self)) // this weapon was switched to while waiting for replication, switch to it now
    {
        if (Instigator.PendingWeapon != none)
        {
            Instigator.ChangedWeapon();
        }
        else
        {
            BringUp();
        }

        return;
    }

    if (Instigator.PendingWeapon != none && Instigator.PendingWeapon.bForceSwitch)
    {
        return;
    }

    if (Instigator.Weapon == none)
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if (bPossiblySwitch && !Instigator.Weapon.IsFiring())
    {
        if (PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
        {
            return;
        }

        if (Instigator.PendingWeapon != none)
        {
            if (RateSelf() > Instigator.PendingWeapon.RateSelf())
            {
                Instigator.PendingWeapon = self;
                Instigator.Weapon.PutDown();
            }
        }
        else if (RateSelf() > Instigator.Weapon.RateSelf())
        {
            Instigator.PendingWeapon = self;
            Instigator.Weapon.PutDown();
        }
    }
}

simulated state RaisingWeapon
{
    // Modified to remove firing stuff, to reset stamina, & to add a parachute hint
    simulated function BeginState()
    {
        local Inventory Inv;
        local DHWeapon W;

        // If player is falling, this resets stamina to full (stamina removed when chute deploys in ParachuteStaticLine)
        if (Instigator != none && Instigator.Physics == PHYS_Falling)
        {
            bUsedParachute = true;
            DHPawn(Instigator).Stamina = DHPawn(Instigator).default.Stamina;
        }

        if (ClientState == WS_Hidden)
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);

            if (InstigatorIsLocallyControlled() && Mesh != none && HasAnim(SelectAnim))
            {
                PlayAnim(SelectAnim, SelectAnimRate, 0.0);
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(SelectAnim, SelectAnimRate), false);

        if (DHPlayer(Instigator.Controller) != none)
        {
            DHPlayer(Instigator.Controller).QueueHint(2, true); // parachute hint
        }

        for (Inv = Instigator.Inventory; Inv != none; Inv = Inv.Inventory)
        {
            W =  DHWeapon(Inv);

            Log(W);

            if (W == none)
            {
                continue;
            }

            W.bHasBeenDrawn = false;
        }
    }

    // Modified so player switches away from chute if no longer falling, & to remove firing stuff
    simulated function EndState()
    {
        if (InstigatorIsHumanControlled() && Instigator.Physics != PHYS_Falling)
        {
            Instigator.Controller.ClientSwitchToBestWeapon();
        }
    }
}

simulated state LoweringWeapon
{
    // Modified to remove firing stuff
    simulated function BeginState()
    {
        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
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
    }

    // Modified to delete the chute from the player's inventory after landing, & to remove firing stuff
    simulated function EndState()
    {
        if (ClientState == WS_PutDown)
        {
            if (Instigator != none && Instigator.PendingWeapon == none)
            {
                PlayIdle();
                ClientState = WS_ReadyToFire;
            }
            else
            {
                ClientState = WS_Hidden;

                if (Instigator != none)
                {
                    Instigator.ChangedWeapon();

                    if (Instigator.Weapon == self)
                    {
                        PlayIdle();
                        ClientState = WS_ReadyToFire;
                    }
                }
            }
        }

        if (bUsedParachute && Instigator != none && Instigator.Physics != PHYS_Falling)
        {
            Instigator.DeleteInventory(self);
        }
    }
}

// Modified to remove firing stuff
simulated function AnimEnd(int Channel)
{
    if (ClientState == WS_ReadyToFire && (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring))
    {
        PlayIdle();
    }
}

// Modified to prevent 1st person arms & chute changing pitch rotation
simulated event RenderOverlays(Canvas Canvas)
{
    local rotator YawMod;

    if (Instigator != none)
    {
        Canvas.DrawActor(none, false, true);
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
        YawMod.Yaw = Instigator.GetViewRotation().Yaw;
        SetRotation(YawMod);

        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, 90.0);
        bDrawingFirstPerson = false;
    }
}

defaultproperties
{
    ItemName="Parachute"
    InventoryGroup=12
    bCanThrow=false
    Mesh=SkeletalMesh'DH_Parachute_anm.Parachute1st'
    AttachmentBone="HIP"
    PutDownAnim="PutDown"
}
