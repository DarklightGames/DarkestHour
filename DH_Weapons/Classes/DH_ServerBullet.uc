//=============================================================================
// DH_ServerBullet
//=============================================================================
// bullets that do penetrate walls
//=============================================================================
// Infiltration community addition
// Copyright (C) 1999-2006 geogob and Sentry Studios (mainly Beppo)
// Added to DarkestHour with permission, by PsYcH0_Ch!cKeN
//=============================================================================
class DH_ServerBullet extends ROServerBullet
    config(DH_Penetration)
	abstract;

var bool bInHitWall;

var float MaxWall;		// Maximum wall penetration
var float WScale;		// Penetration depth scale factor to take into account; weapon scale
var float Hardness;		// wall hardness, calculated in CheckWall for surface type

var globalconfig float 	PenetrationScale;	// global Penetration depth scale factor
var globalconfig float 	DistortionScale;	// global Distortion scale factor
var globalconfig bool 	bDebugMode;			// If true, give our detailed report in log.
var globalconfig bool 	bDebugROBallistics;	// If true, set bDebugBallistics to true for getting the arrow pointers

var int WhizType;
// WhizType
// 0 = none
// 1 = close supersonic bullet
// 2 = subsonic or distant bullet

simulated function PostBeginPlay()
{
	if ( bDebugROBallistics )
		bDebugBallistics = True;

	Super.PostBeginPlay();
}

