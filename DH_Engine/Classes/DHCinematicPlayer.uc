//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
class DHCinematicPlayer extends CinematicPlayer;

auto state PlayerWaiting
{
    function bool IsSpectating() {return false;}
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot) {}
    function PlayerMove(float DeltaTime) {}
    exec function Fire(optional float F) {}
    function bool CanRestartPlayer() {return false;}

    function BeginState()
    {
        bFixedCamera = true;

        CameraDist = default.CameraDist;

        if (PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.SetWaitingPlayer(true);
        }

        bCollideWorld = true;
    }
}
