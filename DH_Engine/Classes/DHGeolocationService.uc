//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHGeolocationService extends Object;

struct IpCountryCode
{
    var string IpAddress;
    var string CountryCode;
};

var config string     ApiHost;
var config string     ApiPath;
var config string     ApiKey;

var array<string>               CountryCodes;
var config array<IPCountryCode> IpCountryCodes;

static function int GetCountryCodeIndex(string CountryCode)
{
    local int i;

    for (i = 0; i < default.CountryCodes.Length; ++i)
    {
        if (default.CountryCodes[i] == CountryCode)
        {
            return i;
        }
    }

    return -1;
}

static function int GetIpCountryCodeIndex(string IpAddress)
{
    local int StartIndex, EndIndex, MiddleIndex;

    EndIndex = default.IpCountryCodes.Length - 1;

    while (StartIndex <= EndIndex)
    {
        MiddleIndex = (StartIndex + EndIndex) / 2;

        if (default.IpCountryCodes[MiddleIndex].IpAddress == IpAddress)
        {
            return MiddleIndex;
        }
        else
        {
            if (IpAddress < default.IpCountryCodes[MiddleIndex].IpAddress)
            {
                EndIndex = MiddleIndex - 1;
            }
            else
            {
                StartIndex = MiddleIndex + 1;
            }
        }
    }

    return -1;
}

static function int GetIpCountryCodeInsertionIndex(string IpAddress, int StartIndex, int EndIndex)
{
    local int MiddleIndex, CmpResult;

    if (StartIndex == EndIndex)
    {
        // Insertion sort.
    }
    else if (StartIndex > EndIndex)
    {
        return StartIndex;
    }

    MiddleIndex = (StartIndex + EndIndex) / 2;
    CmpResult = StrCmp(IpAddress, default.IpCountryCodes[MiddleIndex].IpAddress);

    if (CmpResult < 0)
    {
        return GetIpCountryCodeInsertionIndex(IpAddress, MiddleIndex + 1, EndIndex);
    }
    else if (CmpResult > 0)
    {
        return GetIpCountryCodeInsertionIndex(IpAddress, StartIndex, MiddleIndex - 1);
    }

    return MiddleIndex;
}

static function bool AddIpCountryCode(string IpAddress, string CountryCode)
{
    local int Index;

    Index = GetIpCountryCodeInsertionIndex(IpAddress, 0, default.IpCountryCodes.Length - 1);

    if (Index >= 0)
    {
        if (default.IpCountryCodes.Length > 0 &&
            Index < default.IpCountryCodes.Length &&
            default.IpCountryCodes[Index].IpAddress == IpAddress)
        {
            // Record already written.
            return true;
        }

        default.IpCountryCodes.Insert(Index, 1);
        default.IpCountryCodes[Index].IpAddress = IpAddress;
        default.IpCountryCodes[Index].CountryCode = CountryCode;

        return true;
    }

    return false;
}

static function GetIpDataTest(Actor A, string IpAddress)
{
    local int Index;
    local HTTPRequest R;

    // Check if country code has already been determined.
    Index = GetIpCountryCodeIndex(IpAddress);

    if (Index >= 0)
    {
        // Country code has already been cached, used it!
        Log("Already have country code for" @ IpAddress);
        return;
    }

    // Fetch country code from the API.
    R = A.Spawn(class'HTTPRequest');
    R.Host = default.ApiHost;
    R.Path = default.ApiPath;
    R.Path = Repl(R.Path, "{ip}", IpAddress);
    R.Path = Repl(R.Path, "{key}", default.ApiKey);

    R.OnResponse = OnResponse;
    R.UserString = IpAddress;
    R.Send();
}

static function GetIpData(DHPlayer PC)
{
    local int Index;
    local HTTPRequest R;
    local DHPlayerReplicationInfo PRI;
    local string IpAddress;

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI != none)
    {
        return;
    }

    // Check if country code has already been determined.
    Index = GetIpCountryCodeIndex(IpAddress);

    if (Index >= 0)
    {
        // Country code has already been cached, used it!
        PRI.CountryIndex = GetCountryCodeIndex(default.IpCountryCodes[Index].CountryCode);
        return;
    }

    IpAddress = class'INet4Address'.static.TrimPort(PC.GetPlayerNetworkAddress());

    // Fetch country code from the API.
    R = PC.Spawn(class'HTTPRequest');
    R.Host = default.ApiHost;
    R.Path = default.ApiPath;
    R.Path = Repl(R.Path, "{ip}", IpAddress);
    R.Path = Repl(R.Path, "{key}", default.ApiKey);
    R.OnResponse = OnResponse;
    R.UserObject = PC;
    R.UserString = IpAddress;
    R.Send();
}