/*simulated function HitWall(vector HitNormal, actor Wall)
{
	local float tmpWallDiff, tmpMaxWall;
	local vector TmpHitLocation, TmpHitNormal, X,Y,Z, LastLoc;
	local float xH,EnergyFactor;
	local rotator distortion;
	local actor tmpHit;

	local ROVehicleHitEffect VehEffect;
    local RODestroyableStaticMesh DestroMesh;

   // Check to prevent recursive calls
	if (bInHitWall)
		return;

	LastLoc = Location;


	// original ROBullet codes
	if ( WallHitActor != none && WallHitActor == Wall)
	{
		return;
	}
	WallHitActor = Wall;

    DestroMesh = RODestroyableStaticMesh(Wall);

	if(bDebugMode) log(">>>> Projectile HitWall:"@self);

	if (Role == ROLE_Authority)
	{
		// Have to use special damage for vehicles, otherwise it doesn't register for some reason - Ramm
		if( ROVehicle(Wall) != none )
		{
			if(bDebugMode) log("Hit: Vehicle");
			Wall.TakeDamage(Damage - 20 * (1 - VSize(Velocity) / default.Speed), instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
		}
		else if ( Mover(Wall) != None || DestroMesh != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
		{
			if(bDebugMode) log("Hit: Mover");
			Wall.TakeDamage(Damage - 20 * (1 - VSize(Velocity) / default.Speed), instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
		MakeNoise(1.0);
	}

	if( ROVehicle(Wall) != none)
	{
		if (Level.NetMode != NM_DedicatedServer)
		{
			VehEffect = Spawn(class'ROVehicleHitEffect',,, Location, rotator(-HitNormal));
			VehEffect.InitHitEffects(Location,HitNormal);
 		}
	}
	// Spawn the bullet hit effect client side
	else if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
	{
		Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
	}

	super(ROBallisticProjectile).HitWall(HitNormal, Wall);

	// Don't want to destroy the bullet if its going through something like glass
    if( DestroMesh != none && DestroMesh.bWontStopBullets )
    {
    	return;
    }

	// Give the bullet a little time to play the hit effect client side before destroying the bullet
	// due to the possible penetration we cannot let the dedicated server version of it vanish into thin air
//     if (Level.NetMode == NM_DedicatedServer)
//     {
//     	bCollided = true;
//     	SetCollision(False,False);
//     }
//     else
//     {
//     	Destroy();
//	   }

    //////////////////////////////////////////////////////////////////
	// End of original ROBullet codes
	//

	bInHitWall = True;

	if(bDebugMode) log("HitWall - Starting Penetration Check");

	GetAxes(Rotation,X,Y,Z);

	// Do the Max Wall Calculations
	CheckWall(HitNormal,X);
	xH = 1/Hardness;
	EnergyFactor = (0.001*Vsize(Velocity))**2;
	MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

	if(bDebugMode) log("INFO - Velocity:"@Vsize(Velocity)@Velocity@" N "@Normal(Velocity)@" NRG Factor"@EnergyFactor@" MaxWall:"@MaxWall);

	// due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
	if ( MaxWall > 16) {
		do {
			if ( (tmpMaxWall + 16) <= MaxWall )
				tmpMaxWall += 16;
			else
				tmpMaxWall = MaxWall;
			tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * tmpMaxWall,False);

			if(bDebugMode) log("in do-while - tmpMaxWall:"@tmpMaxWall@" tmpHit:"@tmpHit);

			// due to StaticMeshs resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return None)
			if ( (tmpHit != None) && !SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)) )
				tmpHit = None;

		} until ( (tmpHit != None) || (tmpMaxWall >= MaxWall) );
	}
	else {
		tmpHit = Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * MaxWall,False);
		if(bDebugMode) log("MaxWall <= 16 - MaxWall:"@MaxWall@" tmpHit:"@tmpHit);
	}

	if(bDebugMode) log("MaxWall:"@MaxWall@" tmpHit:"@tmpHit@" TmpHitLocation:"@TmpHitLocation@" TmpHitNormal:"@TmpHitNormal);

//	if (Trace(TmpHitLocation,TmpHitNormal,Location,Location + X * MaxWall,False) != None)
	if (tmpHit != None)
	{
		if (SetLocation(TmpHitLocation + (vect(0.5,0,0) * X)))
		{
			if (Role == ROLE_Authority)
			{
				tmpWallDiff = VSize(LastLoc - Location) / 2.0;
				MaxWall -= tmpWallDiff;
				tmpWallDiff /= 100.0;

				// material dependant damage, velocity and direction changes
				if ( (tmpWallDiff * 2.0 * (1 + Hardness / 4)) < 1.0 )
					Damage *= 1.0 - tmpWallDiff * 2.0 * (1 + Hardness / 4);
				else
					Damage *= 0.01;

				if ( (tmpWallDiff * (1 + Hardness / 2)) < 1.0 )
					Velocity *= 1.0 - tmpWallDiff * (1 + Hardness / 2);
				else
					Velocity *= 0.01;

				// would result in about 20° max for a hardness of 5 and around 2° max for a hardness of .5
				if ( DistortionScale > 0.0 ) {
					distortion.Yaw = 3000 * Hardness / 2 * (FRand()-0.5);
            		distortion.Pitch = 3000 * Hardness / 2 * (FRand()-0.5);
            		distortion.Roll = 3000 * Hardness / 2 * (FRand()-0.5);
					Velocity = Velocity >> (distortion * DistortionScale);
				}

				if(bDebugMode) log("INFO - resulting Velocity:"@Vsize(Velocity)@Velocity@" N "@Normal(Velocity)@" resulting Damage"@Damage@" resulting MaxWall:"@MaxWall@" tmpWallDiff:"@tmpWallDiff@" Hardness:"@Hardness@" distortion"@distortion);
			}

			// spawn an impact effect on the backside of the wall too
			if( ROVehicle(tmpHit) != none)
			{
				if (Level.NetMode != NM_DedicatedServer)
				{
					VehEffect = Spawn(class'ROVehicleHitEffect',,, TmpHitLocation, rotator(-TmpHitNormal));
					VehEffect.InitHitEffects(TmpHitLocation,TmpHitNormal);
 				}
			}
			else if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
			{
				Spawn(ImpactEffect,,, TmpHitLocation, rotator(-TmpHitNormal));
			}

			bInHitWall = False;

			if ( MaxWall < 1.0 ) {
				if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 				if (Level.NetMode == NM_DedicatedServer) {
					bCollided = true;
					SetCollision(False,False);
 				}
 				else {
					Destroy();
 				}
			}
		}
		else {
			if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 			if (Level.NetMode == NM_DedicatedServer) {
				bCollided = true;
				SetCollision(False,False);
 			}
 			else {
				Destroy();
 			}
		}
	}
	else {
		if(bDebugMode) log(">>>> Projectile - destroy:"@self);
 		if (Level.NetMode == NM_DedicatedServer) {
			bCollided = true;
			SetCollision(False,False);
 		}
 		else {
			Destroy();
 		}
    }
}

simulated function CheckWall(vector HitNormal, vector X)
{
	local Material HitMaterial;
	local ESurfaceTypes HitSurfaceType;
	local vector cTmpHitLocation, cTmpHitNormal;

	Trace(cTmpHitLocation, cTmpHitNormal, Location, Location + X*16, false,, HitMaterial);

	if (HitMaterial != None)
		HitSurfaceType = ESurfaceTypes(HitMaterial.SurfaceType);
	else
		HitSurfaceType = EST_Default;

	switch ( HitSurfaceType )
	{
		case EST_Default :
			Hardness = 0.7;
			break;
		case EST_Rock :
//			Hardness = 2.0;
			Hardness = 2.5;
			break;
		case EST_Metal :
//			Hardness = 8.0; // too much
			Hardness = 4.0;
			break;
		case EST_Wood :
			Hardness = 0.5;
			break;
		case EST_Plant :
			Hardness = 0.1;
			break;
		case EST_Flesh :
			Hardness = 0.2;
			break;
		case EST_Ice :
//			Hardness = 1.0;
			Hardness = 0.8;
			break;
		case EST_Snow :
			Hardness = 0.1;
			break;
		case EST_Water :
			Hardness = 0.1;
			break;
		case EST_Glass :
			Hardness = 0.3;
			break;
		case EST_Gravel :
			Hardness = 0.4;
			break;
		case EST_Concrete :
			Hardness = 2.0;
			break;
		case EST_HollowWood :
			Hardness = 0.3;
			break;
		case EST_MetalArmor :
//			Hardness = 16.0;
			Hardness = 10.0;
			break;
		case EST_Paper :
			Hardness = 0.2;
			break;
		case EST_Cloth :
			Hardness = 0.3;
			break;
		case EST_Rubber :
			Hardness = 0.2;
			break;
		case EST_Poop :
			Hardness = 0.1;
			break;
		default:
			Hardness = 0.5;
			break;
	}

	if(bDebugMode) log("Hit Surface type:"@HitSurfaceType@"with hardness of"@Hardness);

	return;
}*/

