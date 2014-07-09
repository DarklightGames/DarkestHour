//=============================================================================
// DH_BoltActionWeapon
//=============================================================================
// Base class for bolt action rifles
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_BoltActionWeapon extends DH_ProjectileWeapon
	abstract;


// Overriden because we don't want to allow reloading unless the weapon is out of
// ammo
simulated function bool AllowReload()
{
    if( AmmoAmount(0) > 0 )
    {
		return false;
	}

	return super.AllowReload();
}

// Work the bolt when fire is pressed
simulated function Fire(float F)
{
	super.Fire(F);

	if( IsBusy() || !bWaitingToBolt )
		return;

	WorkBolt();
}

// Work the bolt
simulated function WorkBolt()
{
	if( !bWaitingToBolt || AmmoAmount(0) < 1 || FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking') )
		return;

	GotoState('WorkingBolt');

	if( Role < ROLE_Authority)
		ServerWorkBolt();

}

// Server side function called to work the bolt on the server
function ServerWorkBolt()
{
 	WorkBolt();
}

//State where the bolt is being worked
simulated state WorkingBolt extends Busy
{
	simulated function bool ReadyToFire(int Mode)
	{
		return false;
	}

	simulated function bool WeaponAllowSprint()
	{
		return false;
	}

	simulated function bool CanStartCrawlMoving()
	{
		return false;
	}

    simulated function Timer()
    {
		if( Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0 )
			GotoState('StartCrawling');
		else
			GotoState('Idle');
    }

	// Overriden to support playing proper anims after bolting
	simulated function AnimEnd(int channel)
	{
	    local name anim;
	    local float frame, rate;

	    GetAnimParams(0, anim, frame, rate);

		if( Instigator.IsLocallyControlled() && ( anim == BoltIronAnim || anim == BoltHipAnim ))
		{
			bWaitingToBolt = false;
		}

	    super.AnimEnd(channel);
		if( Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0 )
			GotoState('StartCrawling');
		else
			GotoState('Idle');
	}

    simulated function BeginState()
    {
		local name Anim;
		local float BoltWaitTime;

		if( bUsingSights )
		{
			Anim = BoltIronAnim;
		}
		else
		{
			Anim = BoltHipAnim;
		}

		if( Instigator.IsLocallyControlled() )
		{
	    	PlayAnim(Anim, 1.0, FastTweenTime );
		}

		// Play the animation on the pawn
		if( Role == ROLE_Authority )
		{
			ROPawn(Instigator).HandleBoltAction();
		}

    	BoltWaitTime = GetAnimDuration(Anim, 1.0) + FastTweenTime;

		if( Instigator.IsLocallyControlled() )
		{
	    	SetTimer(BoltWaitTime,false);
	    }
	    else
	    {
	    	// Let the server set the bWaitingToBolt to false a little sooner than the client
	    	// Since the client can't attempt to fire until he is done bolting, this will
	    	// help alleviate situations where the client finishes bolting before the
	    	// server registers the bolting as finished
			BoltWaitTime = BoltWaitTime - ( BoltWaitTime * 0.1 );
			SetTimer(BoltWaitTime,false);
	    }
	}

    simulated function EndState()
    {
    	bWaitingToBolt=false;
    	FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; //fire now!
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
 	GotoState('PostFiring');
}

// Don't want to go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
	super(ROWeapon).OutOfAmmo();
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
		if( !Instigator.IsHumanControlled() )
		{
			if( AmmoAmount(0) > 0 )
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
	    bWaitingToBolt=true;
	    if( bUsingSights )
	    {
	    	SetTimer(GetAnimDuration(DH_ProjectileFire(FireMode[0]).FireIronAnim, 1.0),false);
	    }
	    else
	    {
	    	SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0),false);
	    }
    }
}

defaultproperties
{
     FreeAimRotationSpeed=6.000000
     bCanAttachOnBack=True
}
