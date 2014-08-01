// class: DHMinefield_ATMine
// Auther: Theel
// Date: 2-06-10
// Purpose:
// A new mine that only explodes on vehicles and can damage them (large tanks often detracts)
// Problems/Limitations:
// none known

class DHMinefield_ATMine extends ROMine;

//Overridden to explode on vehicles only
singular function Touch(Actor Other)
{
	local int 	RandomNum;

	if (Pawn(Other) == none || Vehicle(Other) == none)
		return;

	if (Role == ROLE_Authority)
	{
		//Hurt the vehicle itself
		Other.TakeDamage(Damage, none, Location, Location, MyDamageType);

		//Lets possibly detract the vehicle (80% chance)
		RandomNum = Rand(101);
		if (DH_ROTreadCraft(Other) != none && RandomNum <= 80)
		{
			if (vector(Other.Rotation) dot Normal(Location - Other.Location) > 0)
				DH_ROTreadCraft(Other).DamageTrack(true);
			else
			    DH_ROTreadCraft(Other).DamageTrack(false);
		}

		//Hurt other around it
		HurtRadius(Damage, DamageRadius, MyDamageType, Momentum, Location);
		SetCollision(false, false, false);
	}

	SpawnExplosionEffects();
}

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local actor Victims, LastTouched;
	local float damageScale, dist;
	local vector dir;

	// Antarian 9/12/2004
	local vector TraceHitLocation,
				 TraceHitNormal;
	local actor	 TraceHitActor;


	if (bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if ((Victims != self) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo'))
		{
			// if there's a vehicle between the player and explosion, don't apply damage
			TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, Location);
			if ((Vehicle(TraceHitActor) != none) && (TraceHitActor != Victims))
				continue;
			// end of Antarian's 9/12/2004 contribution

			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if (Victims == LastTouched)
				LastTouched = none;
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);

		}
	}
	if ((LastTouched != none) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo'))
	{
		Victims = LastTouched;
		LastTouched = none;
		dir = Victims.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir/dist;
		damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
		if (Instigator == none || Instigator.Controller == none)
			Victims.SetDelayedDamageInstigatorController(Instigator.Controller);
		Victims.TakeDamage
		(
			damageScale * DamageAmount,
			Instigator,
			Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
			(damageScale * Momentum * dir),
			DamageType
		);
		if (Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
	}

	bHurtEntry = false;
}

defaultproperties
{
     Damage=525
     DamageRadius=512
     MyDamageType=Class'DH_LevelActors.DHATMineDamage'
     Momentum=3000
     bHidden=true
}
