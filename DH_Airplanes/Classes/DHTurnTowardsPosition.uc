//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Turns the plane until it's velocity points at the PositionGoal. Useful for
// aligning the plane with a target.
// The GOAL is to be aligned with the PositionGoal.
//-----------------------------------------------------------
class DHTurnTowardsPosition extends DHMoveState;

var float TurnRadius;       // Radius of circular turn.
var bool bIsTurningRight;   // Is this a right turn?
var vector PositionGoal;    // When the plane's velocity is aligned with this position, end the turn.
var bool bIsInitialized;    // keeps track if the initialization has been automatically preformed.
var vector TurnEndPoint;    // Point in world space that the plane should be at when the turn ends.

simulated function Tick(float DeltaTime)
{
    local vector TangentVelocity;
    local float TimeToBankBack;
    local float BankBackAngle;

    // Find the Turn End Point. This also sets the TangentAngle, so that we can detect the turn end.
    if (!bIsInitialized)
    {
        Log("Start Turn Towards Position");
        TurnEndPoint = CalculateTurnEndPoint(PositionGoal, Airplane.Velocity, Airplane.Location, bIsTurningRight, TurnRadius);
        TurnEndPoint.Z = Airplane.Location.Z;

        bIsInitialized = true;
    }

    UpdateSpeed(DeltaTime);

    TurnPlane(bIsTurningRight, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    //Log(Airplane.BankAngle$", "$Airplane.MaxBankAngle);

    TimeToBankBack = Abs(Airplane.BankAngle) / Airplane.BankRate;
    BankBackAngle = TangentAngle - ((TimeToBankBack * Airplane.CurrentSpeed) / TurnRadius);

    // Bank to max bank.
    if (Abs(Airplane.BankAngle) < class'UUnits'.static.DegreesToRadians(Airplane.MaxBankAngle) && TotalTurned <= BankBackAngle)
    {
        if (bIsTurningRight)
        {
            Airplane.BankAngle += DeltaTime * Airplane.BankRate;
        }
        else
        {
            Airplane.BankAngle -= DeltaTime * Airplane.BankRate;
        }
    }
    // Start banking back to 0, normal flight roll.
    else if (Abs(Airplane.BankAngle) > 0 && TotalTurned > BankBackAngle)
    {
        if (bIsTurningRight)
        {
            Airplane.BankAngle -= DeltaTime * Airplane.BankRate;

            if (Airplane.BankAngle < 0)
            {
                Airplane.BankAngle = 0;
            }
        }
        else
        {
            Airplane.BankAngle += DeltaTime * Airplane.BankRate;

            if(Airplane.BankAngle > 0)
            {
                Airplane.BankAngle = 0;
            }
        }
    }

    // Test if the TurnEndPoint has been passed. If so, set to proper endpoint and end the turn.
    if(TotalTurned >= TangentAngle)
    {
        TangentVelocity = PositionGoal - TurnEndPoint;
        TangentVelocity.Z = 0;
        TangentVelocity = Normal(TangentVelocity);

        TurnEndPoint.Z = Airplane.Location.Z;

        Log("End Turn Towards Position: "$TurnEndPoint);
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.BankAngle = 0;
        Airplane.OnMoveEnd(); // tell Airplane that move is done.
    }
}

DefaultProperties
{

}