static function OnResponse(HTTPRequest Request, int Status, TreeMap_string_string Headers, string Content)
{
    local JSONParser Parser;
    local JSONValue ResponseValue;
    local JSONObject ResponseObject;
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local string CountryCode;
    local string IpAddress;

    Log("Status:" @ Status);

    if (Status != 200)
    {
        return;
    }

    Parser = new class'JSONParser';
    ResponseValue = Parser.Parse(Content);

    if (ResponseValue == none)
    {
        return;
    }

    ResponseObject = ResponseValue.AsObject();

    if (ResponseObject == none)
    {
        return;
    }

    IpAddress = ResponseObject.Get("ip").AsString();
    CountryCode = ResponseObject.Get("country_code").AsString();

    AddIpCountryCode(IpAddress, CountryCode);

    StaticSaveConfig();

    PC = DHPlayer(Request.UserObject);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        if (PRI != none)
        {
            // TODO: make this an index instead (so we don't have to do more string lookups later)
            PRI.CountryIndex = GetCountryCodeIndex(CountryCode);
        }
    }
}

static function DumpCache()
{
    local int i;

    Log("-----------------------------------");

    for (i = 0; i < default.IpCountryCodes.Length; ++i)
    {
        Log(default.IpCountryCodes[i].IpAddress $ ":" @ default.IpCountryCodes[i].CountryCode);
    }
}

defaultproperties
{
    ApiHost="api.ipstack.com"
    ApiPath="/{ip}?access_key={key}"
    ApiKey="YOUR_API_KEY"

    CountryCodes(0)="AF"    // Afghanistan
    CountryCodes(1)="AX"    // Aland Islands
    CountryCodes(2)="AL"    // Albanai
    CountryCodes(3)="DZ"    // Algeria
    CountryCodes(4)="AS"    // American Somoa
    CountryCodes(5)="AD"    // Andora
    CountryCodes(6)="AO"    // Angola
    CountryCodes(7)="AI"    // Anguilla
    CountryCodes(8)="AG"    // Antigua and Barbuda
    CountryCodes(9)="AR"    // Argentina
    CountryCodes(10)="AM"   // Armenia
    CountryCodes(11)="AW"   // Aruba
    CountryCodes(12)="AU"   // Australia
    CountryCodes(13)="AI"   // Austria
    CountryCodes(14)="AZ"   // Azerbaijan
    CountryCodes(15)="BS"   // Bahamas

    CountryCodes(16)="BH"   // Bahrain
    CountryCodes(17)="BD"   // Bangladesh
    CountryCodes(18)="BB"   // Barbados
    CountryCodes(19)="BY"   // Belarus
    CountryCodes(20)="BE"   // Belgium
    CountryCodes(21)="BZ"   // Belize
    CountryCodes(22)="BJ"   // Benin
    CountryCodes(23)="BM"   // Bermuda
    CountryCodes(24)="BT"   // Bhutan
    CountryCodes(25)="BO"   // Bolivia
    CountryCodes(26)="BQ"   // Bonaire
    CountryCodes(27)="BQ"   // Caribbean Netherlands
    CountryCodes(28)="BA"   // Bosnia & Herzogovina
    CountryCodes(29)="BW"   // Botswana
    CountryCodes(30)="BR"   // Brazil
    CountryCodes(31)="BN"   // Brunei Darussalam

    CountryCodes(32)="BG"   // Bulgaria
    CountryCodes(33)="BF"   // Burkina Faso
    CountryCodes(34)="BI"   // Burindi
    CountryCodes(35)="KH"   // Cambodia
    CountryCodes(36)="CM"   // Cameroon
    CountryCodes(37)="CA"   // Canada
    CountryCodes(38)="CV"   // Cape Verde
    CountryCodes(39)=""
    CountryCodes(40)="
    CountryCodes(41)="
    CountryCodes(42)="
    CountryCodes(43)="
    CountryCodes(44)="
    CountryCodes(45)="
    CountryCodes(46)="
    CountryCodes(47)="
    CountryCodes(48)="
}

