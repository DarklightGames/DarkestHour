//==============================================================================
// DH_GreyhoundCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M8 'Greyhound' Armored Car cannon
//==============================================================================
class DH_GreyhoundCannonFixed extends DH_GreyhoundCannon;

state ProjectileFireMode
{
	function Fire(Controller C)
	{
		local int SpawnCount, projectileID;
		local rotator R;
		local vector X;

        //Level.Game.Broadcast(self, "ProjectileClass:"@ProjectileClass);

		if(ProjectileClass == TertiaryProjectileClass)
		{
			SpawnCount = ProjPerFire;// DH_TankCannonShellCanister.ProjPerFire;

			X = vector(WeaponFireRotation);

			for (projectileID = 0; projectileID < SpawnCount; projectileID++)
			{
				R.Yaw = CSpread * (FRand()-0.5);
				R.Pitch = CSpread * (FRand()-0.5);
				R.Roll = CSpread * (FRand()-0.5);

				WeaponFireRotation = Rotator(X >> R);

				if( projectileID == 0 )
					bLastShot = False;
				if( projectileID == SpawnCount - 1)
					bLastShot = True;

				if(bGunFireDebug)
					log("Firing Canister shot with angle: "@WeaponFireRotation);

                //Debug fix
				//Level.Game.Broadcast(self, "Spawning projectile:"@WeaponFireRotation);

				SpawnProjectile(ProjectileClass, False);
			}
		}
		else
		{
	        //Level.Game.Broadcast(self, "Spawning projectile in else:"@WeaponFireRotation);
	        SpawnProjectile(ProjectileClass, False);
		}
	}

	function AltFire(Controller C)
	{
 		if (AltFireProjectileClass == None)
			Fire(C);
		else
			SpawnProjectile(AltFireProjectileClass, True);
	}
}

defaultproperties
{
	TertiaryProjectileClass=Class'DH_Vehicles.DH_TankCannonShellCanisterAmerican'
}

