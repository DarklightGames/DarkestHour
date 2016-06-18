//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class UInterp extends Object
    abstract;

static final function float InterpSin(float X)
{
    return 0.5 + (Sin(Pi * X - (Pi / 2)) / 2);
}
