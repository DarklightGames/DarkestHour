//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHGeolocationService extends Object;

struct IpCountryCode
{
    var string IPAddress;
    var string CountryCode;
};

var globalconfig string     ApiHost;
var globalconfig string     ApiPath;
var globalconfig string     ApiKey;

var array<string>           CountryCodes;
var array<IPCountryCode>    IPCountryCodes;

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

static function int GetIpCountryCodeIndex(string IPAddress, int StartIndex, int EndIndex)
{
    local int MiddleIndex, CmpResult;

    if (StartIndex > EndIndex)
    {
        // We've exhausted the search and found nothing.
        return -1;
    }

    MiddleIndex = (EndIndex - StartIndex) / 2;
    CmpResult = StrCmp(default.IPCountryCodes[MiddleIndex].IPAddress, IPAddress);

    if (CmpResult < 0)
    {
        return GetIpCountryCodeIndex(IPAddress, MiddleIndex + 1, EndIndex);
    }
    else if (CmpResult > 0)
    {
        return GetIpCountryCodeIndex(IPAddress, StartIndex, MiddleIndex - 1);
    }
    else
    {
        return MiddleIndex;
    }
}

static function int GetIpCountryCodeInsertionIndex(string IPAddress, int StartIndex, int EndIndex)
{
    local int MiddleIndex, CmpResult;

    if (StartIndex == EndIndex)
    {
        return StartIndex;
    }

    MiddleIndex = (EndIndex - StartIndex) / 2;
    CmpResult = StrCmp(default.IPCountryCodes[MiddleIndex].IPAddress, IPAddress);

    if (CmpResult < 0)
    {
        return GetIpCountryCodeInsertionIndex(IPAddress, MiddleIndex + 1, EndIndex);
    }
    else if (CmpResult > 0)
    {
        return GetIpCountryCodeInsertionIndex(IPAddress, StartIndex, MiddleIndex - 1);
    }

    // Address already exists in the list, no insertion!
    return -1;
}

static function bool AddIpCountryCode(string IPAddress, string CountryCode)
{
    // TODO: bisect index.
    local int Index;

    Index = GetIpCountryCodeInsertionIndex(IPAddress, 0, default.IPCountryCodes.Length - 1);

    if (Index >= 0)
    {
        default.IPCountryCodes.Insert(Index, 1);
        default.IPCountryCodes[Index].IPAddress = IPAddress;
        default.IPCountryCodes[Index].CountryCode = CountryCode;
        return true;
    }

    return false;
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
    Index = GetIpCountryCodeIndex(IPAddress, 0, default.IPCountryCodes.Length - 1);

    if (Index >= 0)
    {
        // Country code has already been cached, used it!
        PRI.CountryCode = default.IPCountryCodes[Index].CountryCode;
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

    CountryCode = ResponseObject.Get("country_code").AsString();

    PC = DHPlayer(Request.UserObject);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        if (PRI != none)
        {
            AddIpCountryCode(Request.UserString, CountryCode);

            PRI.CountryCode = CountryCode;
        }
    }
}

defaultproperties
{
    ApiHost="api.ipdata.co"
    ApiPath="/{ip}?api-key={key}"
    ApiKey="865e237eeda65b386befc55c4fa78f34ae5a7550d3e682c484b26493"

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

