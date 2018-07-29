//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string CommunityText;

var protected string OfficialMaps[58]; // Make sure size matches correctly

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

static function string GetPrettyName(string MapName)
{
    MapName = Repl(MapName, "DH-", "");
    MapName = Repl(MapName, ".rom", "");
    MapName = Repl(MapName, "_", " ");
    return MapName;
}

defaultproperties
{
    // Make sure the variable array size matches correctly
    OfficialMaps(0)="DH-Barashka_Advance.rom"
    OfficialMaps(1)="DH-Bois_Jacques_Push.rom"
    OfficialMaps(2)="DH-Brecourt_Push.rom"
    OfficialMaps(3)="DH-Bridgehead_Advance.rom"
    OfficialMaps(4)="DH-Bridgehead_Push.rom"
    OfficialMaps(5)="DH-Butovo_Advance.rom"
    OfficialMaps(6)="DH-Caen_Advance.rom"
    OfficialMaps(7)="DH-Cambes-En-Plaine_Advance.rom"
    OfficialMaps(8)="DH-Carentan_Push.rom"
    OfficialMaps(9)="DH-Carentan_Causeway_Push.rom"
    OfficialMaps(10)="DH-Carpiquet_Airfield_Advance.rom"
    OfficialMaps(11)="DH-Cheneux_Push.rom"
    OfficialMaps(12)="DH-Dead_Man's_Corner_Push.rom"
    OfficialMaps(13)="DH-Dog_Green_Push.rom"
    OfficialMaps(14)="DH-Flakturm_Tiergarten_Push.rom"
    OfficialMaps(15)="DH-Foucarville_Push.rom"
    OfficialMaps(16)="DH-Foy_Push.rom"
    OfficialMaps(17)="DH-Freyneux_Push.rom"
    OfficialMaps(18)="DH-Ginkel_Heath_Push.rom"
    OfficialMaps(19)="DH-Gorlitz_Push.rom"
    OfficialMaps(20)="DH-Gran_Push.rom"
    OfficialMaps(21)="DH-Hattert_Advance.rom"
    OfficialMaps(22)="DH-Hedgerow_Hell_Advance.rom"
    OfficialMaps(23)="DH-Hill_108_Push.rom"
    OfficialMaps(24)="DH-Hill_400_Push.rom"
    OfficialMaps(25)="DH-Hurtgenwald_Push.rom"
    OfficialMaps(26)="DH-Juno_Beach_Push.rom"
    OfficialMaps(27)="DH-Kommerscheidt_Attrition.rom"
    OfficialMaps(28)="DH-Konigsplatz_Push.rom"
    OfficialMaps(29)="DH-Kriegstadt_Push.rom"
    OfficialMaps(30)="DH-La_Cambe_Push.rom"
    OfficialMaps(31)="DH-La_Cambe_Advance.rom"
    OfficialMaps(32)="DH-La_Chapelle_Push.rom"
    OfficialMaps(33)="DH-La_Gleize_Push.rom"
    OfficialMaps(34)="DH-La_Monderie_Attrition.rom"
    OfficialMaps(35)="DH-Lutremange_Advance.rom"
    OfficialMaps(36)="DH-Lutremange_Push.rom"
    OfficialMaps(37)="DH-Makhnovo_Advance.rom"
    OfficialMaps(38)="DH-Noville_Push.rom"
    OfficialMaps(39)="DH-Nuenen_Advance.rom"
    OfficialMaps(40)="DH-Oosterbeek_Advance.rom"
    OfficialMaps(41)="DH-Pariserplatz_Push.rom"
    OfficialMaps(42)="DH-Poteau_Ambush_Push.rom"
    OfficialMaps(43)="DH-Putot-en-Bessin_Advance.rom"
    OfficialMaps(44)="DH-Raids_Push.rom"
    OfficialMaps(45)="DH-Rakowice_Push.rom"
    OfficialMaps(46)="DH-Reichswald_Push.rom"
    OfficialMaps(47)="DH-Rhine_River_Advance.rom"
    OfficialMaps(48)="DH-Simonskall_Push.rom"
    OfficialMaps(49)="DH-Stavelot_Push.rom"
    OfficialMaps(50)="DH-St-Clement_Push.rom"
    OfficialMaps(51)="DH-Stoumont_Push.rom"
    OfficialMaps(52)="DH-Stoumont_Advance.rom"
    OfficialMaps(53)="DH-Targnon_Push.rom"
    OfficialMaps(54)="DH-Varaville_Advance.rom"
    OfficialMaps(55)="DH-Vierville_Push.rom"
    OfficialMaps(56)="DH-Vieux_Attrition.rom"
    OfficialMaps(57)="DH-Vossenack_Push.rom"

    OfficialText="Official"
    CommunityText="Community"
}
