//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapList extends MapList
    config;

var protected string OfficialMaps[33]; // Make sure size matches correctly

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

defaultproperties
{
    OfficialMaps(0)="DH-Bois_Jacques"
    OfficialMaps(1)="DH-Brecourt"
    OfficialMaps(2)="DH-Bridgehead"
    OfficialMaps(3)="DH-Caen"
    OfficialMaps(4)="DH-Cambes_en_Plaine"
    OfficialMaps(5)="DH-Carentan"
    OfficialMaps(6)="DH-Carentan_Causeway"
    OfficialMaps(7)="DH-Cheneux"
    OfficialMaps(8)="DH-Dog_Green"
    OfficialMaps(9)="DH-Freyneux_and_Lamormenil"
    OfficialMaps(10)="DH-Foy"
    OfficialMaps(11)="DH-Ginkel_Heath"
    OfficialMaps(12)="DH-Gran"
    OfficialMaps(13)="DH-Hill_108"
    OfficialMaps(14)="DH-Hill_400"
    OfficialMaps(15)="DH-Hurtgenwald"
    OfficialMaps(16)="DH-Juno_Beach"
    OfficialMaps(17)="DH-Kommerscheidt"
    OfficialMaps(18)="DH-La_Chapelle"
    OfficialMaps(19)="DH-La_Gleize"
    OfficialMaps(20)="DH-La_Monderie"
    OfficialMaps(21)="DH-Lutremange"
    OfficialMaps(22)="DH-Noville"
    OfficialMaps(23)="DH-Poteau_Ambush"
    OfficialMaps(24)="DH-Raids"
    OfficialMaps(25)="DH-Simonskall"
    OfficialMaps(26)="DH-Stavelot"
    OfficialMaps(27)="DH-Stoumont"
    OfficialMaps(28)="DH-Targnon"
    OfficialMaps(29)="DH-Vieux"
    OfficialMaps(30)="DH-Vieux_Recon"
    OfficialMaps(31)="DH-Wacht_am_Rhein"
}
