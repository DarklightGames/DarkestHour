//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DHTurnTowardsPosition extends DHMoveState;

var float TurnRadius;
var float TurnSpeed;
var bool bIsTurningRight;
var vector PositionGoal;
var bool bIsInitialized;
var float TangentAngle;
var vector TurnEndPoint;


function Tick(float DeltaTime)
{

    local vector OldLocation, OldVelocity;
    local vector TangentVelocity;
    local vector PerpendicularToTangent;
    local float OldVelocityAngle, CurrentVelocityAngle, TangentVelocityAngle;
    local vector Point, Result;

    /*
    //Point = vect(-1414.213, 0, 0);
    //Point = vect(-1000, -1000, 0);
    Result = CalculateClosestTangentPoint(Point, 1000, false);
    Log("End: "$Result);
    return;
    */

    PositionGoal.Z = 0;

    if (!bIsInitialized)
    {
        TurnEndPoint = CalculateTurnEndPoint(PositionGoal, Airplane.Velocity, Airplane.Location, bIsTurningRight, TurnRadius);
        TurnEndPoint.Z = 0;

        bIsInitialized = true;
    }



    OldLocation = Airplane.Location;
    OldVelocity = Airplane.Velocity;

    TurnPlane(bIsTurningRight, TurnRadius, Airplane.CurrentSpeed, DeltaTime);
    //Result = CalculateClosestTangentPoint(vect(1, 1, 0), 1, true);


    TangentVelocity = Normal(PositionGoal - TurnEndPoint);
    TangentVelocity.Z = 0;
    TangentVelocity = Normal(TangentVelocity);
    //Log("Tan Velo: "$TangentVelocity);

    OldVelocityAngle = Atan(Normal(OldVelocity).Y, Normal(OldVelocity).X);
    if (bIsTurningRight)
        OldVelocityAngle = Pi - OldVelocityAngle;

    // Log("OldVelocityAngle: "$OldVelocityAngle);

    CurrentVelocityAngle = Atan(Normal(Airplane.Velocity).Y, Normal(Airplane.Velocity).X);

    //Log("Total Turned: "$TotalTurned);

    if(bIsTurningRight)
       CurrentVelocityAngle = Pi - CurrentVelocityAngle;

    CurrentVelocityAngle -= OldVelocityAngle;

    if (CurrentVelocityAngle < 0)
        CurrentVelocityAngle += 2*Pi;

    //Log("CurrentVelocityAngle: "$CurrentVelocityAngle);

    TangentVelocityAngle = Atan(TangentVelocity.Y, TangentVelocity.X);

    if(bIsTurningRight)
        TangentVelocityAngle = Pi - TangentVelocityAngle;

    TangentVelocityAngle -= OldVelocityAngle;

    if (TangentVelocityAngle < 0)
        TangentVelocityAngle += 2*Pi;

    //Log("TangentPost: "$TangentVelocityAngle);

    //if ((!bIsTurningRight && CurrentVelocityAngle <= TangentVelocityAngle) || (bIsTurningRight && CurrentVelocityAngle <= TangentVelocityAngle))
    if(TotalTurned >= TangentAngle)
    {
        Log("End Reached");
        TurnEndPoint.Z = Airplane.Location.Z;
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.OnMoveEnd();
    }
}

