//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Cannon_Trailer extends DH_Flak38Cannon;

defaultproperties
{
    bLimitYaw=true // when on trailer, the wheels don't allow much traverse
    YawStartConstraint=-3500.0
    YawEndConstraint=5000.0
    MaxPositiveYaw=4200
    MaxNegativeYaw=-2650
}
