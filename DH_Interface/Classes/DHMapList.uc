//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Note: You cannot access dynamic arrays from static functions

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
    OfficialMaps(13)="DH-Hells_Highway"
    OfficialMaps(14)="DH-Hill_108"
    OfficialMaps(15)="DH-Hill_400"
    OfficialMaps(16)="DH-Hurtgenwald"
    OfficialMaps(17)="DH-Juno_Beach"
    OfficialMaps(18)="DH-Kommerscheidt"
    OfficialMaps(19)="DH-La_Chapelle"
    OfficialMaps(20)="DH-La_Gleize"
    OfficialMaps(21)="DH-La_Monderie"
    OfficialMaps(22)="DH-Lutremange"
    OfficialMaps(23)="DH-Noville"
    OfficialMaps(24)="DH-Poteau_Ambush"
    OfficialMaps(25)="DH-Raids"
    OfficialMaps(26)="DH-Simonskall"
    OfficialMaps(27)="DH-Stavelot"
    OfficialMaps(28)="DH-Stoumont"
    OfficialMaps(29)="DH-Targnon"
    OfficialMaps(30)="DH-Vieux"
    OfficialMaps(31)="DH-Vieux_Recon"
    OfficialMaps(32)="DH-Wacht_am_Rhein"
}
