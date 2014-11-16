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

simulated function Tick(float DeltaTime)
{
    if (bChuteDeployed)
    {
        if (Instigator.Physics == PHYS_Falling)
        {
            Instigator.Velocity.Z=-400;
            if (Instigator.Weapon != class'DH_Equipment.DH_ParachuteItem')
                Instigator.SwitchWeapon(12);
        }
        else
        {
            Instigator.AccelRate = Instigator.default.AccelRate;
            Instigator.AirControl=Instigator.default.AirControl;
            Instigator.PlaySound(soundgroup'Inf_Player.footsteps.LandGrass', SLOT_Misc,512,true,128);
//          Instigator.bJustLanded = true;
            RemoveChute(Instigator);

            // Make 100% sure that the chute is gone, as it occasionally isn't being removed the first time
            if (ThirdPersonActor != none)
                RemoveChute(Instigator);

            DHPlayer(Instigator.Controller).ClientSwitchToBestWeapon();
//          Instigator.SwitchtoLastWeapon();
            Destroy();
            Instigator.DeleteInventory(self);
//            DH_Pawn(Instigator).DestroyChute();
        }
    }
    else
    {
        //If player is falling then deploy parachute
        if (Instigator.Physics == PHYS_Falling && Instigator.Velocity.Z < (-1)*Instigator.MaxFallSpeed)
        {
            bChuteDeployed = true;
            DH_Pawn(Instigator).Stamina=0; // This is set back to default in DH_ParachuteItem.RaisingWeapon so that any sprinting is forcibly stopped, allowing a weaponswap
            DHPlayer(Instigator.Controller).bCrawl=0;
            Instigator.ShouldProne(false);
            Instigator.Switchweapon(12);
            AttachChute(Instigator);
            Instigator.PlaySound(sound'DH_SundrySounds.Parachute.ParachuteDeploy', SLOT_Misc,512,true,128);
//          Instigator.ClientMessage("Parachute Deployed");
//          Instigator.Acceleration = vect(0,0,0);
            Instigator.AirControl=1;
            Instigator.AccelRate=60;
            Instigator.Velocity.Z=-400;
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
            ThirdPersonActor = Spawn(AttachmentClass,Owner);
            InventoryAttachment(ThirdPersonActor).InitFor(self);
        }
        else
            ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;

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
// Functions overriden because Parachutes don't shoot
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
        return;

    if (Instigator.Weapon == self || Instigator.PendingWeapon == self) // this weapon was switched to while waiting for replication, switch to it now
    {
        if (Instigator.PendingWeapon != none)
            Instigator.ChangedWeapon();
        else
            BringUp();
        return;
    }

    if (Instigator.PendingWeapon != none && Instigator.PendingWeapon.bForceSwitch)
        return;

    if (Instigator.Weapon == none)
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if (bPossiblySwitch && !Instigator.Weapon.IsFiring())
    {
        if (PlayerController(Instigator.Controller) != none && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
            return;
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

simulated function bool WeaponAllowSprint()
{
    // Sprinting interrupts the parachute un/deploy animation, so disallow it
    return false;
}

simulated event ClientStartFire(int Mode)
{
    // Don't fire parachute
    return;
}

simulated event StopFire(int Mode)
{
    // Don't fire parachute
    return;
}

simulated exec function ROManualReload()
{
    // Can't reload parachute
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
