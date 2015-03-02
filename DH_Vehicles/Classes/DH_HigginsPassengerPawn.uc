//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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

    for(i = 0; i<ExitPositions.Length; i++)
    {
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
                tryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
            else if (Gun != none)
                tryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
            else
                tryPlace = Location + (ExitPositions[i] >> Rotation);
        }
        else
            tryPlace = ExitPositions[i];

        // First, do a line check (stops us passing through things on exit).
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
            {
                if (VehicleBase.Trace(HitLocation, HitNormal, tryPlace, VehicleBase.Location + ZOffset, false, Extent) != none)
                    continue;
            }
            else
                if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
                    continue;
        }

        // Then see if we can place the player there.
        if (!Driver.SetLocation(tryPlace))
            continue;

        return true;
    }
    return false;
}

defaultproperties
{
     HudName="Passenger"
     DriverHudName="Coxswain"
     bAllowViewChange=false
     bDesiredBehindView=false
     VehiclePositionString="in a Higgins Boat"
     VehicleNameString="Higgins Boat passenger"
}

