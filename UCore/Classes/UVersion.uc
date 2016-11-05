//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// http://semver.org/
//==============================================================================

class UVersion extends Object;

var int Major;
var int Minor;
var int Patch;
var string Prerelease;
var string Metadata;

static final function UVersion FromString(string S)
{
    local int i;
    local UVersion V;
    local array<string> Parts, VersionParts;
    local string L, R, VersionString;

    V = new class'UVersion';

    if (Mid(S, 0, 1) ~= "v")
    {
        S = Mid(S, 1);
    }

    i = InStr(S, "-");

    if (i >= 0)
    {
        VersionString = Mid(S, 0, i);
        S = Mid(S, i);
        i = InStr(S, "+");

        if (i >= 0)
        {
            V.Prerelease = Mid(S, 0, i);
            V.Metadata = Mid(S, i);
        }
        else
        {
            V.Prerelease = S;
        }
    }
    else
    {
        i = InStr(S, "+");

        if (i >= 0)
        {
            VersionString = Mid(S, 0, i);
            V.Metadata = Mid(S, i);
        }
        else
        {
            VersionString = S;
        }
    }

    Split(VersionString, ".", VersionParts);

    if (VersionParts.Length == 3)
    {
        V.Major = int(VersionParts[0]);
        V.Minor = int(VersionParts[1]);
        V.Patch = int(VersionParts[2]);
    }
    else
    {
        return none;
    }

    return V;
}

// Returns a string in the format "v<Major>.<Minor>.<Patch>[-<Prerelease]".
final function string ToString()
{
    local string S;

    S = "v" $ Major $ "." $ Minor $ "." $ Patch;

    if (Prerelease != "")
    {
        S $= "-" $ Prerelease;
    }

    if (Metadata != "")
    {
        S $= "+" $ Metadata;
    }

    return S;
}

function bool IsPrerelease()
{
    return Prerelease != "";
}

