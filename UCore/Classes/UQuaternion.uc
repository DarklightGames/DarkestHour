//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class UQuaternion extends Object
    abstract;

// Returns the angle, in radians, between two quaternions.
static function float Angle(Quat A, Quat B)
{
    A = QuatProduct(B, QuatInvert(A));

    return Acos(A.W) * 2.0f;
}

