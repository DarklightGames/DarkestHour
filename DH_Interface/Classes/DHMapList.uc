//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMapList extends MapList
        config;


function ClearMapsArray()
{
    Maps.Remove(0,Maps.Length);
}

function AddNewStringElement(string new_element_to_load, int index)
{
    Maps[index] = new_element_to_load;
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
    Maps(13)="DH-Hill_108"
    Maps(14)="DH-Hill_400"
    Maps(15)="DH-Hurtgenwald"
    Maps(16)="DH-Juno_Beach"
    Maps(17)="DH-Kommerscheidt"
    Maps(18)="DH-La_Chapelle"
    Maps(19)="DH-La_Monderie"
    Maps(20)="DH-Lutremange"
    Maps(21)="DH-Poteau_Ambush"
    Maps(22)="DH-Raids"
    Maps(23)="DH-Simonskall"
    Maps(24)="DH-Stoumont"
    Maps(25)="DH-Vieux"
    Maps(26)="DH-Vieux_Recon"
    Maps(27)="DH-Wacht_am_Rhein"
    Maps(29)="DH-Noville"
}
