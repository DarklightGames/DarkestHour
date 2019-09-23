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
    CountryCodes(31)="IO"   // British Indian Ocean Territory
    CountryCodes(32)="BN"   // Brunei Darussalam

    CountryCodes(33)="BG"   // Bulgaria
    CountryCodes(34)="BF"   // Burkina Faso
    CountryCodes(35)="BI"   // Burindi
    CountryCodes(36)="KH"   // Cambodia
    CountryCodes(37)="CM"   // Cameroon
    CountryCodes(38)="CA"   // Canada
    CountryCodes(39)="CV"   // Cape Verde
    CountryCodes(40)="KY"   // Cayman Islands
    CountryCodes(41)="CF"   // Central African Republic
    CountryCodes(42)="TD"   // Chad
    CountryCodes(43)="CL"   // Chile
    CountryCodes(44)="CN"   // China
    CountryCodes(45)="CX"   // Christmas Island
    CountryCodes(46)="CC"   // Cocos (Keeling) Islands
    CountryCodes(47)="CO"   // Colombia
    CountryCodes(48)="KM"   // Comoros

    CountryCodes(49)="CG"   // Republic of the Congo
    CountryCodes(50)="CD"   // Democratic Republic of the Congo
    CountryCodes(51)="CK"   // Cook Islands
    CountryCodes(52)="CR"   // Costa Rica
    CountryCodes(53)="CI"   // Ivory Coast
    CountryCodes(54)="HR"   // Croatia
    CountryCodes(55)="CU"   // Cuba
    CountryCodes(56)="CW"   // Curaçao
    CountryCodes(57)="CY"   // Cyprus
    CountryCodes(58)="CZ"   // Czech Republic
    CountryCodes(59)="DK"   // Denmark
    CountryCodes(60)="DJ"   // Djibouti
    CountryCodes(61)="DM"   // Dominica
    CountryCodes(62)="DO"   // Dominican Republic
    CountryCodes(63)="EC"   // Ecuador
    CountryCodes(64)="EG"   // Egypt

    CountryCodes(65)="SV"   // El Salvador
    CountryCodes(66)="GQ"   // Equatorial Guinea
    CountryCodes(67)="ER"   // Eritrea
    CountryCodes(68)="EE"   // Estonia
    CountryCodes(69)="ET"   // Ethiopia
    CountryCodes(70)="FK"   // Falkland Island
    CountryCodes(71)="FO"   // Faroe Islands
    CountryCodes(72)="FJ"   // Fiji
    CountryCodes(73)="FI"   // Finland
    CountryCodes(74)="FR"   // France
    CountryCodes(75)="GF"   // French Guiana
    CountryCodes(76)="PF"   // French Polynesia
    CountryCodes(77)="TF"   // French Southern and Antarctic Lands
    CountryCodes(78)="GA"   // Gabon
    CountryCodes(79)="GM"   // Gambia
    CountryCodes(80)="GE"   // Georgia

    CountryCodes(81)="DE"   // Germany
    CountryCodes(82)="GH"   // Ghana
    CountryCodes(83)="GI"   // Gibraltar
    CountryCodes(84)="GR"   // Greece
    CountryCodes(85)="GL"   // Greenland
    CountryCodes(86)="GD"   // Grenada
    CountryCodes(87)="GP"   // Guadeloupe
    CountryCodes(88)="GU"   // Guam
    CountryCodes(89)="GT"   // Guatemala
    CountryCodes(90)="GG"   // Guernsey
    CountryCodes(91)="GN"   // Guinea
    CountryCodes(92)="GW"   // Guinea-Bissau
    CountryCodes(93)="GY"   // Guyana
    CountryCodes(94)="HT"   // Haiti
    CountryCodes(95)="VA"   // The Holy See
    CountryCodes(96)="HN"   // Honduras

    CountryCodes(97)="HK"   // Hong Kong
    CountryCodes(98)="HU"   // Hungary
    CountryCodes(99)="IS"   // Iceland
    CountryCodes(100)="IN"  // India
    CountryCodes(101)="ID"  // Indonesia
    CountryCodes(102)="IR"  // Iran
    CountryCodes(103)="IQ"  // Iraq
    CountryCodes(104)="IE"  // Ireland
    CountryCodes(105)="IM"  // Isle of Man
    CountryCodes(106)="IL"  // Israel
    CountryCodes(107)="IT"  // Italy
    CountryCodes(108)="JM"  // Jamaica
    CountryCodes(109)="JP"  // Japan
    CountryCodes(110)="JE"  // Jersey
    CountryCodes(111)="JO"  // Jordan
    CountryCodes(112)="KZ"  // Kazakhstan

    CountryCodes(113)="KE"  // Kenya
    CountryCodes(114)="KI"  // Kiribati
    CountryCodes(115)="KP"  // North Korea
    CountryCodes(116)="KR"  // South Korea
    CountryCodes(117)="KW"  // Kuwait
    CountryCodes(118)="KG"  // Kyrgyzstan
    CountryCodes(119)="LA"  // Lao People's Democratic Republic
    CountryCodes(120)="LV"  // Latvia
    CountryCodes(121)="LB"  // Lebanon
    CountryCodes(122)="LS"  // Lesotho
    CountryCodes(123)="LR"  // Liberia
    CountryCodes(124)="LY"  // Libya
    CountryCodes(125)="LI"  // Liechtenstein
    CountryCodes(126)="LT"  // Lithuania
    CountryCodes(127)="LU"  // Luxembourg
    CountryCodes(128)="MO"  // Macau

    CountryCodes(129)="MK"  // North Macedonia
    CountryCodes(130)="MG"  // Madagascar
    CountryCodes(131)="MW"  // Malawi
    CountryCodes(132)="MY"  // Malaysia
    CountryCodes(133)="MV"  // Maldives
    CountryCodes(134)="ML"  // Mali
    CountryCodes(135)="MT"  // Malta
    CountryCodes(136)="MH"  // Marshall Islands
    CountryCodes(137)="MQ"  // Martinique
    CountryCodes(138)="MR"  // Mauritania
    CountryCodes(139)="MU"  // Mauritius
    CountryCodes(140)="YT"  // Mayotte
    CountryCodes(141)="MX"  // Mexico
    CountryCodes(142)="FM"  // Federated States of Micronesia
    CountryCodes(143)="MD"  // Moldova
    CountryCodes(144)="MC"  // Monaco

    CountryCodes(145)="MN"  // Mongolia
    CountryCodes(146)="ME"  // Montenegro
    CountryCodes(147)="MS"  // Montserrat
    CountryCodes(148)="MA"  // Morocco
    CountryCodes(149)="MZ"  // Mozambique
    CountryCodes(150)="MM"  // Myanmar
    CountryCodes(151)="NA"  // Namibia
    CountryCodes(152)="NR"  // Nauru
    CountryCodes(153)="NP"  // Nepal
    CountryCodes(154)="NL"  // Netherlands
    CountryCodes(155)="NC"  // New Caledonia
    CountryCodes(156)="NZ"  // New Zealand
    CountryCodes(157)="NI"  // Nicaragua
    CountryCodes(158)="NE"  // Niger
    CountryCodes(159)="NG"  // Nigeria
    CountryCodes(160)="NU"  // Niue

    CountryCodes(161)="NF"  // Norfolk Island
    CountryCodes(162)="MP"  // Northern Mariana Islands
    CountryCodes(163)="NO"  // Norway
    CountryCodes(164)="OM"  // Oman
    CountryCodes(165)="PK"  // Pakistan
    CountryCodes(166)="PW"  // Palau
    CountryCodes(167)="PS"  // State of Palestine
    CountryCodes(168)="PA"  // Panama
    CountryCodes(169)="PG"  // Papua New Guinea
    CountryCodes(170)="PY"  // Paraguay
    CountryCodes(171)="PE"  // Peru
    CountryCodes(172)="PH"  // Philippines
    CountryCodes(173)="PN"  // Pitcairn
    CountryCodes(174)="PL"  // Poland
    CountryCodes(175)="PT"  // Portugal
    CountryCodes(176)="PR"  // Puerto Rico

    CountryCodes(177)="QA"  // Qatar
    CountryCodes(178)="RE"  // Réunion
    CountryCodes(179)="RO"  // Romania
    CountryCodes(180)="RU"  // Russia
    CountryCodes(181)="RW"  // Rwanda
    CountryCodes(182)="BL"  // Saint Barthélemy
    CountryCodes(183)="SH"  // Saint Helena, Ancension Island, Tristan da Cunha
    CountryCodes(184)="KN"  // Saint Kitts and Nevis
    CountryCodes(185)="LC"  // Saint Lucia
    CountryCodes(186)="MF"  // Saint Martin
    CountryCodes(187)="PM"  // Saint Pierre and Miquelon
    CountryCodes(188)="VC"  // Saint Vincent and the Grenadines
    CountryCodes(189)="WS"  // Samoa
    CountryCodes(190)="SM"  // San Marino
    CountryCodes(191)="ST"  // São Tomé and Príncipe
    CountryCodes(192)="SA"  // Saudi Arabia

    CountryCodes(193)="SN"  // Senegal
    CountryCodes(194)="RS"  // Serbia
    CountryCodes(195)="SC"  // Seychelles
    CountryCodes(196)="SL"  // Sierra Leone
    CountryCodes(197)="SG"  // Singapore
    CountryCodes(198)="SX"  // Sint Maarten
    CountryCodes(199)="SK"  // Slovakia
    CountryCodes(200)="SI"  // Slovenia
    CountryCodes(201)="SB"  // Solomon Islands
    CountryCodes(202)="SO"  // Somalia
    CountryCodes(203)="ZA"  // South Africa
    CountryCodes(204)="GS"  // South Georgia and the South Sandwich Islands
    CountryCodes(205)="SS"  // South Sudan
    CountryCodes(206)="ES"  // Spain
    CountryCodes(207)="LK"  // Sri Lanka
    CountryCodes(208)="SD"  // Sudan

    CountryCodes(209)="SR"  // Suriname
    CountryCodes(210)="SZ"  // Eswatini
    CountryCodes(211)="SE"  // Sweden
    CountryCodes(212)="CH"  // Switzerland
    CountryCodes(213)="SY"  // Syria
    CountryCodes(214)="TW"  // Taiwan
    CountryCodes(215)="TJ"  // Tajikistan
    CountryCodes(216)="TZ"  // Tanzania
    CountryCodes(217)="TH"  // Thailand
    CountryCodes(218)="TL"  // East Timor
    CountryCodes(219)="TG"  // Togo
    CountryCodes(220)="TK"  // Tokelau
    CountryCodes(221)="TO"  // Tonga
    CountryCodes(222)="TT"  // Trinidad and Tobago
    CountryCodes(223)="TN"  // Tunisia
    CountryCodes(224)="TR"  // Turkey

    CountryCodes(225)="TM"  // Turkmenistan
    CountryCodes(226)="TC"  // Turks and Caicos Islands
    CountryCodes(227)="TV"  // Tuvalu
    CountryCodes(228)="UG"  // Uganda
    CountryCodes(229)="UA"  // Ukraine
    CountryCodes(230)="AE"  // United Arab Emirates
    CountryCodes(231)="GB"  // United Kingdom
    CountryCodes(232)="US"  // United States of America
    CountryCodes(233)="UY"  // Uruguay
    CountryCodes(234)="UZ"  // Uzbekistan
    CountryCodes(235)="VU"  // Vanuatu
    CountryCodes(236)="VE"  // Venezuela
    CountryCodes(237)="VN"  // Vietnam
    CountryCodes(238)="VG"  // British Virgin Islands
    CountryCodes(239)="VI"  // United States Virgin Islands
    CountryCodes(240)="WF"  // Wallis and Futuna

    CountryCodes(241)="EH"  // Western Sahara
    CountryCodes(242)="YE"  // Yemen
    CountryCodes(243)="ZM"  // Zambia
    CountryCodes(244)="ZW"  // Zimbaywe
}