// original
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local Vector X, Y, Z;
	local float	V;
	local bool	bHitWhipAttachment;
	local ROVehicleHitEffect VehEffect;
	local ROPawn HitPawn;

	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;

	local float BulletDist;

//	local ROBulletWhipAttachment ROWhip;


	if ( bDebugMode && Pawn(Other) != None ) {
		if ( instigator != None )
			instigator.ClientMessage("ProcessTouch"@Other@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health@"Velocity"@VSize(Velocity));
		Log(self@" >>> ProcessTouch"@Pawn(Other).PlayerReplicationInfo.PlayerName@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health@"Velocity"@VSize(Velocity));
	}

	if(bDebugMode) log(">>>"@Other@"=="@Instigator@"||"@Other.Base@"=="@Instigator@"||"@!Other.bBlockHitPointTraces);

//	Super.ProcessTouch(Other, HitLocation);
	//>>>>
	if (Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces )
		return;
	if(bDebugMode) log(">>> ProcessTouch 3");

    if ( Level.NetMode != NM_DedicatedServer )
    {
		if( ROVehicleWeapon(Other) != none && !ROVehicleWeapon(Other).HitDriverArea(HitLocation, Velocity))
		{
			VehEffect = Spawn(class'ROVehicleHitEffect',,, HitLocation, rotator(Normal(Velocity)) /*rotator(-HitNormal)*/);
			VehEffect.InitHitEffects(HitLocation,Normal(-Velocity));
		}
	}

	V = VSize(Velocity);

	if(bDebugMode) log(">>> ProcessTouch 4"@Other);

	if ( bDebugMode && Pawn(Other) != None ) {
		if ( instigator != None )
			instigator.ClientMessage("ProcessTouch Velocity"@VSize(Velocity)@Velocity);
		Log(self@" >>> ProcessTouch Velocity"@VSize(Velocity)@Velocity);
	}

	// If the bullet collides right after launch, it doesn't have any velocity yet.
	// Use the rotation instead and give it the default speed - Ramm
	if( V < 25 )
	{
		if(bDebugMode) log(">>> ProcessTouch 5a ... V < 25");
		GetAxes(Rotation, X, Y, Z);
		V=default.Speed;
	}
	else
	{
		if(bDebugMode) log(">>> ProcessTouch 5b ... GetAxes");
	  	GetAxes(Rotator(Velocity), X, Y, Z);
	}

 	if( ROBulletWhipAttachment(Other) != none )
	{
		if(bDebugMode) log(">>> ProcessTouch ROBulletWhipAttachment ... ");
    	bHitWhipAttachment=true;

        if(!Other.Base.bDeleteMe)
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure)
            // Lets check against the firer's location instead
            if( OrigLoc == Vect(0.00,0.00,0.00) )
                OrigLoc = Instigator.Location;

            BulletDist = VSize(Location - OrigLoc) / 60.352; // Calculate distance travelled by bullet in metres

            // If it's FF at close range, we won't suppress, so send a different WT through
            if( BulletDist < 10.0 && Instigator.Controller.SameTeamAs(DH_Pawn(Other.Base).Controller) )
                WhizType = 3;

            if( (BulletDist < 20.0) && WhizType == 1 ) // Bullets only "snap" after a certain distance in reality, same goes here
            {
                WhizType = 2;
            }

	        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, WhizType);   //1
