//==============================================================================
// DH_HigginsPassengerPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all Higgins boat passengers
//==============================================================================
class DH_HigginsPassengerPawn extends ROPassengerPawn;

simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

	Super.ClientKDriverLeave(PC);
}

// Overridden from Vehicle.uc to prevent being spawned outside the boat while moving and
// to allow passengers to exit with correct heights and rotations
function bool PlaceExitingDriver()
{
	local int i;
	local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

	Extent = Driver.default.CollisionRadius * vect(1,1,0);
	Extent.Z = Driver.default.CollisionHeight;
	ZOffset = Driver.default.CollisionHeight * vect(0,0,1);

/*	//avoid running driver over by placing in direction perpendicular to velocity
	if (VehicleBase != None && VSize(VehicleBase.Velocity) > 100)
	{
		tryPlace = Normal(VehicleBase.Velocity cross vect(0,0,1)) * (VehicleBase.CollisionRadius * 1.25);
		if (FRand() < 0.5)
			tryPlace *= -1; //randomly prefer other side
		if ( (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location + tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == None && Driver.SetLocation(VehicleBase.Location + tryPlace + ZOffset))
		     || (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location - tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == None && Driver.SetLocation(VehicleBase.Location - tryPlace + ZOffset)) )
			return true;
	}*/

	for(i=0; i<ExitPositions.Length; i++)
	{
		if ( bRelativeExitPos )
		{
		    if (VehicleBase != None)
		    	tryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
		    else if (Gun != None)
                tryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
            else
        	    tryPlace = Location + (ExitPositions[i] >> Rotation);
	    }
		else
			tryPlace = ExitPositions[i];

		// First, do a line check (stops us passing through things on exit).
		if ( bRelativeExitPos )
		{
			if (VehicleBase != None)
			{
				if (VehicleBase.Trace(HitLocation, HitNormal, tryPlace, VehicleBase.Location + ZOffset, false, Extent) != None)
					continue;
			}
			else
				if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != None)
					continue;
		}

		// Then see if we can place the player there.
		if ( !Driver.SetLocation(tryPlace) )
			continue;

		return true;
	}
	return false;
}

defaultproperties
{
     HudName="Passenger"
     DriverHudName="Coxswain"
     bAllowViewChange=False
     bDesiredBehindView=False
     VehiclePositionString="in a Higgins Boat"
     VehicleNameString="Higgins Boat passenger"
}
