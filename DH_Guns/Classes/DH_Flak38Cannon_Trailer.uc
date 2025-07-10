//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak38Cannon_Trailer extends DH_Flak38Cannon;

defaultproperties
{
    bLimitYaw=true // when on trailer, the wheels don't allow much traverse
    YawStartConstraint=-3000.0
    YawEndConstraint=4500.0
    MaxPositiveYaw=3900
    MaxNegativeYaw=-2500
}
