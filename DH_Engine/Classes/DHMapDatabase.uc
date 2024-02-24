//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapDatabase extends Object;

enum EMapSize
{
    SIZE_Any,           // 0-64 players
    SIZE_ExtraSmall,    // 0-24 players
    SIZE_Small,         // 0-48 players
    SIZE_Medium,        // 24-100 players
    SIZE_Large,         // 48-100 players
};

enum EMapGameType
{
    GAMETYPE_Advance,
    GAMETYPE_Clash,
    GAMETYPE_Push,
    GAMETYPE_Defence,
    GAMETYPE_Stalemate,
    GAMETYPE_Domination,
};

struct SMapInfo
{
    var string Name;
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
        case GAMETYPE_Domination:
            return "Domination";
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
            PlayersMax = 100;
            break;
        case SIZE_Large:
            PlayersMin = 48;
            PlayersMax = 100;
            break;
        case SIZE_Any:
        default:
            PlayersMin = 0;
            PlayersMax = 100;
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

    // Here we strip ".rom" extension because client might receive map names
    // with or without it. Local server will send map names with the extension,
    // but remote servers don't include it.
    if (MapInfoIndexTable.Get(Locs(Repl(MapName, ".rom", "")), Index))
    {
        MI = MapInfos[Index];
        return true;
    }

    return false;
}

static function string GetHumanReadableMapName(string MapName)
{
    return Repl(Repl(Repl(MapName, "_", " "), ".rom", ""), "DH-", "");
}

