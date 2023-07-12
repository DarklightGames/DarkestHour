//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// http://codeplea.com/simple-interpolation
//==============================================================================

class UInterp extends Object
    abstract;

final static function float Step(float T, float A, float B)
{
    if (T < 0.5)
    {
        return A;
    }
    else
    {
        return B;
    }
}

final static function float Linear(float T, float A, float B)
{
    return A + T * (B - A);
}

final static function rotator RLinear(float T, rotator A, rotator B)
{
    return QuatToRotator(QuatSlerp(QuatFromRotator(A), QuatFromRotator(B), T));
}

final static function float SmoothStep(float T, float A, float B)
{
    return Linear((T ** 2) * (3 - (2 * T)), A, B);
}

final static function rotator RSmoothStep(float T, rotator A, rotator B)
{
    return RLinear(SmoothStep(T, 0.0, 1.0), A, B);
}

final static function float Cosine(float T, float A, float B)
{
    return Linear((-Cos(Pi * T) / 2) + 0.5, A, B);
}

final static function rotator RCosine(float T, rotator A, rotator B)
{
    return RLinear(Cosine(T, 0.0, 1.0), A, B);
}

final static function float Acceleration(float T, float A, float B)
{
    return Linear(T ** 2, A, B);
}

final static function rotator RAcceleration(float T, rotator A, rotator B)
{
    return RLinear(Acceleration(T, 0.0, 1.0), A, B);
}

final static function float Deceleration(float T, float A, float B)
{
    return Linear(1.0 - ((1.0 - T) ** 2), A, B);
}

final static function rotator RDeceleration(float T, rotator A, rotator B)
{
    return RLinear(Deceleration(T, 0.0, 1.0), A, B);
}

// Shading function for yaw & pitch indicators
// This function is a bell curve with the following characteristics:
// f(0) = 0, f(1/2) = 1, f(1) = 0
final static function float Mimi(float T)
{
    return 16 * (T ** 2) * ((T - 1) ** 2);
}

//       ^
//  1-A -|                                          #####
//       |                                      ####
//       |                                  ####
//       |                               ###
//       |                             ## |
//       |                            #   | |--------|
//       |                          ##    | |~ cos(x)|
//       |                         #      | |--------|
//       |                         #      |
//       |                       ##       |
//  0.5 -|                       +        |
//       |                      ##        |
//       |  |---------|        #          |
//       |  |~ -cos(x)|        #          |
//       |  |---------|      ##           |
//       |                  #             |
//       |                ##              |
//       |             ###                |
//       |         #### |                 |
//       |     ####     |                 |
//    A -|#####         |        |        |               |
//       +---------------------------------------------------->
//      0.0          (0.5-A)    0.5    (0.5+A)           1.0

final static function float DialCurvature(float X)
{
    // Horner's scheme for -2.1557x**3 + 3.1934x**2 - 0.0562x
    // This function is a pretty good approximation of the weird function with cos(x) above
    return X * (X * (-2.1557 * X + 3.1934) - 0.0562);
}

final static function float DialRounding(float X, float Span, optional bool bDebug)
{
    local float AngularCoordinate, AngularModifier, NormalizedAngularModifier;
    local float AngularStretch, LowerAngularBound, TopAngularBound;

    if (Span > 1.0 || Span < 0.0)
    {
        Warn("UInterp.DialRounding is not defined for Span=" $ Span $ ". Clamping to [0, 1].");
        Span = FClamp(Span, 0.0, 1.0);
    }

    AngularStretch = Span * 0.5;
    LowerAngularBound = class'UInterp'.static.DialCurvature(0.5 - AngularStretch);
    TopAngularBound = class'UInterp'.static.DialCurvature(0.5 + AngularStretch);

    if (X > 1.0 || X < 0.0)
    {
        Warn("UInterp.DialRounding is not defined for X=" $ X $ ". Clamping to [0, 1].");
        X = FClamp(X, 0.0, 1.0);
    }

    // transform X in (0, 1) into V in (0.5-A, 0.5+A)
    AngularCoordinate = 0.5 + AngularStretch * (2 * X - 1);

    // get the value of the curvature
    AngularModifier = DialCurvature(AngularCoordinate);

    // normalize the value back to (0, 1)
    NormalizedAngularModifier = (AngularModifier - LowerAngularBound) / (TopAngularBound - LowerAngularBound);

    if (bDebug)
    {
        Log("X:" @ X @ ", AngularStretch:" @ AngularStretch @ ", AngularCoordinate:" @ AngularCoordinate @ ", AngularModifier:" @ AngularModifier @ ", NormalizedAngularModifier:" @ NormalizedAngularModifier);
    }

    return NormalizedAngularModifier;
}