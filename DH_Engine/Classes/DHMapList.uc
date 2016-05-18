//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string LegacyText;
var localized string CommunityText;

var protected string OfficialMaps[31]; // Make sure size matches correctly
var protected string LegacyMaps[6];

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
    OfficialMaps(0)="DH-Bois_Jacques.rom"
    OfficialMaps(1)="DH-Brecourt.rom"
    OfficialMaps(2)="DH-Bridgehead.rom"
    OfficialMaps(3)="DH-Caen.rom"
    OfficialMaps(4)="DH-Carentan_Causeway.rom"
    OfficialMaps(5)="DH-Cheneux.rom"
    OfficialMaps(6)="DH-Dead_Man's_Corner.rom"
    OfficialMaps(7)="DH-Dog_Green.rom"
    OfficialMaps(8)="DH-Freyneux_and_Lamormenil.rom"
    OfficialMaps(9)="DH-Foucarville.rom"
    OfficialMaps(10)="DH-Foy.rom"
    OfficialMaps(11)="DH-Hill_108.rom"
    OfficialMaps(12)="DH-Hill_400.rom"
    OfficialMaps(13)="DH-Hurtgenwald.rom"
    OfficialMaps(14)="DH-Juno_Beach.rom"
    OfficialMaps(15)="DH-Kommerscheidt.rom"
    OfficialMaps(16)="DH-La_Cambe.rom"
    OfficialMaps(17)="DH-La_Chapelle.rom"
    OfficialMaps(18)="DH-La_Gleize.rom"
    OfficialMaps(19)="DH-La_Monderie.rom"
    OfficialMaps(20)="DH-Lutremange.rom"
    OfficialMaps(21)="DH-Noville.rom"
    OfficialMaps(22)="DH-Poteau_Ambush.rom"
    OfficialMaps(23)="DH-Raids.rom"
    OfficialMaps(24)="DH-Simonskall.rom"
    OfficialMaps(25)="DH-St-Clement.rom"
    OfficialMaps(26)="DH-Stavelot.rom"
    OfficialMaps(27)="DH-Stoumont.rom"
    OfficialMaps(28)="DH-Targnon.rom"
    OfficialMaps(29)="DH-Vierville.rom"
    OfficialMaps(30)="DH-Vieux.rom"
    LegacyMaps(0)="DH-Vieux_Recon.rom"
    LegacyMaps(1)="DH-Ginkel_Heath.rom"
    LegacyMaps(2)="DH-Wacht_am_Rhein.rom"
    LegacyMaps(3)="DH-Gran.rom"
    LegacyMaps(4)="DH-Cambes_en_Plaine.rom"
    LegacyMaps(5)="DH-Carentan"

    OfficialText="Official"
    LegacyText="Legacy"
    CommunityText="Community"
}
