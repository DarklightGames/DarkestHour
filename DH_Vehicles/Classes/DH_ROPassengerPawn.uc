//==============================================================================
// DH_ROPassengerPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for Darkest Hour Passenger Pawns - sets rotation, bailing dmg, etc
//==============================================================================
class DH_ROPassengerPawn extends ROPassengerPawn;


// Overridden to set passenger exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    Super.ClientKDriverLeave(PC);
}

// Overridden to give players the same momentum as their vehicle had when exiting
// Adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;
    local bool   bSuperDriverLeave;

    if (!bForceLeave)
    {
        OldVel = VehicleBase.Velocity;

        bSuperDriverLeave = Super.KDriverLeave(bForceLeave);

        OldVel.Z += 50;
        Instigator.Velocity = OldVel;

        return bSuperDriverLeave;
    }
    else
        Super.KDriverLeave(bForceLeave);
}

// Overridden to stop the game playing silly buggers with exit positions while moving and breaking my damage code
function bool PlaceExitingDriver()
{
    local int i;
    local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

    Extent = Driver.default.CollisionRadius * vect(1,1,0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0,0,0.5);

    //avoid running driver over by placing in direction perpendicular to velocity
/*  if (VehicleBase != none && VSize(VehicleBase.Velocity) > 100)
    {
        tryPlace = Normal(VehicleBase.Velocity cross vect(0,0,1)) * (VehicleBase.CollisionRadius * 1.25);
        if (FRand() < 0.5)
            tryPlace *= -1; //randomly prefer other side
        if ((VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location + tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location + tryPlace + ZOffset))
             || (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location - tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location - tryPlace + ZOffset)))
            return true;
    }*/

    for(i=0; i<ExitPositions.Length; i++)
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

function bool TryToDrive(Pawn P)
{
    if (VehicleBase != none)
    {
        if (VehicleBase.NeedsFlip())
        {
            VehicleBase.Flip(vector(P.Rotation), 1);

            return false;
        }

        if (P.GetTeamNum() != VehicleBase.VehicleTeam)
        {
            if (VehicleBase.Driver == none)
            {
                return VehicleBase.TryToDrive(P);
            }

            DenyEntry( P, 1 );

            return false;
        }

        if (VehicleBase.Driver == none && !P.IsHumanControlled())
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    return super(Vehicle).TryToDrive(P);
}

defaultproperties
{
     WeaponFov=80.000000
     bSinglePositionExposed=true
     bAllowViewChange=false
     bDesiredBehindView=false
     DriverDamageMult=1.000000
     bKeepDriverAuxCollision=true
}
