//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class URotator extends Object
    abstract;

static function rotator RandomRange(rotator Min, rotator Max)
{
    return RLerp(Min, Max, FRand());
}

static function rotator RLerp(rotator A, rotator B, float T)
{
    local rotator R;

    R.Pitch = A.Pitch + ((B.Pitch - A.Pitch) * T);
    R.Yaw = A.Yaw + ((B.Yaw - A.Yaw) * T);
    R.Roll = A.Roll + ((B.Roll - A.Roll) * T);

    return R;
}
