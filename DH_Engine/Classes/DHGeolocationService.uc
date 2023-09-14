//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGeolocationService extends Object;

struct IpCountryCode
{
    var string IpAddress;
    var string CountryCode;
};

var config bool     bIsEnabled;

var config string   ApiHost;
var config string   ApiPath;
var config string   ApiKey;

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

// Checks the ordering of the cache and repairs it if necessary.
static function Initialize()
{
    if (IsCacheCorrupt())
    {
        // Cache is corrupt, let's repair it.
        RepairCache();

        // Now save the repaired cache.
        StaticSaveConfig();
    }
}

static function RepairCache()
{
    local int i;
    local array<IpCountryCode> NewIpCountryCodes;

    Warn("IP/country cache has been corrupted and will now be repaired.");

    // Keep old cach records so we can re-insert them.
    NewIpCountryCodes = default.IpCountryCodes;

    // Remove all cache records.
    default.IpCountryCodes.Length = 0;


    for (i = 0; i < NewIpCountryCodes.Length; ++i)
    {
        AddIpCountryCode(NewIpCountryCodes[i].IpAddress, NewIpCountryCodes[i].CountryCode);
    }
}

static function bool IsCacheCorrupt()
{
    local int i;

    for (i = 1; i < default.IpCountryCodes.Length; ++i)
    {
        if (default.IpCountryCodes[i - 1].IpAddress >= default.IpCountryCodes[i].IpAddress)
        {
            return true;
        }
    }

    return false;
}

static function int GetIpCountryCodeInsertionIndex(string IpAddress, int StartIndex, int EndIndex)
{
    local int MiddleIndex;

    if (StartIndex == EndIndex)
    {
        if (default.IpCountryCodes[StartIndex].IpAddress > IpAddress)
        {
            return StartIndex;
        }
        else
        {
            return StartIndex + 1;
        }
    }
    else if (StartIndex > EndIndex)
    {
        return StartIndex;
    }

    MiddleIndex = (StartIndex + EndIndex) / 2;

    if (default.IpCountryCodes[MiddleIndex].IpAddress < IpAddress)
    {
        return GetIpCountryCodeInsertionIndex(IpAddress, MiddleIndex + 1, EndIndex);
    }
    else if (default.IpCountryCodes[MiddleIndex].IpAddress > IpAddress)
    {
        return GetIpCountryCodeInsertionIndex(IpAddress, StartIndex, MiddleIndex - 1);
    }

    return MiddleIndex;
}

static function int AddIpCountryCode(string IpAddress, string CountryCode)
{
    local int Index;

    if (GetIpCountryCodeIndex(IpAddress) != -1)
    {
        // IP address is already cached.
        return -1;
    }

    Index = GetIpCountryCodeInsertionIndex(IpAddress, 0, default.IpCountryCodes.Length - 1);

    if (Index >= 0)
    {
        default.IpCountryCodes.Insert(Index, 1);
        default.IpCountryCodes[Index].IpAddress = IpAddress;
        default.IpCountryCodes[Index].CountryCode = CountryCode;
        return Index;
    }

    return -1;
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

    if (default.bIsEnabled == false)
    {
        // Service is disabled, ignore.
        return;
    }

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
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

    if (CountryCode == "")
    {
        return;
    }

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

    for (i = 0; i < default.IpCountryCodes.Length; ++i)
    {
        Log(default.IpCountryCodes[i].IpAddress $ ":" @ default.IpCountryCodes[i].CountryCode);
    }
}

