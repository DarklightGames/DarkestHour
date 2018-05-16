//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string LegacyText;
var localized string CommunityText;

var protected string OfficialMaps[62]; // Make sure size matches correctly
var protected string LegacyMaps[2];

static function string GetMapSource(string S)
{
    if (IsMapOfficial(S))
    {
        return default.OfficialText;
    }
    else if (IsMapLegacy(S))
    {
        return default.LegacyText;
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
        if (S ~= default.OfficialMaps[i])
        {
            return true;
        }
    }

    return false;
}

static function bool IsMapLegacy(string S)
{
    local int i;

    for (i = 0; i < arraycount(default.LegacyMaps); ++i)
    {
        if (S ~= default.LegacyMaps[i])
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
    OfficialMaps(0)="DH-Baranovka_Armoured.rom"
    OfficialMaps(1)="DH-Barashka_Advance.rom"
    OfficialMaps(2)="DH-Black_Day_July_Advance.rom"
    OfficialMaps(3)="DH-Bois_Jacques.rom"
    OfficialMaps(4)="DH-Brecourt.rom"
    OfficialMaps(5)="DH-Bridgehead.rom"
    OfficialMaps(6)="DH-Bridgehead_Advance.rom"
    OfficialMaps(7)="DH-Butovo_Advance.rom"
    OfficialMaps(8)="DH-Caen_Advance.rom"
    OfficialMaps(9)="DH-Cambes-En-Plaine_Advance.rom"
    OfficialMaps(10)="DH-Carentan.rom"
    OfficialMaps(11)="DH-Carentan_Causeway.rom"
    OfficialMaps(12)="DH-Carpiquet_Airfield_Advance.rom"
    OfficialMaps(13)="DH-Cheneux.rom"
    OfficialMaps(14)="DH-Dead_Man's_Corner.rom"
    OfficialMaps(15)="DH-Dog_Green.rom"
    OfficialMaps(16)="DH-Flakturm_Tiergarten.rom"
    OfficialMaps(17)="DH-Foucarville.rom"
    OfficialMaps(18)="DH-Foy.rom"
    OfficialMaps(19)="DH-Freyneux.rom"
    OfficialMaps(20)="DH-Ginkel_Heath.rom"
    OfficialMaps(21)="DH-Gorlitz.rom"
    OfficialMaps(22)="DH-Gran.rom"
    OfficialMaps(23)="DH-Hattert_Advance.rom"
    OfficialMaps(24)="DH-Hedgerow_Hell_Advance.rom"
    OfficialMaps(25)="DH-Hill_108.rom"
    OfficialMaps(26)="DH-Hill_400.rom"
    OfficialMaps(27)="DH-Hurtgenwald.rom"
    OfficialMaps(28)="DH-Juno_Beach.rom"
    OfficialMaps(29)="DH-Kommerscheidt.rom"
    OfficialMaps(30)="DH-Konigsplatz.rom"
    OfficialMaps(31)="DH-Kriegstadt.rom"
    OfficialMaps(32)="DH-La_Cambe.rom"
    OfficialMaps(33)="DH-La_Cambe_Advance.rom"
    OfficialMaps(34)="DH-La_Chapelle.rom"
    OfficialMaps(35)="DH-La_Gleize.rom"
    OfficialMaps(36)="DH-La_Gleize_Advance.rom"
    OfficialMaps(37)="DH-La_Monderie.rom"
    OfficialMaps(38)="DH-Lutremange_Advance.rom"
    OfficialMaps(39)="DH-Lutremange_Armoured.rom"
    OfficialMaps(40)="DH-Makhnovo_Advance.rom"
    OfficialMaps(41)="DH-Noville.rom"
    OfficialMaps(42)="DH-Nuenen_Advance.rom"
    OfficialMaps(43)="DH-Oosterbeek_Advance.rom"
    OfficialMaps(44)="DH-Pariserplatz.rom"
    OfficialMaps(45)="DH-Poteau_Ambush.rom"
    OfficialMaps(46)="DH-Putot-en-Bessin_Advance.rom"
    OfficialMaps(47)="DH-Raids.rom"
    OfficialMaps(48)="DH-Rakowice.rom"
    OfficialMaps(49)="DH-Reichswald.rom"
    OfficialMaps(50)="DH-Rhine_River_Advance.rom"
    OfficialMaps(51)="DH-Simonskall.rom"
    OfficialMaps(52)="DH-Stavelot.rom"
    OfficialMaps(53)="DH-St-Clement.rom"
    OfficialMaps(54)="DH-Stoumont.rom"
    OfficialMaps(55)="DH-Stoumont_Advance.rom"
    OfficialMaps(56)="DH-Targnon.rom"
    OfficialMaps(57)="DH-Varaville_Advance.rom"
    OfficialMaps(58)="DH-Vierville.rom"
    OfficialMaps(59)="DH-Vieux.rom"
    OfficialMaps(60)="DH-Vossenack_November7th.rom"
    OfficialMaps(61)="DH-Watrange.rom"
    LegacyMaps(0)="DH-Vieux_Recon.rom"
    LegacyMaps(1)="DH-Target_Range.rom"
    OfficialText="Official"
    LegacyText="Legacy"
    CommunityText="Community"
}