//	        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (10000 * X), HitPoints, HitLocation,, WhizType);
		if(bDebugMode) log(">>> ProcessTouch HitPointTrace ... "@Other);

			if( Other == none )
			{
				WhizType = default.WhizType; // Reset for the next collision
                return;
			}

			HitPawn = DH_Pawn(Other);
		}
		else
		{
			return;
		}
	}

	if(bDebugMode) log(">>> ProcessTouch MinPenetrateVelocity ... "@V@">"@(MinPenetrateVelocity * ScaleFactor));
	if (V > MinPenetrateVelocity * ScaleFactor)
	{
        if (Role == ROLE_Authority)
        {
	    	if ( HitPawn != none )
	    	{
 				// Hit detection debugging
				/*log("Bullet hit "$HitPawn.PlayerReplicationInfo.PlayerName);
				HitPawn.HitStart = HitLocation;
				HitPawn.HitEnd = HitLocation + (65535 * X);*/
				if(bDebugMode) log(">>> ProcessTouch ProcessLocationalDamage ... "@HitPawn);

                if( !HitPawn.bDeleteMe )
                	HitPawn.ProcessLocationalDamage(Damage - 20 * (1 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);

                // Hit detection debugging
				//if( Level.NetMode == NM_Standalone)
				//	HitPawn.DrawBoneLocation();

				 bHitWhipAttachment = false;
	    	}
	    	else
	    	{
				if(bDebugMode) log(">>> ProcessTouch Other.TakeDamage ... "@Other);
				Other.TakeDamage(Damage - 20 * (1 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
			}
		}
		else
		{
			if(bDebugMode) log(">>> ProcessTouch Nothing cClientside... ");

	    	if ( HitPawn != none )
	    	{
		        bHitWhipAttachment = false;
	    	}
        }
	}
	//>>>>

	if ( bDebugMode && Pawn(Other) != None ) {
		if ( instigator != None )
			instigator.ClientMessage("result ProcessTouch"@Other@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health);
		Log(self@" >>> result ProcessTouch"@Pawn(Other).PlayerReplicationInfo.PlayerName@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health);
	}

     if( !bHitWhipAttachment )
		Destroy();

}

defaultproperties
{
     WScale=1.000000
     PenetrationScale=0.080000
     DistortionScale=0.400000
     WhizType=1
}
