//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapList extends MapList
    config;

static function bool IsMapOfficial(string S)
{
    local int i;

    for (i = 0; i < default.Maps.Length; ++i)
    {
        if (S ~= default.Maps[i])
        {
            return true;
        }
    }

    return false;
}

defaultproperties
{
    Maps(0)="DH-Bois_Jacques"
    Maps(1)="DH-Brecourt"
    Maps(2)="DH-Bridgehead"
    Maps(3)="DH-Caen"
    Maps(4)="DH-Cambes_en_Plaine"
    Maps(5)="DH-Carentan"
    Maps(6)="DH-Carentan_Causeway"
    Maps(7)="DH-Cheneux"
    Maps(8)="DH-Dog_Green"
    Maps(9)="DH-Freyneux_and_Lamormenil"
    Maps(10)="DH-Foy"
    Maps(11)="DH-Ginkel_Heath"
    Maps(12)="DH-Gran"
    Maps(13)="DH-Hells_Highway"
    Maps(14)="DH-Hill_108"
    Maps(15)="DH-Hill_400"
    Maps(16)="DH-Hurtgenwald"
    Maps(17)="DH-Juno_Beach"
    Maps(18)="DH-Kommerscheidt"
    Maps(19)="DH-La_Chapelle"
    Maps(20)="DH-La_Gleize"
    Maps(21)="DH-La_Monderie"
    Maps(22)="DH-Lutremange"
    Maps(23)="DH-Noville"
    Maps(24)="DH-Poteau_Ambush"
    Maps(25)="DH-Raids"
    Maps(26)="DH-Simonskall"
    Maps(27)="DH-Stavelot"
    Maps(28)="DH-Stoumont"
    Maps(29)="DH-Targnon"
    Maps(30)="DH-Vieux"
    Maps(31)="DH-Vieux_Recon"
    Maps(32)="DH-Wacht_am_Rhein"
}
