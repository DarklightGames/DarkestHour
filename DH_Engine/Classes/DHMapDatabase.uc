//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapDatabase extends Object;

enum EMapSource
{
    SOURCE_Official,
    SOURCE_Community
};

enum EMapSize
{
    SIZE_Any,           // 0-64 players
    SIZE_ExtraSmall,    // 0-24 players
    SIZE_Small,         // 0-48 players
    SIZE_Medium,        // 24-64 players
    SIZE_Large,         // 48-64 players
    Size_ExtraLarge     // 54-64 players
};

enum EMapGameType
{
    GAMETYPE_Advance,
    GAMETYPE_Clash,
    GAMETYPE_Push,
    GAMETYPE_Defence,
    GAMETYPE_Stalemate
};

struct SMapInfo
{
    var string Name;
    var EMapSource Source;
    var EMapSize Size;
    var EMapGameType GameType;
    var DH_LevelInfo.EAlliedNation AlliedNation;
};

var array<SMapInfo>         MapInfos;
var HashTable_string_int    MapInfoIndexTable;

function Initialize()
{
    BuildMapInfos();
}

static function string GetMapSourceString(EMapSource MapSource)
{
    switch (MapSource)
    {
        case SOURCE_Official:
            return "Official";
        case SOURCE_Community:
            return "Community";
        default:
            return "Invalid source";
    }
}

static function string GetMapGameTypeString(EMapGameType GameType)
{
    switch (GameType)
    {
        case GAMETYPE_Advance:
            return "Advance";
        case GAMETYPE_Clash:
            return "Clash";
        case GAMETYPE_Push:
            return "Push";
        case GAMETYPE_Defence:
            return "Defence";
        case GAMETYPE_Stalemate:
            return "Stalemate";
        default:
            return "Unknown";
    }
}

static function string GetMapSizeString(EMapSize Size)
{
    switch (Size)
    {
        case SIZE_Any:
            return "Any";
        case SIZE_ExtraSmall:
            return "Extra Small";
        case SIZE_Small:
            return "Small";
        case SIZE_Medium:
            return "Medium";
        case SIZE_Large:
            return "Large";
        case SIZE_ExtraLarge:
            return "Extra Large";
    }
}

static function string GetAlliedNationString(DH_LevelInfo.EAlliedNation AlliedNation)
{
    switch (AlliedNation)
    {
        case NATION_USA:
            return "USA";
        case NATION_Britain:
            return "Britain";
        case NATION_Canada:
            return "Canada";
        case NATION_USSR:
            return "USSR";
        case NATION_Poland:
            return "Poland";
    }
}

static function GetMapSizePlayerCountRange(EMapSize Size, out int PlayersMin, out int PlayersMax)
{
    switch (Size)
    {
        case SIZE_ExtraSmall:
            PlayersMin = 0;
            PlayersMax = 24;
            break;
        case SIZE_Small:
            PlayersMin = 0;
            PlayersMax = 48;
            break;
        case Size_Medium:
            PlayersMin = 24;
            PlayersMax = 48;
            break;
        case SIZE_Large:
            PlayersMin = 48;
            PlayersMax = 64;
            break;
        case SIZE_ExtraLarge:
            PlayersMin = 54;
            PlayersMax = 64;
            break;
        case SIZE_Any:
        default:
            PlayersMin = 0;
            PlayersMax = 64;
            break;
    }
}

function BuildMapInfos()
{
    local int i;

    // Build the index table for O(1) map info lookups by name
    MapInfoIndexTable = class'HashTable_string_int'.static.Create(MapInfos.Length);

    for (i = 0; i < MapInfos.Length; ++i)
    {
        MapInfoIndexTable.Put(Locs(MapInfos[i].Name), i);
    }
}

function bool GetMapInfo(string MapName, out SMapInfo MI)
{
    local int Index;

    if (MapInfoIndexTable.Get(Locs(MapName), Index))
    {
        MI = MapInfos[Index];
        return true;
    }

    return false;
}

function bool IsMapOfficial(string MapName)
{
    local SMapInfo MI;

    if (GetMapInfo(MapName, MI))
    {
        return MI.Source == SOURCE_Official;
    }

    return false;
}

static function bool StaticIsMapOfficial(string MapName)
{
    local int i;

    for (i = 0; i < default.MapInfos.Length; ++i)
    {
        if (default.MapInfos[i].Name ~= MapName)
        {
            return default.MapInfos[i].Source == SOURCE_Official;
        }
    }

    return false;
}

static function EMapSource StaticGetMapSource(string MapName)
{
    local int i;

    for (i = 0; i < default.MapInfos.Length; ++i)
    {
        if (default.MapInfos[i].Name ~= MapName)
        {
            return default.MapInfos[i].Source;
        }
    }

    return SOURCE_Community;
}

