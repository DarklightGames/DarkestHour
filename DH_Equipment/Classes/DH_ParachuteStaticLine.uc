//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ParachuteStaticLine extends Weapon;

#exec OBJ LOAD FILE=..\Sounds\DH_SundrySounds.uax
#exec OBJ LOAD FILE=..\Sounds\Inf_Player.uax

var     bool    bChuteDeployed;


// No ammo for this weapon
function bool FillAmmo(){return false;}
function bool ResupplyAmmo(){return false;}
simulated function bool IsFiring(){return false;}

// Matt: modified to stop most stuff happening on a net client, to avoid "accessed none" errors, & to play an appropriate landing sound based on the surface we land on
simulated function Tick(float DeltaTime)
{
    if (Instigator != none)
    {
        if (!bChuteDeployed)
        {
            // If player is falling then deploy parachute
            if (Instigator.Physics == PHYS_Falling && Instigator.Velocity.Z < -1.0 * Instigator.MaxFallSpeed)
            {
                bChuteDeployed = true;

                Instigator.Controller.bCrawl = 0;
                Instigator.ShouldProne(false);
                Instigator.Switchweapon(12);

                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).Stamina = 0.0; // this is set back to default in DH_ParachuteItem.RaisingWeapon so that any sprinting is forcibly stopped, allowing a weaponswap
                    }

                    AttachChute(Instigator);
                    Instigator.PlaySound(sound'DH_SundrySounds.Parachute.ParachuteDeploy', SLOT_Misc, 512.0, true, 128.0);
                    Instigator.AirControl = 1.0;
                    Instigator.AccelRate = 60.0;
                    Instigator.Velocity.Z = -400.0;
                }
            }
        }
        else
        {
            if (Instigator.Physics == PHYS_Falling)
            {
                if (Role == ROLE_Authority)
                {
                    Instigator.Velocity.Z = -400.0;
                }
            }
            else
            {
                if (Role == ROLE_Authority)
                {
                    Instigator.AccelRate = Instigator.default.AccelRate;
                    Instigator.AirControl = Instigator.default.AirControl;

                    // Matt: use GetSound function to get a landing sound appropriate to the surface we landed on
                    if (ROPawn(Instigator) != none)
                    {
                        Instigator.PlaySound(ROPawn(Instigator).GetSound(EST_Land), SLOT_Misc, 512.0, true, 128.0);
                    }
                    else
                    {
                        Instigator.PlaySound(SoundGroup'Inf_Player.footsteps.LandGrass', SLOT_Misc, 512.0, true, 128.0); // fallback
                    }

                    RemoveChute(Instigator);

                    // Make 100% sure that the chute is gone, as it occasionally isn't being removed the first time
                    if (ThirdPersonActor != none)
                    {
                        RemoveChute(Instigator);
                    }
                }

                if (Level.NetMode != NM_DedicatedServer)
                {
                    Instigator.Controller.ClientSwitchToBestWeapon();
                }

                Instigator.DeleteInventory(self);
                Destroy(); // Matt: moved further down to avoid errors
            }
        }
    }
}

// Make 3rd person model of chute appear/disappear
function AttachChute(Pawn P)
{
    Instigator = P;

    if (bChuteDeployed)
    {
        if (ThirdPersonActor == none)
        {
            ThirdPersonActor = Spawn(AttachmentClass, Owner);
            InventoryAttachment(ThirdPersonActor).InitFor(self);
        }
        else
        {
            ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        P.AttachToBone(ThirdPersonActor,'hip');
    }
    else
    {
        RemoveChute(Instigator);
    }
}

function RemoveChute(Pawn P)
{
    if (ThirdPersonActor != none)
    {
        ThirdPersonActor.Destroy();
        ThirdPersonActor = none;
        Destroyed();
    }
}

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

    if (Instigator.Weapon == self || Instigator.PendingWeapon == self) // this weapon was switched to while waiting for replication, switch to it now
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
        if (PlayerController(Instigator.Controller) != none && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
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
    simulated function BeginState(){}

    simulated function EndState(){}
}

simulated state LoweringWeapon
{
    simulated function BeginState(){}

    simulated function EndState(){}
}

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

simulated function AnimEnd(int channel)
{
    if (ClientState == WS_ReadyToFire)
    {
        if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

defaultproperties
{
    InventoryGroup=11
    AttachmentClass=class'DH_Equipment.DH_ParachuteAttachment'
    ItemName="Staticline"
}
