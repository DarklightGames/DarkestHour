//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string LegacyText;
var localized string CommunityText;

var protected string OfficialMaps[37]; // Make sure size matches correctly
var protected string LegacyMaps[9];

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
    OfficialMaps(0)="DH-Bois_Jacques.rom"
    OfficialMaps(1)="DH-Brecourt.rom"
    OfficialMaps(2)="DH-Bridgehead.rom"
    OfficialMaps(3)="DH-Caen.rom"
    OfficialMaps(4)="DH-Carentan_Causeway.rom"
    OfficialMaps(5)="DH-Cheneux.rom"
    OfficialMaps(6)="DH-Dead_Man's_Corner.rom"
    OfficialMaps(7)="DH-Dog_Green.rom"
    OfficialMaps(8)="DH-Flakturm_Tiergarten.rom"
    OfficialMaps(9)="DH-Foucarville.rom"
    OfficialMaps(10)="DH-Foy.rom"
    OfficialMaps(11)="DH-Hedgerow_Hell.rom"
    OfficialMaps(12)="DH-Hill_108.rom"
    OfficialMaps(13)="DH-Hill_400.rom"
    OfficialMaps(14)="DH-Hurtgenwald.rom"
    OfficialMaps(15)="DH-Juno_Beach.rom"
    OfficialMaps(16)="DH-Kommerscheidt.rom"
    OfficialMaps(17)="DH-Konigsplatz.rom"
    OfficialMaps(18)="DH-Kriegstadt.rom"
    OfficialMaps(19)="DH-La_Cambe.rom"
    OfficialMaps(20)="DH-La_Chapelle.rom"
    OfficialMaps(21)="DH-La_Gleize.rom"
    OfficialMaps(22)="DH-Lutremange.rom"
    OfficialMaps(23)="DH-Noville.rom"
    OfficialMaps(24)="DH-Pariserplatz.rom"
    OfficialMaps(25)="DH-Poteau_Ambush.rom"
    OfficialMaps(26)="DH-Raids.rom"
    OfficialMaps(27)="DH-Rakowice.rom"
    OfficialMaps(28)="DH-Reichswald.rom"
    OfficialMaps(29)="DH-Simonskall.rom"
    OfficialMaps(30)="DH-St-Clement.rom"
    OfficialMaps(31)="DH-Stavelot.rom"
    OfficialMaps(32)="DH-Stoumont.rom"
    OfficialMaps(33)="DH-Targnon.rom"
    OfficialMaps(34)="DH-Vierville.rom"
    OfficialMaps(35)="DH-Vossenack_November7th"
    OfficialMaps(36)="DH-Watrange.rom"
    LegacyMaps(0)="DH-Vieux_Recon.rom"
    LegacyMaps(1)="DH-Ginkel_Heath.rom"
    LegacyMaps(2)="DH-Wacht_am_Rhein.rom"
    LegacyMaps(3)="DH-Gran.rom"
    LegacyMaps(4)="DH-Cambes_en_Plaine.rom"
    LegacyMaps(5)="DH-Carentan.rom"
    LegacyMaps(6)="DH-Freyneux_and_Lamormenil.rom"
    LegacyMaps(7)="DH-La_Monderie.rom"
    LegacyMaps(8)="DH-Vieux.rom"
    OfficialText="Official"
    LegacyText="Legacy"
    CommunityText="Community"
}
