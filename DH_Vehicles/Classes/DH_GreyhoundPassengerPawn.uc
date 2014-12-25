//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundPassengerPawn extends DH_ROPassengerPawn;

function bool TryToDrive(Pawn P)
{
    if (VehicleBase != none)
    {
        if (VehicleBase.NeedsFlip())
        {
            VehicleBase.Flip(vector(P.Rotation), 1);
            return false;
        }

        if (P.GetTeamNum() != Team)
        {
            if (VehicleBase.Driver == none)
                return VehicleBase.TryToDrive(P);

            VehicleLocked(P);
            return false;
        }
    }

    return super.TryToDrive(P);
}

defaultproperties
{
    PositionInArray=1
    CameraBone="Passenger_attachement"
    DrivePos=(X=5.000000,Y=-2.000000,Z=5.000000)
    DriveAnim="VBA64_driver_idle_close"
    FPCamViewOffset=(X=2.000000,Z=-2.000000)
    VehicleNameString="M8 Armored Car passenger"
    bKeepDriverAuxCollision=false
}
