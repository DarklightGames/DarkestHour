//==============================================================================
// Darklight Games (c) 2008-2016
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

static final function float SmoothStep(float T, float A, float B)
{
    return Linear((T ** 2) * (3 - (2 * T)), A, B);
}

static final function float Cosine(float T, float A, float B)
{
    return Linear((-Cos(Pi * T) / 2) + 0.5, A, B);
}

static final function float Acceleration(float T, float A, float B)
{
    return Linear(T ** 2, A, B);
}

static final function float Deceleration(float T, float A, float B)
{
    return Linear(1.0 - ((1.0 - T) ** 2), A, B);
}

