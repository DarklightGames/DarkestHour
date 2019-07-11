//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Defines Movement information, specifications, helper functions.
// The code to actually preform movements is done here.
// Extend this class for each goal driven movement.
//
// Movement States differ in their goals, not their implementation of the movement.
//-----------------------------------------------------------
class DHMoveState extends Object abstract;

enum ETurnDirection
{
    TURN_UP,
    TURN_DOWN,
    TURN_RIGHT,
    TURN_LEFT
};

var float TotalTurned;

// Owning airplane. Movements are done on this actor.
var DHAirplane Airplane;

var float TangentAngle;     // Angle of the tangent point to the initial position of the plane. Used to check for end of the turn.
var vector InitialVelocity;
var vector InitialLocation;
var bool bIsTurnInitialized;
var float DesiredSpeed;
var float Acceleration;

function Tick(float DeltaTime);

// Updates the airplane's current speed based on desired speed and acceleration.
function UpdateSpeed(float DeltaTime)
{
    // Stright line speed change
    if (VSize(Airplane.Velocity) < DesiredSpeed)
    {
        if (Abs(Airplane.CurrentSpeed - DesiredSpeed) <= DeltaTime * Acceleration)
        {
            Airplane.CurrentSpeed = DesiredSpeed;
        }
        else
        {
            Airplane.CurrentSpeed += DeltaTime * Acceleration;
        }
    }
    else if (Airplane.CurrentSpeed > DesiredSpeed)
    {
        if (Abs(Airplane.CurrentSpeed - DesiredSpeed) <= DeltaTime * Acceleration)
        {

            Airplane.CurrentSpeed = DesiredSpeed;
        }
        else
        {
            Airplane.CurrentSpeed -= DeltaTime * Acceleration;
        }
    }
}

// Dives or Climbs the plane. Similar to TurnPlane, just up and down.
function bool DiveOrClimbPlane(bool bIsClimbing, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local rotator DeltaRot;
    local float ArcDistance;
    local vector NewPlanePosition;
    local rotator Heading, JustYaw;

    if (!bIsTurnInitialized)
    {
        InitialVelocity = Airplane.Velocity;
        InitialLocation = Airplane.Location;
        bIsTurnInitialized = true;
    }

    // Calculate position
    NewPlanePosition = CalculateRotationPosition(bIsClimbing, TurnRadius, Speed, DeltaTime);

    // convert to pitch change - local
    NewPlanePosition.Z = NewPlanePosition.Y;
    NewPlanePosition.Y = 0;

    // Convert to world positon
    Heading = OrthoRotation( InitialVelocity,  InitialVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = 0;
    NewPlanePosition = (NewPlanePosition >> Heading) + InitialLocation;

    // Calculate the amount turned.
    ArcDistance = Speed * DeltaTime;
    DeltaAngle = ArcDistance / TurnRadius;

    DeltaRot.Roll = 0;
    if(bIsClimbing)
        DeltaRot.Pitch = class'UUnits'.static.RadiansToUnreal(TotalTurned);
    else
        DeltaRot.Pitch = class'UUnits'.static.RadiansToUnreal(-TotalTurned);
    DeltaRot.Yaw = 0;

    JustYaw = Heading;
    JustYaw.Pitch = 0;
    JustYaw.Roll = 0;

    // Update plane's velocity.
    Airplane.Velocity = ((InitialVelocity << JustYaw) >> DeltaRot) >> JustYaw;
    Airplane.SetLocation(NewPlanePosition);

    return true;
}

// Turns plane left or right along a circular path.
function TurnPlane(bool bIsTurnRight, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local rotator DeltaRot;
    local float ArcDistance;
    local vector NewPlanePosition;
    local rotator Heading;

    if (!bIsTurnInitialized)
    {
        InitialVelocity = Airplane.Velocity;
        InitialLocation = Airplane.Location;
        bIsTurnInitialized = true;
    }

    // Calculate position
    NewPlanePosition = CalculateRotationPosition(bIsTurnRight, TurnRadius, Speed, DeltaTime);

    // Convert to world positon
    Heading = OrthoRotation( InitialVelocity,  InitialVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    Heading.Roll = 0;
    NewPlanePosition = (NewPlanePosition >> Heading) + InitialLocation;

    // Calculate the amount turned.
    ArcDistance = Speed * DeltaTime;
    DeltaAngle = ArcDistance / TurnRadius;

    DeltaRot.Roll = 0;
    if(bIsTurnRight)
        DeltaRot.Yaw = class'UUnits'.static.RadiansToUnreal(TotalTurned);
    else
        DeltaRot.Yaw = class'UUnits'.static.RadiansToUnreal(-TotalTurned);
    DeltaRot.Pitch = 0;

    // Add to total angled turned. Used to tell when to stop the turn.
    //TotalTurned += Abs(DeltaAngle);

    // Update plane's velocity.
    //Airplane.Velocity = Airplane.Velocity >> DeltaRot;
    Airplane.Velocity = InitialVelocity >> DeltaRot;
    //Log("Dog Lad: "$NewPlanePosition);
    Airplane.SetLocation(NewPlanePosition);
}

// Many moveStates use circular Rotation. Use this calculation across all of them.
// TODO: Add in axes variations for the circle, allowing for the creation of
// elipsoids. This would allow for percise curved movement to any position.
function vector CalculateRotationPosition(bool bIsClockwise, float TurnRadius, float Speed, float DeltaTime)
{
    local float DeltaAngle;
    local float ArcDistance;
    local vector PlaneSpaceNewPosition;
    local rotator Heading;

    ArcDistance = Speed * DeltaTime;
    DeltaAngle = ArcDistance / TurnRadius;
    TotalTurned += Abs(DeltaAngle);

    // Relative to the rotation center.
    PlaneSpaceNewPosition.X = Sin(TotalTurned) * TurnRadius;
    PlaneSpaceNewPosition.Y = Cos(TotalTurned) * TurnRadius;
    PlaneSpaceNewPosition.Z = 0;

    // Make relative to the plane's position.
    if (bIsClockwise)
    {
        // A turn to thr right.
        PlaneSpaceNewPosition.Y = TurnRadius - PlaneSpaceNewPosition.Y;
    }
    else if (!bIsClockwise)
    {
        PlaneSpaceNewPosition.Y = PlaneSpaceNewPosition.Y - TurnRadius;
    }

    return PlaneSpaceNewPosition;
}

function vector CalculateDiveClimbEndPoint(vector WorldGoal, vector CurrentVelocity, vector CurrentPlanePosition, bool bIsClockwise, float TurnRadius)
{
    local vector LocalGoal, LocalGoalToCircle, LocalTangent, WorldTangent;
    local rotator HeadingRotator;

    //WorldGoal.Y = 0;
    //CurrentPlanePosition.Y = 0;

    // Convert world position goal to airplane velocity space, relative to the turn circle.
    HeadingRotator = OrthoRotation(CurrentVelocity, CurrentVelocity Cross vect(0, 0, 1), vect(0, 0, 1));
    HeadingRotator.Roll = 0;

    // Convert to plane space, in horizontal turn format.
    LocalGoal = (WorldGoal - CurrentPlanePosition) << HeadingRotator;
    LocalGoal.Y = LocalGoal.Z;
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

    // Convert from horizontal turn format, back to pitch/dive/climb format.
    LocalTangent.Z = LocalTangent.Y;
    LocalTangent.Y = 0;

    // Convert To World Space.
    WorldTangent = (LocalTangent >> HeadingRotator) + CurrentPlanePosition;

    return WorldTangent;
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
