//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMapList extends MapList
    config;

var localized string OfficialText;
var localized string LegacyText;
var localized string CommunityText;

var protected string OfficialMaps[54]; // Make sure size matches correctly
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
    OfficialMaps(0)="DH-Barashka_Advance.rom"
    OfficialMaps(1)="DH-Bois_Jacques.rom"
    OfficialMaps(2)="DH-Brecourt.rom"
    OfficialMaps(3)="DH-Bridgehead.rom"
    OfficialMaps(4)="DH-Bridgehead_Advance.rom"
    OfficialMaps(5)="DH-Caen.rom"
    OfficialMaps(6)="DH-Cambes-En-Plaine_Advance.rom"
    OfficialMaps(7)="DH-Carentan.rom"
    OfficialMaps(8)="DH-Carentan_Causeway.rom"
    OfficialMaps(9)="DH-Carpiquet_Airfield_Advance.rom"
    OfficialMaps(10)="DH-Cheneux.rom"
    OfficialMaps(11)="DH-Dead_Man's_Corner.rom"
    OfficialMaps(12)="DH-Dog_Green.rom"
    OfficialMaps(13)="DH-Flakturm_Tiergarten.rom"
    OfficialMaps(14)="DH-Foucarville.rom"
    OfficialMaps(15)="DH-Foy.rom"
    OfficialMaps(16)="DH-Freyneux.rom"
    OfficialMaps(17)="DH-Ginkel_Heath.rom"
    OfficialMaps(18)="DH-Gorlitz.rom"
    OfficialMaps(19)="DH-Gran.rom"
    OfficialMaps(20)="DH-Hedgerow_Hell_Advance.rom"
    OfficialMaps(21)="DH-Hill_108.rom"
    OfficialMaps(22)="DH-Hill_400.rom"
    OfficialMaps(23)="DH-Hurtgenwald.rom"
    OfficialMaps(24)="DH-Juno_Beach.rom"
    OfficialMaps(25)="DH-Kommerscheidt.rom"
    OfficialMaps(26)="DH-Konigsplatz.rom"
    OfficialMaps(27)="DH-Kriegstadt.rom"
    OfficialMaps(28)="DH-Kryukovo.rom"
    OfficialMaps(29)="DH-La_Cambe.rom"
    OfficialMaps(30)="DH-La_Cambe_Advance.rom"
    OfficialMaps(31)="DH-La_Chapelle.rom"
    OfficialMaps(32)="DH-La_Gleize.rom"
    OfficialMaps(33)="DH-La_Monderie.rom"
    OfficialMaps(34)="DH-Lutremange_Advance.rom"
    OfficialMaps(35)="DH-Noville.rom"
    OfficialMaps(36)="DH-Pariserplatz.rom"
    OfficialMaps(37)="DH-Poteau_Ambush.rom"
    OfficialMaps(38)="DH-Putot-en-Bessin_Advance.rom"
    OfficialMaps(39)="DH-Raids.rom"
    OfficialMaps(40)="DH-Rakowice.rom"
    OfficialMaps(41)="DH-Reichswald.rom"
    OfficialMaps(42)="DH-Simonskall.rom"
    OfficialMaps(43)="DH-Stavelot.rom"
    OfficialMaps(44)="DH-St-Clement.rom"
    OfficialMaps(45)="DH-Stoumont.rom"
    OfficialMaps(46)="DH-Stoumont_Cutoff.rom"
    OfficialMaps(47)="DH-Targnon.rom"
    OfficialMaps(48)="DH-Varaville.rom"
    OfficialMaps(49)="DH-Vierville.rom"
    OfficialMaps(50)="DH-Vieux.rom"
    OfficialMaps(51)="DH-Vossenack_November7th.rom"
    OfficialMaps(52)="DH-Wacht_am_Rhein.rom"
    OfficialMaps(53)="DH-Watrange.rom"
    LegacyMaps(0)="DH-Vieux_Recon.rom"
    LegacyMaps(1)="DH-Target_Range.rom"
    OfficialText="Official"
    LegacyText="Legacy"
    CommunityText="Community"
}
