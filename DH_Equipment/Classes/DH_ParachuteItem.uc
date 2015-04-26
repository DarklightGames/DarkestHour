//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ParachuteItem extends DHWeapon;

var     bool    bUsedParachute;
var     name    DeployChuteAnim;
var     name    UndeployChuteAnim;

//=============================================================================
// Functions overridden because parachutes don't shoot
//=============================================================================

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

    if (IsCurrentWeapon()) // this weapon was switched to while waiting for replication, switch to it now
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
        if (Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
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
    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        // If player is falling, this resets stamina to full (stam removed when chute deploys in ParachuteStaticLine)
        if (Instigator.Physics == PHYS_Falling)
        {
            bUsedParachute = true;
            DHPawn(Instigator).Stamina = DHPawn(Instigator).default.Stamina;
        }

        if (ClientState == WS_Hidden)
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);

            if (InstigatorIsLocallyControlled())
            {
                if (Mesh != none && HasAnim(SelectAnim))
                {
                    PlayAnim(SelectAnim, SelectAnimRate, 0.0);
                }
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(SelectAnim, SelectAnimRate), false);

        // Hint check
        if (DHPlayer(Instigator.Controller) != none)
        {
            DHPlayer(Instigator.Controller).QueueHint(2, true);
        }
    }

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
    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
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
    }

    simulated function EndState()
    {
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

                if (IsCurrentWeapon())
                {
                    PlayIdle();
                    ClientState = WS_ReadyToFire;
                }
            }
        }

        if (bUsedParachute && Instigator.Physics != PHYS_Falling)
        {
            Instigator.DeleteInventory(self);
        }
    }
}
//******************************************************************************

// Overwritten to prevent 1st person arms & chute changing pitch rotation
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

simulated function AnimEnd(int Channel)
{
    if (ClientState == WS_ReadyToFire)
    {
        if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

// No ammo for this weapon
function bool FillAmmo(){return false;}
function bool ResupplyAmmo(){return false;}
simulated function bool IsFiring(){return false;}

// No free-aim for parachute
simulated function bool ShouldUseFreeAim()
{
    return false;
}

// Not busy in the idle state because we never fire
simulated function bool IsBusy()
{
    return false;
}

simulated function bool WeaponCanSwitch()
{
    return Instigator.Physics != PHYS_Falling;
}

// Sprinting interrupts the parachute un/deploy animation, so disallow it
simulated function bool WeaponAllowSprint()
{
    return false;
}

// Don't fire parachute
simulated event ClientStartFire(int Mode)
{
    return;
}

// Don't fire parachute
simulated event StopFire(int Mode)
{
    return;
}

// Can't reload parachute
simulated exec function ROManualReload()
{
    return;
}

// Parachutes don't shoot
simulated function Fire(float F)
{
    return;
}

defaultproperties
{
    PutDownAnim="PutDown"
    bCanThrow=false
    InventoryGroup=12
    ItemName="Parachute"
    AttachmentBone="HIP"
    Mesh=SkeletalMesh'DH_Parachute_anm.Parachute1st'
}
