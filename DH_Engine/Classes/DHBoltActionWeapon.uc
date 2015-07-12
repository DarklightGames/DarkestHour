//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBoltActionWeapon extends DHProjectileWeapon
    abstract;

// Modified to prevent reloading unless the weapon is out of ammo
simulated function bool AllowReload()
{
    if (AmmoAmount(0) <= 0)
    {
        return super.AllowReload();
    }
}

// Modified to work the bolt when fire is pressed, if weapon is waiting to bolt
simulated function Fire(float F)
{
    if (bWaitingToBolt && !IsBusy())
    {
        WorkBolt();
    }
    else
    {
        super.Fire(F);
    }
}

// Work the bolt
simulated function WorkBolt()
{
    if (!bWaitingToBolt || AmmoAmount(0) < 1 || FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))
    {
        return;
    }

    GotoState('WorkingBolt');

    if (Role < ROLE_Authority)
    {
        ServerWorkBolt();
    }
}

// Server side function called to work the bolt on the server
function ServerWorkBolt()
{
    WorkBolt();
}

// State where the bolt is being worked
simulated state WorkingBolt extends WeaponBusy
{
    simulated function bool ShouldUseFreeAim()
    {
        return global.ShouldUseFreeAim();
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    // Overridden to support playing proper anims after bolting
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            if (Anim == BoltIronAnim || Anim == BoltHipAnim)
            {
                bWaitingToBolt = false;
            }
        }

        super.AnimEnd(Channel);

        GotoState('Idle');
    }

    simulated function BeginState()
    {
        if (bUsingSights)
        {
            PlayAnimAndSetTimer(BoltIronAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BoltHipAnim, 1.0, 0.1);
        }

        // Play the animation on the pawn
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBoltAction();
        }
    }

    simulated function EndState()
    {
        bWaitingToBolt = false;
        FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; // ready to fire fire now
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
    GotoState('PostFiring');
}

// State where the weapon has just been fired
simulated state PostFiring
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function Timer()
    {
        if (!Instigator.IsHumanControlled())
        {
            if (AmmoAmount(0) > 0)
            {
                GotoState('WorkingBolt');
            }
            else
            {
               GotoState('Reloading');
            }
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        bWaitingToBolt = true;

        if (bUsingSights && DHProjectileFire(FireMode[0]) != none)
        {
            SetTimer(GetAnimDuration(DHProjectileFire(FireMode[0]).FireIronAnim, 1.0), false);
        }
        else
        {
            SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
        }
    }
}

// Modified so bots don't go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

defaultproperties
{
    BobDamping=0.8
    FreeAimRotationSpeed=6.0
    bCanAttachOnBack=true
    SwayModifyFactor=0.4
    BobModifyFactor=0.12
    bSniping=true
}
