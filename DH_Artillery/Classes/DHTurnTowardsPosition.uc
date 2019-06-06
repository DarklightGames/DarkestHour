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
var float TurnSpeed;        // Desired Speed of turn.
var bool bIsTurningRight;   // Is this a right turn?
var vector PositionGoal;    // When the plane's velocity is aligned with this position, end the turn.
var bool bIsInitialized;    // keeps track if the initialization has been automatically preformed.
var float TangentAngle;     // Angle of the tangent point to the initial position of the plane. Used to check for end of the turn.
var vector TurnEndPoint;    // Point in world space that the plane should be at when the turn ends.

function Tick(float DeltaTime)
{
    local vector TangentVelocity;

    // Find the Turn End Point. This also sets the TangentAngle, so that we can detect the turn end.
    if (!bIsInitialized)
    {
        TurnEndPoint = CalculateTurnEndPoint(PositionGoal, Airplane.Velocity, Airplane.Location, bIsTurningRight, TurnRadius);
        bIsInitialized = true;
    }

    TurnPlane(bIsTurningRight, TurnRadius, Airplane.CurrentSpeed, DeltaTime);

    TangentVelocity = Normal(PositionGoal - TurnEndPoint);
    TangentVelocity.Z = 0;
    TangentVelocity = Normal(TangentVelocity);

    // Test if the TurnEndPoint has been passed. If so, set to proper endpoint and end the turn.
    if(TotalTurned >= TangentAngle)
    {
        TurnEndPoint.Z = Airplane.Location.Z;
        Airplane.SetLocation(TurnEndPoint);
        Airplane.Velocity = Normal(TangentVelocity) * Airplane.CurrentSpeed;
        Airplane.OnMoveEnd(); // tell Airplane that move is done.
    }
}

function vector CalculateTurnEndPoint(vector WorldGoal, vector CurrentVelocity, vector CurrentPlanePosition, bool bIsClockwise, float TurnRadius)
{
    local vector LocalGoal, LocalGoalToCircle, LocalTangent, WorldTangent;
    local rotator HeadingRotator;

    WorldGoal.Z = 0;
    CurrentPlanePosition.Z = 0;

    // Convert world position goal to airplane velocity space, relative to the turn circle.
    HeadingRotator = OrthoRotation(CurrentVelocity, CurrentVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    HeadingRotator.Roll = 0;

    LocalGoal = (WorldGoal - CurrentPlanePosition) << HeadingRotator;
    LocalGoal.Z = 0;

    LocalGoalToCircle = LocalGoal;
        if (bIsClockwise)
        LocalGoalToCircle.Y -= TurnRadius;
    else
        LocalGoalToCircle.Y += TurnRadius;

    // Calculate closest tangent point.
    LocalTangent = CalculateClosestTangentPoint(LocalGoalToCircle, TurnRadius, bIsClockwise);

    // Convert to Plane Space.
    if (bIsClockwise)
        LocalTangent.Y += TurnRadius;
    else
        LocalTangent.Y -= TurnRadius;

    // Convert To World Space.
    WorldTangent = (LocalTangent >> HeadingRotator) + CurrentPlanePosition;
    WorldTangent.Z = CurrentPlanePosition.Z;

    return WorldTangent;
}

function vector CalculateClosestTangentPoint(vector Point, float Radius, bool bIsClockwise)
{
    local float YA, YB, YC, XA, XB, XC;
    local vector TangentPointToCircleA, TangentPointToCircleB;
    local float PolarCoordA, PolarCoordB;
    local rotator VelocityRotator;

    // Return 0 if point is too close to have a tangent.
    if (VSize(Point) < Radius)
    {
        return vect(0,0,0);
    }

    // If point is ont the circle, then it is it's own tangent.
    if (VSize(Point) == Radius)
    {
        return Point;
    }

    // Calculate parts of tangent equation
    YA = Square(Radius) * Point.Y;
    YB = Radius * Point.X * Sqrt(Square(Point.X) + Square(Point.Y) - Square(Radius));
    YC = Square(Point.Y) + Square(Point.X);

    XA = Square(Radius) * Point.X;
    XB = Radius * Point.Y * Sqrt(Square(Point.X) + Square(Point.Y) - Square(Radius));
    XC = Square(Point.Y) + Square(Point.X);

    // First tangent point.
    TangentPointToCircleA.Y = (YA - YB) / YC;
    TangentPointToCircleA.X = (XA + XB) / XC;
    TangentPointToCircleA.Z = 0;

    // Angle of tangent point.
    PolarCoordA = Atan(TangentPointToCircleA.X / VSize(TangentPointToCircleA), TangentPointToCircleA.Y / VSize(TangentPointToCircleA));

    // Second tangent point.
    TangentPointToCircleB.Y = (YA + YB) / YC;
    TangentPointToCircleB.X = (XA - XB) / XC;
    TangentPointToCircleB.Z = 0;

    PolarCoordB = Atan(TangentPointToCircleB.X / VSize(TangentPointToCircleB), TangentPointToCircleB.Y / VSize(TangentPointToCircleB));

    // The rest of the code determines which point should be used. The tangent point that has a velocity towards the Point is correct.
    // convert angle based on if turning left to be relative to -y axis.
    if (bIsClockwise)
    {
        PolarCoordA = Pi - PolarCoordA;
        PolarCoordB = Pi - PolarCoordB;
    }

    // If angle is negative, convert to positive format.
    if (PolarCoordA < 0)
        PolarCoordA = 2*Pi + PolarCoordA;
    if (PolarCoordB < 0)
        PolarCoordB = 2*Pi + PolarCoordB;

    // Bellow tells which tangent point has a velocity that properly points to the given Point.
    VelocityRotator.Pitch = 0;
    if(bIsClockwise)
        VelocityRotator.Yaw = class'UUnits'.static.RadiansToUnreal(PolarCoordA);
    else
        VelocityRotator.Yaw = class'UUnits'.static.RadiansToUnreal(-PolarCoordA);
    VelocityRotator.Roll = 0;

    if((vect(1,0,0) >> VelocityRotator) Dot Normal(Point - TangentPointToCircleA) >= 0)
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

DefaultProperties
{

}
