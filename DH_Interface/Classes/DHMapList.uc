//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapList extends MapList
    config;

var protected string OfficialMaps[27]; // Make sure size matches correctly
var protected string LegacyMaps[5];

static function bool IsMapOfficial(string S)
{
    local int i;

    for (i = 0; i < arraycount(default.OfficialMaps); i++)
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

    for (i = 0; i < arraycount(default.LegacyMaps); i++)
    {
        if (S ~= default.LegacyMaps[i])
        {
            return true;
        }
    }

    return false;
}

defaultproperties
{
    OfficialMaps(0)="DH-Bois_Jacques"
    OfficialMaps(1)="DH-Brecourt"
    OfficialMaps(2)="DH-Bridgehead"
    OfficialMaps(3)="DH-Caen"
    OfficialMaps(4)="DH-Carentan"
    OfficialMaps(5)="DH-Carentan_Causeway"
    OfficialMaps(6)="DH-Cheneux"
    OfficialMaps(7)="DH-Dog_Green"
    OfficialMaps(8)="DH-Freyneux_and_Lamormenil"
    OfficialMaps(9)="DH-Foy"
    OfficialMaps(10)="DH-Hill_108"
    OfficialMaps(11)="DH-Hill_400"
    OfficialMaps(12)="DH-Hurtgenwald"
    OfficialMaps(13)="DH-Juno_Beach"
    OfficialMaps(14)="DH-Kommerscheidt"
    OfficialMaps(15)="DH-La_Chapelle"
    OfficialMaps(16)="DH-La_Gleize"
    OfficialMaps(17)="DH-La_Monderie"
    OfficialMaps(18)="DH-Lutremange"
    OfficialMaps(19)="DH-Noville"
    OfficialMaps(20)="DH-Poteau_Ambush"
    OfficialMaps(21)="DH-Raids"
    OfficialMaps(22)="DH-Simonskall"
    OfficialMaps(23)="DH-Stavelot"
    OfficialMaps(24)="DH-Stoumont"
    OfficialMaps(25)="DH-Targnon"
    OfficialMaps(26)="DH-Vieux"
    LegacyMaps(0)="DH-Vieux_Recon"
    LegacyMaps(1)="DH-Ginkel_Heath"
    LegacyMaps(2)="DH-Wacht_am_Rhein"
    LegacyMaps(3)="DH-Gran"
    LegacyMaps(4)="DH-Cambes_en_Plaine"
}