defaultproperties
{
    MapInfos(0)=(Name="DH-St_Marie_du_Mont_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(1)=(Name="DH-Barashka_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(2)=(Name="DH-Bois_Jacques_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(3)=(Name="DH-Brecourt_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(4)=(Name="DH-Bridgehead_Advance",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(5)=(Name="DH-Caen_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(6)=(Name="DH-Carentan_Causeway_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(7)=(Name="DH-Carentan_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(8)=(Name="DH-Carpiquet_Airfield_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(9)=(Name="DH-Cheneux_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(10)=(Name="DH-Dead_Man's_Corner_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(11)=(Name="DH-Dog_Green_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(12)=(Name="DH-Donner_Stalemate",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(13)=(Name="DH-Falaise_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(14)=(Name="DH-Flakturm_Tiergarten_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(15)=(Name="DH-Foucarville_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(16)=(Name="DH-Foy_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(17)=(Name="DH-Gorlitz_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(18)=(Name="DH-Hattert_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(19)=(Name="DH-Hill_108_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(20)=(Name="DH-Hill_400_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(21)=(Name="DH-Hurtgenwald_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(22)=(Name="DH-Juno_Beach_Push",AlliedNation=NATION_Canada,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(23)=(Name="DH-Konigsplatz_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(24)=(Name="DH-La_Cambe_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(25)=(Name="DH-La_Chapelle_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(26)=(Name="DH-La_Gleize_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(27)=(Name="DH-La_Gleize_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(28)=(Name="DH-Watrange_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(29)=(Name="DH-Watrange_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Large)
    MapInfos(30)=(Name="DH-Noville_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(31)=(Name="DH-Nuenen_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(32)=(Name="DH-Oosterbeek_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(33)=(Name="DH-Poteau_Ambush_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(34)=(Name="DH-Putot-en-Bessin_Advance",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(35)=(Name="DH-Radar_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(36)=(Name="DH-Raids_Push",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(37)=(Name="DH-Rakowice_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(38)=(Name="DH-Simonskall_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(39)=(Name="DH-St-Clement_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(40)=(Name="DH-Stavelot_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(41)=(Name="DH-Stoumont_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(42)=(Name="DH-Stoumont_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(43)=(Name="DH-Targnon_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(44)=(Name="DH-Varaville_Advance",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(45)=(Name="DH-Vierville_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(46)=(Name="DH-Vossenack_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(47)=(Name="DH-Arad_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(48)=(Name="DH-Arnhem_Bridge_Push",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Large)
    MapInfos(49)=(Name="DH-Berezina_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(50)=(Name="DH-Black_Day_July_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(51)=(Name="DH-Butovo_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(52)=(Name="DH-Chambois_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(53)=(Name="DH-Champs_d'Agonie_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(54)=(Name="DH-Cholm_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(55)=(Name="DH-Danzig_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(56)=(Name="DH-Dom-Pavlova_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(57)=(Name="DH-Kasserine_Pass_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(58)=(Name="DH-Klin1941_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(59)=(Name="DH-Kriegstadt_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(60)=(Name="DH-Leningrad_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(61)=(Name="DH-Leszinow_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Small)
    MapInfos(62)=(Name="DH-Makhnovo_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(63)=(Name="DH-Maupertus_Push",AlliedNation=NATION_Britain,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(64)=(Name="DH-MyshkovaRiver_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(65)=(Name="DH-Odessa_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(66)=(Name="DH-Ogledow_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(67)=(Name="DH-Pegasus_Bridge_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(68)=(Name="DH-Pointe_Du_Hoc_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(69)=(Name="DH-Poteau_Ambush_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(70)=(Name="DH-Prussia_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(71)=(Name="DH-Ramelle_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(72)=(Name="DH-Riga_Docks_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(73)=(Name="DH-Rhine_River_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(74)=(Name="DH-Salaca_River_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(75)=(Name="DH-San_Valentino_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(76)=(Name="DH-Schijndel_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(77)=(Name="DH-Smolensk_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Small)
    MapInfos(78)=(Name="DH-Turqueville_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_ExtraSmall)
    MapInfos(79)=(Name="DH-TulaOutskirts_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(80)=(Name="DH-Winter_Stalemate_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(81)=(Name="DH-Bridge_Assault_Stalemate",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(82)=(Name="DH-Remagen_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Small)
    MapInfos(83)=(Name="DH-Krasnyi_Oktyabr_Defence",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(84)=(Name="DH-Lyes_Krovy_Defence",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Small)
    MapInfos(85)=(Name="DH-Rederitz_Advance",AlliedNation=NATION_Poland,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(86)=(Name="DH-Flakturm_Tiergarten_Defence",AlliedNation=NATION_Poland,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(87)=(Name="DH-Grey_Ghosts_of_War_Stalemate",AlliedNation=NATION_USSR,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(88)=(Name="DH-Olkhovatka_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(89)=(Name="DH-Nyiregyhaza_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(90)=(Name="DH-Kryukovo_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(91)=(Name="DH-FallenHeroes_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Medium)
    MapInfos(92)=(Name="DH-Pariserplatz_Defence",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(93)=(Name="DH-La_Fiere_Day_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(94)=(Name="DH-La_Fiere_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(95)=(Name="DH-Kommerscheidt_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(96)=(Name="DH-Hurtgenwald_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(97)=(Name="DH-Wanne_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(98)=(Name="DH-OmahaBeach_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(99)=(Name="DH-Road_To_Isigny_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(100)=(Name="DH-GunAssault_Push",AlliedNation=NATION_USA,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(101)=(Name="DH-Rakowice_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(102)=(Name="DH-Reichswald_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(103)=(Name="DH-Red_God_Of_War_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(104)=(Name="DH-Rabenheck_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(105)=(Name="DH-Hedgerow_Hell_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(106)=(Name="DH-Valko_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(107)=(Name="DH-Cheneux_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(108)=(Name="DH-Zhitomir1941_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(109)=(Name="DH-Ten_Aard_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(110)=(Name="DH-StalingradKessel_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(111)=(Name="DH-Armored_AlteZiegelei_Stalemate",AlliedNation=NATION_USA,GameType=GAMETYPE_Stalemate,Size=SIZE_Any)
    MapInfos(112)=(Name="DH-Armored_Arad_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(113)=(Name="DH-Armored_Balaton_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(114)=(Name="DH-Armored_Bautzen_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(115)=(Name="DH-Armored_Black_Day_July_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(116)=(Name="DH-Armored_Brenus_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(117)=(Name="DH-Armored_Cagny_Clash",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(118)=(Name="DH-Armored_Celles_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(119)=(Name="DH-Armored_Eindhoven_Clash",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(120)=(Name="DH-Armored_Freyneux_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(121)=(Name="DH-Armored_Fruhlingserwachen_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Domination,Size=SIZE_Any)
    MapInfos(122)=(Name="DH-Armored_Gran_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(123)=(Name="DH-Armored_Hill112_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(124)=(Name="DH-Armored_Kasserine_Pass_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(125)=(Name="DH-Armored_Kharkov_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(126)=(Name="DH-Armored_KrivoiRog_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(127)=(Name="DH-Armored_La_Feuillie_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(128)=(Name="DH-Armored_La_Monderie_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(129)=(Name="DH-Armored_Lemberg_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(130)=(Name="DH-Armored_Maslova_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(131)=(Name="DH-Armored_Mickistein_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(132)=(Name="DH-Armored_Preaux_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(133)=(Name="DH-Armored_Raid_to_Bastogne_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(134)=(Name="DH-Armored_Iskra_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(135)=(Name="DH-Armored_Suedwind_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(136)=(Name="DH-Armored_Tank_Clash_At_Bastogne_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(137)=(Name="DH-Armored_Tractable_Advance",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(138)=(Name="DH-Armored_Voronezh_Clash",AlliedNation=NATION_USSR,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(139)=(Name="DH-Armored_Cagny_Recon_Clash",AlliedNation=NATION_Britain,GameType=GAMETYPE_Clash,Size=SIZE_Any)
    MapInfos(140)=(Name="DH-Jurques_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(141)=(Name="DH-Les_Champs_de_Losque_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(142)=(Name="DH-HedgeHog_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Small)
    MapInfos(143)=(Name="DH-Godolloi_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(144)=(Name="DH-Winter_Manor_1941_Push",AlliedNation=NATION_USSR,GameType=GAMETYPE_Push,Size=SIZE_Medium)
    MapInfos(145)=(Name="DH-Fury_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(146)=(Name="DH-La_Feuillie_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(147)=(Name="DH-Armored_Vieux_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(148)=(Name="DH-German_Village_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(149)=(Name="DH-Kasserine_Pass_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(150)=(Name="DH-Fury_Clash",AlliedNation=NATION_USA,GameType=GAMETYPE_Clash,Size=SIZE_Large)
    MapInfos(151)=(Name="DH-Cambes-En-Plaine_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(152)=(Name="DH-Fox_Green_Defence",AlliedNation=NATION_USA,GameType=GAMETYPE_Defence,Size=SIZE_Any)
    MapInfos(153)=(Name="DH-Lazur_Chemical_Plant_Defence",AlliedNation=NATION_USSR,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(154)=(Name="DH-Donner_Bolts",AlliedNation=NATION_Britain,GameType=GAMETYPE_Stalemate,Size=SIZE_ExtraSmall)
    MapInfos(155)=(Name="DH-Lutremange_Domination",AlliedNation=NATION_USA,GameType=GAMETYPE_Domination,Size=SIZE_Large)
    MapInfos(156)=(Name="DH-Dzerzhinsky_Tractor_Factory_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(157)=(Name="DH-Stavelot_Defence",AlliedNation=NATION_USA,GameType=GAMETYPE_Defence,Size=SIZE_Medium)
    MapInfos(158)=(Name="DH-Targnon_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(159)=(Name="DH-Kharkov_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(160)=(Name="DH-Endsieg_Advance",AlliedNation=NATION_USSR,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(161)=(Name="DH-Armored_La_Feuillie_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(162)=(Name="DH-Maupertus_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(163)=(Name="DH-Jurques_Dusk_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Large)
    MapInfos(164)=(Name="DH-Bremoy_Advance",AlliedNation=NATION_Britain,GameType=GAMETYPE_Advance,Size=SIZE_Medium)
    MapInfos(165)=(Name="DH-Armored_Wacht_am_Rhein_Advance",AlliedNation=NATION_USA,GameType=GAMETYPE_Advance,Size=SIZE_Any)
    MapInfos(166)=(Name="DH-Armored_La_Champagne_Advance",AlliedNation=NATION_Canada,GameType=GAMETYPE_Advance,Size=SIZE_Any)
}
