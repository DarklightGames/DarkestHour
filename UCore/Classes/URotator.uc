//==============================================================================
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class URotator extends Object
    abstract;

static function Rotator RandomRange(Rotator  Min, Rotator Max)
{
    return RLerp(Min, Max, FRand());
}

static function Rotator RLerp(Rotator  A, Rotator B, float T)
{
    local Rotator R;

    R.Pitch = A.Pitch + ((B.Pitch - A.Pitch) * T);
    R.Yaw = A.Yaw + ((B.Yaw - A.Yaw) * T);
    R.Roll = A.Roll + ((B.Roll - A.Roll) * T);

    return R;
}

// Sometimes virtually equivalent rotators are not equal because the storage of
// rotator values can use the full 32-bit integer range, but only the lowest
// 16-bits are actually really used at all. This comparison only uses the lowest
// 16-bits to determine effective equality.
static function bool Equal(Rotator  LHS, Rotator RHS)
{
    return (LHS.Pitch & 0xFFFF) == (RHS.Pitch & 0xFFFF) &&
           (LHS.Yaw & 0xFFFF) == (RHS.Yaw & 0xFFFF) &&
           (LHS.Roll & 0xFFFF) == (RHS.Roll & 0xFFFF);
}

// https://wiki.beyondunreal.com/Legacy:Rotator#A_note_on_logging_rotators
// When rotators are typecasted to string, e.g. when logging them, their
// Pitch/Yaw/Roll values are cramped into the range of 0 to 65535 by reducing
// them to 16bit unsigned integers. This does not mean the rotator has changed,
// just that e.g. log() is not giving you their true value! To get the true
// value write your own rotator to string function.
static function string ToString(Rotator  R)
{
    return "(" $ R.Pitch $ "," $ R.Yaw $ "," $ R.Roll $ ")";
}

// Check whether two rotators are close to each other within given tolerance.
final static function bool IsClose(Rotator  LHS, Rotator RHS, int Tolerance)
{
    LHS = Normalize(LHS);
    RHS = Normalize(RHS);

    return Abs(LHS.Pitch - RHS.Pitch) <= Abs(Tolerance) &&
           Abs(LHS.Yaw - RHS.Yaw) <= Abs(Tolerance) &&
           Abs(LHS.Roll - RHS.Roll) <= Abs(Tolerance);
}
