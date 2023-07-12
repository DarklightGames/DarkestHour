//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ParachuteStaticLine extends Weapon;

#exec OBJ LOAD FILE=..\Sounds\DH_SundrySounds.uax
#exec OBJ LOAD FILE=..\Sounds\Inf_Player.uax

var     bool    bChuteDeployed;

// Functions emptied out or returning false, as parachute isn't a real weapon
simulated function Fire(float F) {return;}
simulated event ClientStartFire(int Mode) {return;}
simulated event StopFire(int Mode) {return;}
simulated function bool IsFiring() {return false;}
function bool FillAmmo() {return false;}
function bool ResupplyAmmo() {return false;}
exec simulated function ROManualReload() {return;}
simulated function bool IsBusy() {return false;} // not busy in the idle state because we never fire
simulated function bool ShouldUseFreeAim() {return false;}

simulated state RaisingWeapon
{
    simulated function BeginState() {return;}
    simulated function EndState() {return;}
}

simulated state LoweringWeapon
{
    simulated function BeginState() {return;}
    simulated function EndState() {return;}
}

// Modified (from DH 5.1) to stop most stuff happening on net client, to avoid "accessed none" errors, & to play appropriate landing sound based on surface we land on
simulated function Tick(float DeltaTime)
{
    if (Instigator == none)
    {
        return;
    }

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
                Instigator.PlaySound(Sound'DH_SundrySounds.Parachute.ParachuteDeploy', SLOT_Misc, 512.0, true, 128.0);
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
            Instigator.Velocity.Z = -400.0;
        }
        else
        {
            if (Role == ROLE_Authority)
            {
                Instigator.AccelRate = Instigator.default.AccelRate;
                Instigator.AirControl = Instigator.default.AirControl;

                // Using GetSound function to get a landing sound appropriate to the surface we landed on
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
            Destroy(); // moved further down to avoid errors
        }
    }
}

// New function to make 3rd person model of chute appear/disappear
function AttachChute(Pawn P)
{
    Instigator = P;

    if (bChuteDeployed)
    {
        if (ThirdPersonActor == none)
        {
            ThirdPersonActor = Spawn(AttachmentClass, Owner);

            if (InventoryAttachment(ThirdPersonActor) != none)
            {
                InventoryAttachment(ThirdPersonActor).InitFor(self);
            }
        }
        else
        {
            ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        P.AttachToBone(ThirdPersonActor, 'hip');
    }
    else
    {
        RemoveChute(Instigator);
    }
}

// New function to destroy chute attachment
function RemoveChute(Pawn P)
{
    if (ThirdPersonActor != none)
    {
        ThirdPersonActor.Destroy();
        ThirdPersonActor = none;
        Destroyed();
    }
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

// Modified to remove firing stuff
simulated function AnimEnd(int Channel)
{
    if (ClientState == WS_ReadyToFire && (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring))
    {
        PlayIdle();
    }
}

// Modified to prevent sprinting as it interrupts the parachute un/deploy animation
simulated function bool WeaponAllowSprint()
{
    return false;
}

defaultproperties
{
    ItemName="Staticline"
    AttachmentClass=class'DH_Equipment.DH_ParachuteAttachment'
    FireModeClass(0)=class'ROInventory.ROEmptyFireclass' // prevents "accessed none" log errors
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    InventoryGroup=11
}