function vector CalculateTurnEndPoint(vector WorldGoal, vector CurrentVelocity, vector CurrentPlanePosition, bool bIsClockwise, float TurnRadius)
{
    local vector LocalGoal, LocalGoalToCircle, LocalTangent, WorldTangent;
    local rotator HeadingRotator;

    WorldGoal.Z = 0;
    CurrentPlanePosition.Z = 0;

    HeadingRotator = OrthoRotation(CurrentVelocity, CurrentVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    HeadingRotator.Roll = 0;

    LocalGoal = (WorldGoal - CurrentPlanePosition) << HeadingRotator;
    LocalGoal.Z = 0;

    LocalGoalToCircle = LocalGoal;
        if (bIsClockwise)
        LocalGoalToCircle.Y -= TurnRadius;
    else
        LocalGoalToCircle.Y += TurnRadius;

    LocalTangent = CalculateClosestTangentPoint(LocalGoalToCircle, TurnRadius, bIsClockwise);
    //Log("Size"$VSize(LocalTangent));
    //Log("Local To circle: "$(LocalTangent >> HeadingRotator));

    // Convert to Plane Space.
    if (bIsClockwise)
        LocalTangent.Y += TurnRadius;
    else
        LocalTangent.Y -= TurnRadius;

    // Convert To World Space.
    WorldTangent = (LocalTangent >> HeadingRotator) + CurrentPlanePosition;

    return WorldTangent;
}

function vector CalculateClosestTangentPoint(vector Point, float Radius, bool bIsClockwise)
{
    local float YA, YB, YC, XA, XB, XC;
    local vector TangentPointToCircleA, TangentPointToCircleB;
    local float PolarCoordA, PolarCoordB;

    if(VSize(Point) <= Radius)
    {
        Log("Point Is too close");
        return vect(0,0,0);
    }

    /*
    YA = 2 * Square(Radius) * Point.Y;
    YB = Sqrt(4 * Square(Square(Radius))  * Square(Point.Y) - 4 * (Square(Point.Y) + Square(Point.X)) * (Square(Square(Radius)) - Square(Point.X) * Square(Radius) )) ;
    YC = 2 * (Square(Point.Y) + Square(Point.X));

    XA = 2 * Square(Radius) * Point.X;
    XB = Sqrt(4 * Square(Square(Radius))  * Square(Point.X) - 4 * (Square(Point.Y) + Square(Point.X)) * (Square(Square(Radius)) - Square(Point.Y) * Square(Radius) )) ;
    XC = 2 * (Square(Point.Y) + Square(Point.X));
    */
    YA = Square(Radius) * Point.Y;
    YB = Radius * Point.X * Sqrt(Square(Point.X) + Square(Point.Y) - Square(Radius));
    YC = Square(Point.Y) + Square(Point.X);

    XA = Square(Radius) * Point.X;
    XB = Radius * Point.Y * Sqrt(Square(Point.X) + Square(Point.Y) - Square(Radius));
    XC = Square(Point.Y) + Square(Point.X);

    //XA = Square(Radius) * Point.X;
    //XB = Radius

    //TangentPointToCircleA.Y = (YA + YB) / YC;
    TangentPointToCircleA.Y = (YA - YB) / YC;
    TangentPointToCircleA.X = (XA + XB) / XC;
    TangentPointToCircleA.Z = 0;
    //Log("parts: "@XA@XB@XC);
    Log("TangentA: "$TangentPointToCircleA);
    PolarCoordA = Atan(TangentPointToCircleA.X / VSize(TangentPointToCircleA), TangentPointToCircleA.Y / VSize(TangentPointToCircleA));

    //TangentPointToCircleB.Y = (YA - YB) / YC;
    TangentPointToCircleB.Y = (YA + YB) / YC;
    TangentPointToCircleB.X = (XA - XB) / XC;
    TangentPointToCircleB.Z = 0;
    Log("TangentB: "$ TangentPointToCircleB);

    PolarCoordB = Atan(TangentPointToCircleB.X / VSize(TangentPointToCircleB), TangentPointToCircleB.Y / VSize(TangentPointToCircleB));

    if (bIsClockwise)
    {
        PolarCoordA = Pi - PolarCoordA;
        PolarCoordB = Pi - PolarCoordB;
    }

    if (PolarCoordA < 0)
        PolarCoordA = 2*Pi + PolarCoordA;
    if (PolarCoordB < 0)
        PolarCoordB = 2*Pi + PolarCoordB;

    if(PolarCoordA == 0)
    {
        TangentAngle = PolarCoordB;
        return TangentPointToCircleB;
    }
    else if(PolarCoordB == 0)
    {
        TangentAngle = PolarCoordA;
        return TangentPointToCircleA;
    }

    else if (( PolarCoordA >= 0 && PolarCoordB < 0))
    {
        TangentAngle = PolarCoordA;
        return TangentPointToCircleA;
    }
    else if ((PolarCoordB >= 0 && PolarCoordA < 0))
    {
        TangentAngle = PolarCoordB;
        return TangentPointToCircleB;
    }
    else if( PolarCoordA < 0 && PolarCoordB < 0)
    {
        // SMALLEST;
        if(PolarCoordA < PolarCoordB)
        {
            TangentAngle = PolarCoordA;
            return TangentPointToCircleA;
        }
        else
        {
            TangentAngle = PolarCoordB;
            return TangentPointToCircleB;
        }

    }
    else if( PolarCoordA >= 0 && PolarCoordB >= 0)
    {
         // SMALLEST;
        if(PolarCoordA < PolarCoordB)
        {
            TangentAngle = PolarCoordA;
            return TangentPointToCircleA;
        }
        else
        {
            TangentAngle = PolarCoordB;
            return TangentPointToCircleB;
        }
    }
}

DefaultProperties
{

}
