//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class INet4Address extends Object;

var private int Addresses[4];
var private int Port;

static function string TrimPort(string NetworkAddress)
{
    local int i;

    i = InStr(NetworkAddress, ":");

    if (i >= 0)
    {
        NetworkAddress = Left(NetworkAddress, i);
    }

    return NetworkAddress;
}

function INet4Address StripPort()
{
    Port = 0;
    return self;
}

function string ToString()
{
    local string S;

    S = Addresses[0] $ "." $ Addresses[1] $ "." $ Addresses[2] $ "." $ Addresses[3];

    if (Port > 0)
    {
        S $= ":" $ Port;
    }

    return S;
}

final static function INet4Address FromString(string S)
{
    local INet4Address Address;
    local string T;
    local int i, j, k[4];
    local int Port;
    local array<string> Parts;

    j = InStr(S, ":");

    if (j >= 0)
    {
        T = Mid(S, j + 1);
        Port = int(T);

        if (Port == 0)
        {
            Log("Invalid IPv4 address (" $ S $ ")");

            return none;
        }

        S = Mid(S, 0, j);
    }

    Split(S, ".", Parts);

    if (Parts.Length != 4)
    {
        Log("Invalid IPv4 address (" $ S $ ")");
        return none;
    }

    for (i = 0; i < Parts.Length; ++i)
    {
        k[i] = int(Parts[i]);

        if (k[i] < 0 || k[i] > 255)
        {
            Log("Invalid IPv4 address (" $ S $ ")");

            return none;
        }
    }

    Address = new class'INet4Address';
    Address.Addresses[0] = k[0];
    Address.Addresses[1] = k[1];
    Address.Addresses[2] = k[2];
    Address.Addresses[3] = k[3];
    Address.Port = Port;

    return Address;
}

