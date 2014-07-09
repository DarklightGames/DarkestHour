//=====================================================
// DH_PistolFire
// started by Antarian 8/28/03
//
// Copyright (C) 2003 Jeffrey Nakai
//
// class that holds Pistol Firing properties
//	subclasses just contain default props
//=====================================================

class DH_PistolFire extends DH_ProjectileFire;

var 		name 		FireLastAnim;        	// anim for weapon firing last shot
var 		name 		FireIronLastAnim;       // anim for weapon firing last shot

function PlayFiring()
{
	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if( Weapon.bUsingSights && Weapon.HasAnim(FireIronLoopAnim))
			{
			 	Weapon.PlayAnim(FireIronLoopAnim, FireAnimRate, 0.0);
			}
			else
			{
				if ( Weapon.HasAnim(FireLoopAnim) )
				{
					Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
				}
				else
				{
					Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
				}
			}
		}
		else
		{
			if( Weapon.bUsingSights )
			{
			 	if( Weapon.AmmoAmount(ThisModeNum) < 1 )
			 	{
				 	Weapon.PlayAnim(FireIronLastAnim, FireAnimRate, FireTweenTime);
				}
				else
				{
					Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
				}
			}
			else
			{
			 	if( Weapon.AmmoAmount(ThisModeNum) < 1 )
			 	{
				 	Weapon.PlayAnim(FireLastAnim, FireAnimRate, FireTweenTime);
				}
				else
				{
					Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
				}
			}
		}
	}

	Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_None,FireVolume,,,,false);

    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

// Overriden to keep better track of ammo client side for pistol animations
event ModeDoFire()
{
    if (!AllowFire())
        return;

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

        Instigator.DeactivateSpawnProtection();
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
		// This could be dangerous. if we are low on ammo, go ahead and
		// decriment the ammo client side. This will ensure the proper
		// anims play for weapon firing in laggy situations.
		if( Weapon.Role < ROLE_Authority )
		{
	        Weapon.ConsumeAmmo(ThisModeNum, Load);
        }

		if( !bDelayedRecoil )
      		HandleRecoil();

        ShakeView();
        PlayFiring();

        if( !bMeleeMode )
        {
	        if(Instigator.IsFirstPerson() && !bAnimNotifiedShellEjects)
				EjectShell();
	        FlashMuzzleFlash();
	        StartMuzzleSmoke();
        }
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

defaultproperties
{
     PreLaunchTraceDistance=1312.000000
     NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_pistol'
     SmokeEmitterClass=Class'ROEffects.ROPistolMuzzleSmoke'
}
