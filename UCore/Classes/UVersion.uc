//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// http://semver.org/
//==============================================================================

class UVersion extends Object
    abstract;

static final function FromString(string S, out int Major, out int Minor, out int Patch)
{
    local array<string> Parts;

    if (Mid(S, 0, 1) ~= "v")
    {
        S = Mid(S, 1);
    }

    Split(S, ".", Parts);

    if (Parts.Length == 3)
    {
        Major = int(Parts[0]);
        Minor = int(Parts[1]);
        Patch = int(Parts[2]);
    }
}

// Returns a string in the format "v<Major>.<Minor>.<Patch>".
static final function string ToString(int Major, int Minor, int Patch)
{
    return "v" $ Major $ "." $ Minor $ "." $ Patch;
}

// Compares two versions.
// Returns 1 if LHS is later than RHS.
// Returns -1 if RHS is later than LHS.
// Returns 0 if LHS and RHS are equal.
static final function int CompareFunction(string LHS, string RHS)
{
    local int i;
    local int LHSParts[3];
    local int RHSParts[3];

    FromString(LHS, LHSParts[0], LHSParts[1], LHSParts[2]);
    FromString(RHS, RHSParts[0], RHSParts[1], RHSParts[2]);

    for (i = 0; i < 3; ++i)
    {
        if (LHSParts[i] > RHSParts[i])
        {
            return 1;
        }
        else if (LHSParts[i] < RHSParts[i])
        {
            return -1;
        }
    }

    return 0;
}

