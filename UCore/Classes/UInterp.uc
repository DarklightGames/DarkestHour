//==============================================================================
// Darklight Games (c) 2008-2017
//==============================================================================
// http://codeplea.com/simple-interpolation
//==============================================================================

class UInterp extends Object
    abstract;

static final function float Step(float T, float A, float B)
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

static final function float Linear(float T, float A, float B)
{
    return A + T * (B - A);
}

static final function rotator RLinear(float T, rotator A, rotator B)
{
    return QuatToRotator(QuatSlerp(QuatFromRotator(A), QuatFromRotator(B), T));
}

static final function float SmoothStep(float T, float A, float B)
{
    return Linear((T ** 2) * (3 - (2 * T)), A, B);
}

static final function rotator RSmoothStep(float T, rotator A, rotator B)
{
    return RLinear(SmoothStep(T, 0.0, 1.0), A, B);
}

static final function float Cosine(float T, float A, float B)
{
    return Linear((-Cos(Pi * T) / 2) + 0.5, A, B);
}

static final function rotator RCosine(float T, rotator A, rotator B)
{
    return RLinear(Cosine(T, 0.0, 1.0), A, B);
}

static final function float Acceleration(float T, float A, float B)
{
    return Linear(T ** 2, A, B);
}

static final function rotator RAcceleration(float T, rotator A, rotator B)
{
    return RLinear(Acceleration(T, 0.0, 1.0), A, B);
}

static final function float Deceleration(float T, float A, float B)
{
    return Linear(1.0 - ((1.0 - T) ** 2), A, B);
}

static final function rotator RDeceleration(float T, rotator A, rotator B)
{
    return RLinear(Deceleration(T, 0.0, 1.0), A, B);
}


