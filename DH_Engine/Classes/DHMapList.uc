//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string CommunityText;
var localized string WorkInProgressText;

var protected string OfficialMaps[60];                  // Make sure size matches correctly
var protected string WorkInProgressMaps[28];            // this one also

static function string GetMapSource(string S)
{
    if (IsMapOfficial(S))
    {
        return default.OfficialText;
    }
    else
    {
        return default.CommunityText;
    }
}

static function bool IsMapOfficial(string S)
{
    local int i;

    for (i = 0; i < arraycount(default.OfficialMaps); ++i)
    {
        if (GetPrettyName(S) ~= GetPrettyName(default.OfficialMaps[i]))
        {
            return true;
        }
    }

    return false;
}

static function bool IsMapWorkInProgress(string S)
{
    local int i;

    for (i = 0; i < arraycount(default.WorkInProgressMaps); ++i)
    {
        if (GetPrettyName(S) ~= GetPrettyName(default.WorkInProgressMaps[i]))
        {
            return true;
        }
    }

    return false;
}

static function string GetPrettyName(string MapName)
{
    MapName = Repl(MapName, "DH-", "");
    MapName = Repl(MapName, ".rom", "");
    MapName = Repl(MapName, "_", " ");
    return MapName;
}

defaultproperties
{
    OfficialText="Official"
    CommunityText="Community"
    WorkInProgressText="Work In Progress"

    // Make sure the variable array size matches correctly
    OfficialMaps(0)="DH-Barashka_Clash.rom"
    OfficialMaps(1)="DH-Bois_Jacques_Push"
    OfficialMaps(2)="DH-Brecourt_Push.rom"
    OfficialMaps(3)="DH-Bridgehead_Advance.rom"
    OfficialMaps(4)="DH-Caen_Advance.rom"
    OfficialMaps(5)="DH-Cambes-En-Plaine_Clash.rom"
    OfficialMaps(6)="DH-Carentan_Causeway_Push.rom"
    OfficialMaps(7)="DH-Carentan_Push.rom"
    OfficialMaps(8)="DH-Carpiquet_Airfield_Advance.rom"
    OfficialMaps(9)="DH-Cheneux_Push.rom"
    OfficialMaps(10)="DH-Dead_Man's_Corner_Push.rom"
    OfficialMaps(11)="DH-Dog_Green_Push.rom"
    OfficialMaps(12)="DH-Donner_Stalemate.rom"
    OfficialMaps(13)="DH-Falaise_Push.rom"
    OfficialMaps(14)="DH-Flakturm_Tiergarten_Push.rom"
    OfficialMaps(15)="DH-Foucarville_Push.rom"
    OfficialMaps(16)="DH-Foy_Push.rom"
    OfficialMaps(17)="DH-Ginkel_Heath_Push.rom"
    OfficialMaps(18)="DH-Gorlitz_Push.rom"
    OfficialMaps(19)="DH-Hattert_Clash.rom"
    OfficialMaps(20)="DH-Hedgerow_Hell_Clash.rom"
    OfficialMaps(21)="DH-Hill_108_Push.rom"
    OfficialMaps(22)="DH-Hill_400_Push.rom"
    OfficialMaps(23)="DH-Hurtgenwald_Push.rom"
    OfficialMaps(24)="DH-Juno_Beach_Push.rom"
    OfficialMaps(25)="DH-Konigsplatz_Push.rom"
    OfficialMaps(26)="DH-Kriegstadt_Push.rom"
    OfficialMaps(27)="DH-La_Cambe_Advance.rom"
    OfficialMaps(28)="DH-La_Chapelle_Push.rom"
    OfficialMaps(29)="DH-La_Gleize_Advance.rom"
    OfficialMaps(30)="DH-La_Gleize_Push.rom"
    OfficialMaps(31)="DH-Lutremange_Clash.rom"
    OfficialMaps(32)="DH-Lutremange_Push.rom"
    OfficialMaps(33)="DH-Noville_Advance.rom"
    OfficialMaps(34)="DH-Noville_Push.rom"
    OfficialMaps(35)="DH-Nuenen_Clash.rom"
    OfficialMaps(36)="DH-Oosterbeek_Advance.rom"
    OfficialMaps(37)="DH-Pariserplatz_Push.rom"
    OfficialMaps(38)="DH-Poteau_Ambush_Push.rom"
    OfficialMaps(39)="DH-Putot-en-Bessin_Advance.rom"
    OfficialMaps(40)="DH-Radar_Advance.rom"
    OfficialMaps(41)="DH-Raids_Push.rom"
    OfficialMaps(42)="DH-Rakowice_Push.rom"
    OfficialMaps(43)="DH-Reichswald_Push.rom"
    OfficialMaps(44)="DH-Simonskall_Push.rom"
    OfficialMaps(45)="DH-St-Clement_Push.rom"
    OfficialMaps(46)="DH-Stavelot_Push.rom"
    OfficialMaps(47)="DH-Stoumont_Advance.rom"
    OfficialMaps(48)="DH-Stoumont_Push.rom"
    OfficialMaps(49)="DH-Targnon_Push.rom"
    OfficialMaps(50)="DH-Varaville_Advance.rom"
    OfficialMaps(51)="DH-Vierville_Push.rom"
    OfficialMaps(52)="DH-Vossenack_Push.rom"
    OfficialMaps(53)="DH-Salaca_River_Clash.rom"
    OfficialMaps(54)="DH-Ogledow_Clash.rom"
    OfficialMaps(55)="DH-Rabenheck_Advance.rom"
    OfficialMaps(56)="DH-San_Valentino_Advance.rom"
    OfficialMaps(57)="DH-Ten_Aard_Clash.rom"
    OfficialMaps(58)="DH-Valko_Advance.rom"
    OfficialMaps(59)="DH-Danzig_Push.rom"

    WorkInProgressMaps(0)="DH-WIP_Arad_Advance.rom"
    WorkInProgressMaps(1)="DH-WIP_Arnhem_Bridge_Push.rom"
    WorkInProgressMaps(2)="DH-WIP_Berezina_Advance.rom"
    WorkInProgressMaps(3)="DH-WIP_Black_Day_July_Advance.rom"
    WorkInProgressMaps(4)="DH-WIP_Butovo_Advance.rom"
    WorkInProgressMaps(5)="DH-WIP_Chambois_Push.rom"
    WorkInProgressMaps(6)="DH-WIP_Champs_Advance.rom"
    WorkInProgressMaps(7)="DH-WIP_Cholm_Advance.rom"
    WorkInProgressMaps(8)="DH-WIP_Dom-Pavlova_Advance.rom"
    WorkInProgressMaps(9)="DH-WIP_Kasserine_Pass_Advance.rom"
    WorkInProgressMaps(10)="DH-WIP_Klin1941_Advance.rom"
    WorkInProgressMaps(11)="DH-WIP_Kriegstadt_Advance.rom"
    WorkInProgressMaps(12)="DH-WIP_Leningrad_Push.rom"
    WorkInProgressMaps(13)="DH-WIP_Leszinow_Advance.rom"
    WorkInProgressMaps(14)="DH-WIP_Makhnovo_Advance.rom"
    WorkInProgressMaps(15)="DH-WIP_Maupertus_Push.rom"
    WorkInProgressMaps(16)="DH-WIP_MyshkovaRiver_Advance.rom"
    WorkInProgressMaps(17)="DH-WIP_Odessa_Push.rom"
    WorkInProgressMaps(18)="DH-WIP_Pegasus_Bridge_Advance.rom"
    WorkInProgressMaps(19)="DH-WIP_Pointe_Du_Hoc_Push.rom"
    WorkInProgressMaps(20)="DH-WIP_Poteau_Ambush_Advance.rom"
    WorkInProgressMaps(21)="DH-WIP_Prussia_Push.rom"
    WorkInProgressMaps(22)="DH-WIP_Ramelle_Push.rom"
    WorkInProgressMaps(23)="DH-WIP_Rhine_River_Clash.rom"
    WorkInProgressMaps(24)="DH-WIP_Schijndel_Advance.rom"
    WorkInProgressMaps(25)="DH-WIP_Smolensk_Advance.rom"
    WorkInProgressMaps(26)="DH-WIP_Turqueville_Push.rom"
    WorkInProgressMaps(27)="DH-WIP_Winter_Stalemate_Clash.rom"
}
