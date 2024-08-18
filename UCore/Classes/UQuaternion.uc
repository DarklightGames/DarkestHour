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

// TODO: Not tested.
static function Quat FromAxes(Vector XAxis, Vector YAxis, Vector ZAxis)
{
    local float Trace, S;
    local Quat Result;
    local float M11, M12, M13, M21, M22, M23, M31, M32, M33;

    // TODO: remove this later, inefficient.
    M11 = XAxis.X;
    M12 = XAxis.Y;
    M13 = XAxis.Z;

    M21 = YAxis.X;
    M22 = YAxis.Y;
    M23 = YAxis.Z;

    M31 = ZAxis.X;
    M32 = ZAxis.Y;
    M33 = ZAxis.Z;

    Trace = M11 + M22 + M33;

    if (Trace > 0)
    {
        S = 0.5 / Sqrt(Trace + 1.0);

        Result.W = 0.25 / S;
        Result.X = (M32 - M23) * S;
        Result.Y = (M13 - M31) * S;
        Result.Z = (M21 - M12) * S;
    }
    else if (M11 > M22 && M11 > M33)
    {
        S = 2.0 * Sqrt(1.0 + M11 - M22 - M33);

        Result.W = (M32 - M23) / S;
        Result.X = 0.25 * S;
        Result.Y = (M12 + M21) / S;
        Result.Z = (M13 + M31) / S;
    }
    else if (M22 > M33)
    {
        S = 2.0 * Sqrt(1.0 + M22 - M11 - M33);

        Result.W = (M13 - M31) / S;
        Result.X = (M12 + M21) / S;
        Result.Y = 0.25 * S;
        Result.Z = (M23 + M32) / S;
    }
    else
    {
        S = 2.0 * Sqrt(1.0 + M33 - M11 - M22);

        Result.W = (M21 - M12) / S;
        Result.X = (M13 + M31) / S;
        Result.Y = (M23 + M32) / S;
        Result.Z = 0.25 * S;
    }

    return Result;
}