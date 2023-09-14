//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
