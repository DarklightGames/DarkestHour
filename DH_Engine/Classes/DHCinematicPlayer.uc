//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
class DHCinematicPlayer extends CinematicPlayer;

auto state PlayerWaiting
{
    function bool IsSpectating() {return false;}
    function ProcessMove(float DeltaTime, Vector NewAccel, eDoubleClickDir DoubleClickMove, Rotator DeltaRot) {}
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
