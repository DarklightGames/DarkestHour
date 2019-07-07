//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Travel uninterupted in a straight line. No goal.
//-----------------------------------------------------------
class DHStraight extends DHMoveState;

var vector Direction;

function Tick(float DeltaTime)
{
    UpdateSpeed(DeltaTime);

    Airplane.Velocity = Normal(Direction) * Airplane.CurrentSpeed;
}

function bool HasMetGoal()
{
    return true;
}

DefaultProperties
{

}
