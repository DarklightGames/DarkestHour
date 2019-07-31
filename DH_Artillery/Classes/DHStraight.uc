//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
//-----------------------------------------------------------
// Travel uninterupted in a straight line. No goal.
//-----------------------------------------------------------
class DHStraight extends DHMoveState;

var vector Direction;

simulated function Tick(float DeltaTime)
{
    //Log("Straight Tick");
    UpdateSpeed(DeltaTime);

    Airplane.Velocity = Normal(Direction) * Airplane.CurrentSpeed;
}

simulated function bool HasMetGoal()
{
    return true;
}

DefaultProperties
{

}
