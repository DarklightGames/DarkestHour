//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// http://semver.org/
//==============================================================================

class UVersion extends Object;

var int Major;
var int Minor;
var int Patch;

static final function UVersion FromString(string S)
{
    local UVersion V;
    local array<string> Parts;

    if (Mid(S, 0, 1) ~= "v")
    {
        S = Mid(S, 1);
    }

    Split(S, ".", Parts);

    V = new class'UVersion';

    if (Parts.Length == 3)
    {
        V.Major = int(Parts[0]);
        V.Minor = int(Parts[1]);
        V.Patch = int(Parts[2]);
    }

    return V;
}

// Returns a string in the format "v<Major>.<Minor>.<Patch>".
final function string ToString()
{
    return "v" $ Major $ "." $ Minor $ "." $ Patch;
}