defaultproperties
{
    bIsEnabled=false
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
    CountryCodes(26)="BQ"   // Caribbean Netherlands
    CountryCodes(27)="BA"   // Bosnia & Herzegovina
    CountryCodes(28)="BW"   // Botswana
    CountryCodes(29)="BR"   // Brazil
    CountryCodes(30)="IO"   // British Indian Ocean Territory
    CountryCodes(31)="BN"   // Brunei Darussalam

    CountryCodes(32)="BG"   // Bulgaria
    CountryCodes(33)="BF"   // Burkina Faso
    CountryCodes(34)="BI"   // Burindi
    CountryCodes(35)="KH"   // Cambodia
    CountryCodes(36)="CM"   // Cameroon
    CountryCodes(37)="CA"   // Canada
    CountryCodes(38)="CV"   // Cape Verde
    CountryCodes(39)="KY"   // Cayman Islands
    CountryCodes(40)="CF"   // Central African Republic
    CountryCodes(41)="TD"   // Chad
    CountryCodes(42)="CL"   // Chile
    CountryCodes(43)="CN"   // China
    CountryCodes(44)="CX"   // Christmas Island
    CountryCodes(45)="CC"   // Cocos (Keeling) Islands
    CountryCodes(46)="CO"   // Colombia
    CountryCodes(47)="KM"   // Comoros

    CountryCodes(48)="CG"   // Republic of the Congo
    CountryCodes(49)="CD"   // Democratic Republic of the Congo
    CountryCodes(50)="CK"   // Cook Islands
    CountryCodes(51)="CR"   // Costa Rica
    CountryCodes(52)="CI"   // Ivory Coast
    CountryCodes(53)="HR"   // Croatia
    CountryCodes(54)="CU"   // Cuba
    CountryCodes(55)="CW"   // Curaçao
    CountryCodes(56)="CY"   // Cyprus
    CountryCodes(57)="CZ"   // Czech Republic
    CountryCodes(58)="DK"   // Denmark
    CountryCodes(59)="DJ"   // Djibouti
    CountryCodes(60)="DM"   // Dominica
    CountryCodes(61)="DO"   // Dominican Republic
    CountryCodes(62)="EC"   // Ecuador
    CountryCodes(63)="EG"   // Egypt

    CountryCodes(64)="SV"   // El Salvador
    CountryCodes(65)="GQ"   // Equatorial Guinea
    CountryCodes(66)="ER"   // Eritrea
    CountryCodes(67)="EE"   // Estonia
    CountryCodes(68)="ET"   // Ethiopia
    CountryCodes(69)="FK"   // Falkland Island
    CountryCodes(70)="FO"   // Faroe Islands
    CountryCodes(71)="FJ"   // Fiji
    CountryCodes(72)="FI"   // Finland
    CountryCodes(73)="FR"   // France
    CountryCodes(74)="GF"   // French Guiana
    CountryCodes(75)="PF"   // French Polynesia
    CountryCodes(76)="TF"   // French Southern and Antarctic Lands
    CountryCodes(77)="GA"   // Gabon
    CountryCodes(78)="GM"   // Gambia
    CountryCodes(79)="GE"   // Georgia

    CountryCodes(80)="DE"   // Germany
    CountryCodes(81)="GH"   // Ghana
    CountryCodes(82)="GI"   // Gibraltar
    CountryCodes(83)="GR"   // Greece
    CountryCodes(84)="GL"   // Greenland
    CountryCodes(85)="GD"   // Grenada
    CountryCodes(86)="GP"   // Guadeloupe
    CountryCodes(87)="GU"   // Guam
    CountryCodes(88)="GT"   // Guatemala
    CountryCodes(89)="GG"   // Guernsey
    CountryCodes(90)="GN"   // Guinea
    CountryCodes(91)="GW"   // Guinea-Bissau
    CountryCodes(92)="GY"   // Guyana
    CountryCodes(93)="HT"   // Haiti
    CountryCodes(94)="VA"   // The Holy See
    CountryCodes(95)="HN"   // Honduras

    CountryCodes(96)="HK"   // Hong Kong
    CountryCodes(97)="HU"   // Hungary
    CountryCodes(98)="IS"   // Iceland
    CountryCodes(99)="IN"   // India
    CountryCodes(100)="ID"  // Indonesia
    CountryCodes(101)="IR"  // Iran
    CountryCodes(102)="IQ"  // Iraq
    CountryCodes(103)="IE"  // Ireland
    CountryCodes(104)="IM"  // Isle of Man
    CountryCodes(105)="IL"  // Israel
    CountryCodes(106)="IT"  // Italy
    CountryCodes(107)="JM"  // Jamaica
    CountryCodes(108)="JP"  // Japan
    CountryCodes(109)="JE"  // Jersey
    CountryCodes(110)="JO"  // Jordan
    CountryCodes(111)="KZ"  // Kazakhstan

    CountryCodes(112)="KE"  // Kenya
    CountryCodes(113)="KI"  // Kiribati
    CountryCodes(114)="KP"  // North Korea
    CountryCodes(115)="KR"  // South Korea
    CountryCodes(116)="KW"  // Kuwait
    CountryCodes(117)="KG"  // Kyrgyzstan
    CountryCodes(118)="LA"  // Lao People's Democratic Republic
    CountryCodes(119)="LV"  // Latvia
    CountryCodes(120)="LB"  // Lebanon
    CountryCodes(121)="LS"  // Lesotho
    CountryCodes(122)="LR"  // Liberia
    CountryCodes(123)="LY"  // Libya
    CountryCodes(124)="LI"  // Liechtenstein
    CountryCodes(125)="LT"  // Lithuania
    CountryCodes(126)="LU"  // Luxembourg
    CountryCodes(127)="MO"  // Macau

    CountryCodes(128)="MK"  // North Macedonia
    CountryCodes(129)="MG"  // Madagascar
    CountryCodes(130)="MW"  // Malawi
    CountryCodes(131)="MY"  // Malaysia
    CountryCodes(132)="MV"  // Maldives
    CountryCodes(133)="ML"  // Mali
    CountryCodes(134)="MT"  // Malta
    CountryCodes(135)="MH"  // Marshall Islands
    CountryCodes(136)="MQ"  // Martinique
    CountryCodes(137)="MR"  // Mauritania
    CountryCodes(138)="MU"  // Mauritius
    CountryCodes(139)="YT"  // Mayotte
    CountryCodes(140)="MX"  // Mexico
    CountryCodes(141)="FM"  // Federated States of Micronesia
    CountryCodes(142)="MD"  // Moldova
    CountryCodes(143)="MC"  // Monaco

    CountryCodes(144)="MN"  // Mongolia
    CountryCodes(145)="ME"  // Montenegro
    CountryCodes(146)="MS"  // Montserrat
    CountryCodes(147)="MA"  // Morocco
    CountryCodes(148)="MZ"  // Mozambique
    CountryCodes(149)="MM"  // Myanmar
    CountryCodes(150)="NA"  // Namibia
    CountryCodes(151)="NR"  // Nauru
    CountryCodes(152)="NP"  // Nepal
    CountryCodes(153)="NL"  // Netherlands
    CountryCodes(154)="NC"  // New Caledonia
    CountryCodes(155)="NZ"  // New Zealand
    CountryCodes(156)="NI"  // Nicaragua
    CountryCodes(157)="NE"  // Niger
    CountryCodes(158)="NG"  // Nigeria
    CountryCodes(159)="NU"  // Niue

    CountryCodes(160)="NF"  // Norfolk Island
    CountryCodes(161)="MP"  // Northern Mariana Islands
    CountryCodes(162)="NO"  // Norway
    CountryCodes(163)="OM"  // Oman
    CountryCodes(164)="PK"  // Pakistan
    CountryCodes(165)="PW"  // Palau
    CountryCodes(166)="PS"  // State of Palestine
    CountryCodes(167)="PA"  // Panama
    CountryCodes(168)="PG"  // Papua New Guinea
    CountryCodes(169)="PY"  // Paraguay
    CountryCodes(170)="PE"  // Peru
    CountryCodes(171)="PH"  // Philippines
    CountryCodes(172)="PN"  // Pitcairn
    CountryCodes(173)="PL"  // Poland
    CountryCodes(174)="PT"  // Portugal
    CountryCodes(175)="PR"  // Puerto Rico

    CountryCodes(176)="QA"  // Qatar
    CountryCodes(177)="RE"  // Réunion
    CountryCodes(178)="RO"  // Romania
    CountryCodes(179)="RU"  // Russia
    CountryCodes(180)="RW"  // Rwanda
    CountryCodes(181)="BL"  // Saint Barthélemy
    CountryCodes(182)="SH"  // Saint Helena, Ancension Island, Tristan da Cunha
    CountryCodes(183)="KN"  // Saint Kitts and Nevis
    CountryCodes(184)="LC"  // Saint Lucia
    CountryCodes(185)="MF"  // Saint Martin
    CountryCodes(186)="PM"  // Saint Pierre and Miquelon
    CountryCodes(187)="VC"  // Saint Vincent and the Grenadines
    CountryCodes(188)="WS"  // Samoa
    CountryCodes(189)="SM"  // San Marino
    CountryCodes(190)="ST"  // São Tomé and Príncipe
    CountryCodes(191)="SA"  // Saudi Arabia

    CountryCodes(192)="SN"  // Senegal
    CountryCodes(193)="RS"  // Serbia
    CountryCodes(194)="SC"  // Seychelles
    CountryCodes(195)="SL"  // Sierra Leone
    CountryCodes(196)="SG"  // Singapore
    CountryCodes(197)="SX"  // Sint Maarten
    CountryCodes(198)="SK"  // Slovakia
    CountryCodes(199)="SI"  // Slovenia
    CountryCodes(200)="SB"  // Solomon Islands
    CountryCodes(201)="SO"  // Somalia
    CountryCodes(202)="ZA"  // South Africa
    CountryCodes(203)="GS"  // South Georgia and the South Sandwich Islands
    CountryCodes(204)="SS"  // South Sudan
    CountryCodes(205)="ES"  // Spain
    CountryCodes(206)="LK"  // Sri Lanka
    CountryCodes(207)="SD"  // Sudan

    CountryCodes(208)="SR"  // Suriname
    CountryCodes(209)="SZ"  // Eswatini
    CountryCodes(210)="SE"  // Sweden
    CountryCodes(211)="CH"  // Switzerland
    CountryCodes(212)="SY"  // Syria
    CountryCodes(213)="TW"  // Taiwan
    CountryCodes(214)="TJ"  // Tajikistan
    CountryCodes(215)="TZ"  // Tanzania
    CountryCodes(216)="TH"  // Thailand
    CountryCodes(217)="TL"  // East Timor
    CountryCodes(218)="TG"  // Togo
    CountryCodes(219)="TK"  // Tokelau
    CountryCodes(220)="TO"  // Tonga
    CountryCodes(221)="TT"  // Trinidad and Tobago
    CountryCodes(222)="TN"  // Tunisia
    CountryCodes(223)="TR"  // Turkey

    CountryCodes(224)="TM"  // Turkmenistan
    CountryCodes(225)="TC"  // Turks and Caicos Islands
    CountryCodes(226)="TV"  // Tuvalu
    CountryCodes(227)="UG"  // Uganda
    CountryCodes(228)="UA"  // Ukraine
    CountryCodes(229)="AE"  // United Arab Emirates
    CountryCodes(230)="GB"  // United Kingdom
    CountryCodes(231)="US"  // United States of America
    CountryCodes(232)="UY"  // Uruguay
    CountryCodes(233)="UZ"  // Uzbekistan
    CountryCodes(234)="VU"  // Vanuatu
    CountryCodes(235)="VE"  // Venezuela
    CountryCodes(236)="VN"  // Vietnam
    CountryCodes(237)="VG"  // British Virgin Islands
    CountryCodes(238)="VI"  // United States Virgin Islands
    CountryCodes(239)="WF"  // Wallis and Futuna

    CountryCodes(240)="EH"  // Western Sahara
    CountryCodes(241)="YE"  // Yemen
    CountryCodes(242)="ZM"  // Zambia
    CountryCodes(243)="ZW"  // Zimbaywe
}