static function string StaticGetMapSourceString(string MapName)
{
    return static.GetMapSourceString(static.StaticGetMapSource(MapName));
}

static function string GetHumanReadableMapName(string MapName)
{
    return Repl(Repl(Repl(MapName, "_", " "), ".rom", ""), "DH-", "");
}

defaultproperties
{
    MapInfos(0)=(Name="DH-St_Marie_du_Mont_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(1)=(Name="DH-Barashka_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(2)=(Name="DH-Bois_Jacques_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(3)=(Name="DH-Brecourt_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(4)=(Name="DH-Bridgehead_Advance.rom",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(5)=(Name="DH-Caen_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(6)=(Name="DH-Cambes-En-Plaine_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(7)=(Name="DH-Carentan_Causeway_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(8)=(Name="DH-Carentan_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(9)=(Name="DH-Carpiquet_Airfield_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(10)=(Name="DH-Cheneux_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(11)=(Name="DH-Dead_Man's_Corner_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(12)=(Name="DH-Dog_Green_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(13)=(Name="DH-Donner_Stalemate.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(14)=(Name="DH-Falaise_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(15)=(Name="DH-Flakturm_Tiergarten_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(16)=(Name="DH-Foucarville_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(17)=(Name="DH-Foy_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(18)=(Name="DH-Ginkel_Heath_Push.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(19)=(Name="DH-Gorlitz_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(20)=(Name="DH-Hattert_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(21)=(Name="DH-Hedgerow_Hell_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(22)=(Name="DH-Hill_108_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(23)=(Name="DH-Hill_400_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(24)=(Name="DH-Hurtgenwald_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(25)=(Name="DH-Juno_Beach_Push.rom",AlliedNation=NATION_Canada,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(26)=(Name="DH-Konigsplatz_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(27)=(Name="DH-Kriegstadt_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(28)=(Name="DH-La_Cambe_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(29)=(Name="DH-La_Chapelle_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(30)=(Name="DH-La_Gleize_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(31)=(Name="DH-La_Gleize_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(32)=(Name="DH-Lutremange_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(33)=(Name="DH-Lutremange_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Large)
    MapInfos(34)=(Name="DH-Noville_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(35)=(Name="DH-Noville_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(36)=(Name="DH-Nuenen_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_ExtraLarge)
    MapInfos(37)=(Name="DH-Oosterbeek_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(38)=(Name="DH-Pariserplatz_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(39)=(Name="DH-Poteau_Ambush_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(40)=(Name="DH-Putot-en-Bessin_Advance.rom",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(41)=(Name="DH-Radar_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(42)=(Name="DH-Raids_Push.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(43)=(Name="DH-Rakowice_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(44)=(Name="DH-Reichswald_Push.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(45)=(Name="DH-Simonskall_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(46)=(Name="DH-St-Clement_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(47)=(Name="DH-Stavelot_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(48)=(Name="DH-Stoumont_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(49)=(Name="DH-Stoumont_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(50)=(Name="DH-Targnon_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(51)=(Name="DH-Varaville_Advance.rom",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(52)=(Name="DH-Vierville_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(53)=(Name="DH-Vossenack_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(54)=(Name="DH-Arad_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(55)=(Name="DH-Arnhem_Bridge_Push.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Large)
    MapInfos(56)=(Name="DH-Berezina_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(57)=(Name="DH-Black_Day_July_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(58)=(Name="DH-Butovo_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(59)=(Name="DH-Chambois_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(60)=(Name="DH-Champs_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(61)=(Name="DH-Cholm_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(62)=(Name="DH-Danzig_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(63)=(Name="DH-Dom-Pavlova_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(64)=(Name="DH-Kasserine_Pass_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(65)=(Name="DH-Klin1941_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(66)=(Name="DH-Kriegstadt_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(67)=(Name="DH-Leningrad_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(68)=(Name="DH-Leszinow_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Small)
    MapInfos(69)=(Name="DH-Makhnovo_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(70)=(Name="DH-Maupertus_Push.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(71)=(Name="DH-MyshkovaRiver_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(72)=(Name="DH-Odessa_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(73)=(Name="DH-Ogledow_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(74)=(Name="DH-Pegasus_Bridge_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(75)=(Name="DH-Pointe_Du_Hoc_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(76)=(Name="DH-Poteau_Ambush_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(77)=(Name="DH-Prussia_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(78)=(Name="DH-Ramelle_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(79)=(Name="DH-Riga_Docks_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(80)=(Name="DH-Rhine_River_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_ExtraLarge)
    MapInfos(81)=(Name="DH-Salaca_River_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(82)=(Name="DH-San_Valentino_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(83)=(Name="DH-Schijndel_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(84)=(Name="DH-Smolensk_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Small)
    MapInfos(85)=(Name="DH-Turqueville_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(86)=(Name="DH-TulaOutskirts_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(87)=(Name="DH-Winter_Stalemate_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(88)=(Name="DH-Bridge_Assault_Stalemate.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(89)=(Name="DH-Remagen_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Small)
    MapInfos(90)=(Name="DH-Krasnyi_Oktyabr_Defence.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(91)=(Name="DH-Lyes_Krovy_Defence.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Small)
    MapInfos(92)=(Name="DH-Rederitz_Advance.rom",AlliedNation=NATION_Poland,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(93)=(Name="DH-Flakturm_Tiergarten_Defence.rom",AlliedNation=NATION_Poland,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(94)=(Name="DH-Grey_Ghosts_of_War_Stalemate.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(95)=(Name="DH-Olkhovatka_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(96)=(Name="DH-Nyiregyhaza_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(97)=(Name="DH-Kryukovo_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(98)=(Name="DH-Godolloi_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(99)=(Name="DH-FallenHeroes_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(100)=(Name="DH-Pariserplatz_Defence.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(101)=(Name="DH-Merderet_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(102)=(Name="DH-La_Fiere_Day_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(103)=(Name="DH-La_Fiere_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(104)=(Name="DH-Kommerscheidt_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(105)=(Name="DH-Hurtgenwald_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(106)=(Name="DH-Wanne_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(107)=(Name="DH-Fury_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(108)=(Name="DH-OmahaBeach_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(109)=(Name="DH-Road_To_Isigny_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(110)=(Name="DH-GunAssault_Push.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(111)=(Name="DH-Rakowice_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(112)=(Name="DH-Reichswald_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(113)=(Name="DH-Red_God_Of_War_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Large)
    MapInfos(114)=(Name="DH-Rabenheck_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_ExtraLarge)
    MapInfos(115)=(Name="DH-Hedgerow_Hell_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(116)=(Name="DH-Valko_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(117)=(Name="DH-Cheneux_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(118)=(Name="DH-Zhitomir1941_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(119)=(Name="DH-Ten_Aard_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_ExtraLarge)
    MapInfos(120)=(Name="DH-StalingradKessel_Push.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(121)=(Name="DH-Armored_AlteZiegelei_Stalemate.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_Any)
    MapInfos(122)=(Name="DH-Armored_Arad_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(123)=(Name="DH-Armored_Balaton_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(124)=(Name="DH-Armored_Bautzen_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(125)=(Name="DH-Armored_Black_Day_July_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(126)=(Name="DH-Armored_Brenus_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(127)=(Name="DH-Armored_Cagny_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(128)=(Name="DH-Armored_Celles_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(129)=(Name="DH-Armored_Debrecen_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(130)=(Name="DH-Armored_Eindhoven_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(131)=(Name="DH-Armored_Freyneux_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(132)=(Name="DH-Armored_Fruhlingserwachen_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(133)=(Name="DH-Armored_Gran_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(134)=(Name="DH-Armored_Hill112_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(135)=(Name="DH-Armored_Hunters_Woods_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(136)=(Name="DH-Armored_Kasserine_Pass_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(137)=(Name="DH-Armored_Kharkov_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(138)=(Name="DH-Armored_Kommerscheidt_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(139)=(Name="DH-Armored_KrivoiRog_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(140)=(Name="DH-Armored_La_Champagne_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(141)=(Name="DH-Armored_La_Feuillie_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(142)=(Name="DH-Armored_La_Monderie_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(143)=(Name="DH-Armored_Lemberg_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(144)=(Name="DH-Armored_Mannikkala_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(145)=(Name="DH-Armored_Maslova_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(146)=(Name="DH-Armored_Mickistein_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(147)=(Name="DH-Armored_Orel_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(148)=(Name="DH-Armored_Panzerschlacht_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(149)=(Name="DH-Armored_Preaux_Clash.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(150)=(Name="DH-Armored_Raid_to_Bastogne_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(151)=(Name="DH-Armored_Road_to_Leningrad_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(152)=(Name="DH-Armored_Studzianki_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(153)=(Name="DH-Armored_Suedwind_Advance.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(154)=(Name="DH-Armored_Tank_Clash_At_Bastogne_Advance.rom",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(155)=(Name="DH-Armored_Tractable_Advance.rom",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(156)=(Name="DH-Armored_Voronezh_Clash.rom",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(157)=(Name="DH-Armored_Cagny_Recon_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(158)=(Name="DH-Jurques_Advance.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(159)=(Name="DH-Jurques_Clash.rom",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Large)
}
