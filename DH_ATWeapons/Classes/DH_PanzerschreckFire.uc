//=============================================================================
// DH_PanzerschreckFire
//=============================================================================

class DH_PanzerschreckFire extends DH_ProjectileFire;

var 	name		FireIronAnimOne;  		// Iron Fire animation for range setting one
var 	name		FireIronAnimTwo;    	// Iron Fire animation for range setting two
var 	name		FireIronAnimThree;  	// Iron Fire animation for range setting three

var     float       ExhaustDamage;          // Damage caused by exhaust (back blast)
var     float       ExhaustDamageRadius;    // Radius for damage caused by exhaust
var     float       ExhaustMomentumTransfer;   // Momentum from exhaust to inflict on players
var     class<DamageType>	  ExhaustDamageType;    // Damage type for exhaust

event ModeDoFire()
{
	local vector WeapLoc;
	local rotator WeapRot;
	local vector HitLoc, HitNorm, FlameDir, FlameReflectDir;
	local float FlameLen;
	local Actor Other;
	local RODestroyableStaticMesh DestroMesh;

    if ( Instigator.bIsCrawling )
	{
        return;
	}
	else if( Weapon.bUsingSights )		//bCanBipodDeploy) )
	{
		/*
		if ( !Instigator.bIsCrouched && !Instigator.bRestingWeapon )
			return;
		*/

		Super.ModeDoFire();

	    WeapLoc=Weapon.ThirdPersonActor.Location; // Get the location of the bazooka
      	WeapRot=Weapon.ThirdPersonActor.Rotation; // Get the rotation of the bazooka
        FlameDir = Vector(WeapRot); // Set direction of exhaust

        Other = Trace(HitLoc, HitNorm, WeapLoc - FlameDir * 300, WeapLoc, false);
        DestroMesh = RODestroyableStaticMesh(Other);

        // Check if the firer is too close to an object and if so, simulate exhaust spreading out along, and reflecting from, the wall
        // Do not reflect off players or breakable objects like windows
        if( Other != none && DH_Pawn(Other) == none && DestroMesh == none )
        {
        	FlameLen = VSize(HitLoc - WeapLoc); // Exhaust stream length when it hit an object
		    FlameReflectDir = 2 * (HitNorm * FlameDir) * HitNorm - FlameDir; // Vector back towards firer from hit object

          	if( FlameLen < 200 )
           	{
            	Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius * 3, ExhaustDamageType, ExhaustMomentumTransfer, HitLoc + FlameReflectDir * FlameLen / 2 );
            }
         }
         else
             FlameLen = 400; // Didn't hit anything, so exhaust is max length

         if( FlameLen > 100 )
         {
          	Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 100 );
         }

         if( FlameLen > 200 )
         {
          	Weapon.HurtRadius(ExhaustDamage / 2, ExhaustDamageRadius * 2, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 200 );
         }

         if( FlameLen >= 400 )
         {
          	Weapon.HurtRadius(ExhaustDamage / 3, ExhaustDamageRadius * 3, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 300 );
         }

		 DH_PanzerschreckWeapon(Weapon).PostFire();
	}
	else
	{
        return;
	}
}

function PlayFiring()
{
	local name Anim;

	Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_None,FireVolume,,,,false);

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
				switch(DH_PanzerschreckWeapon(Weapon).RangeIndex)
				{
					case 0:
						Anim = FireIronAnimOne;
						break;
					case 1:
						Anim = FireIronAnimTwo;
						break;
					case 2:
						Anim = FireIronAnimThree;
						break;
				}
			 	Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
			}
			else
			{
				Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
			}
		}
	}

//	Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_None,FireVolume,,,,false);

    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     FireIronAnimOne="iron_shoot"
     FireIronAnimTwo="iron_shootMid"
     FireIronAnimThree="iron_shootFar"
     ExhaustDamage=200.000000
     ExhaustDamageRadius=50.000000
     ExhaustMomentumTransfer=100.000000
     ExhaustDamageType=Class'DH_ATWeapons.DH_PanzerschreckExhaustDamType'
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-25.000000)
     AddedPitch=-100
     bUsePreLaunchTrace=False
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.Bazooka.BazookaFire01'
     maxVerticalRecoilAngle=800
     maxHorizontalRecoilAngle=400
     bWaitForRelease=True
     FireAnim="iron_shoot"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.600000
     AmmoClass=Class'DH_ATWeapons.DH_PanzerschreckAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=500.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=7500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_ATWeapons.DH_PanzerschreckRocket'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=2000.000000
     Spread=450.000000
     SpreadStyle=SS_Random
}
