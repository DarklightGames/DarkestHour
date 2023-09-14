//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// http://semver.org/
//==============================================================================

class UVersion extends Object;

var int Major;
var int Minor;
var int Patch;
var string Prerelease;
var string Metadata;

final static function UVersion FromString(string S)
{
    local int i;
    local UVersion V;
    local array<string> VersionParts;
    local string VersionString;

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

// Returns a string in the format "v<Major>.<Minor>.<Patch>[-<Prerelease][+<Metadata>]".
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

// Returns 0 if they are identical, -1 if the version is < other, 1 if version is > other.
final function int Compare(UVersion Other)
{
    if (Major == Other.Major)
    {
        if (Minor == Other.Minor)
        {
            if (Patch == Other.Patch)
            {
                return 0;
            }
            else if (Patch < Other.Patch)
            {
                return -1;
            }
            else
            {
                return 1;
            }
        }
        else if (Minor < Other.Minor)
        {
            return -1;
        }
        else
        {
            return 1;
        }
    }
    else if (Major < Other.Major)
    {
        return -1;
    }
    else
    {
        return 1;
    }
}

function bool IsPrerelease()
{
    return Prerelease != "";
}

