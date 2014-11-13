//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJRadioman extends DH_FJ;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
    }
}

defaultproperties
{
     MyName="Radio Operator"
     AltName="Funktruppe"
     Article="a "
     PluralName="Radio Operator"
     InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
     MenuImage=Texture'DHGermanCharactersTex.Icons.FJ_Radioman'
     Models(0)="FJ_Radio_1"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18)
     GivenItems(0)="DH_Equipment.DH_GerRadioItem"
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmetCamo1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmetCamo2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     Limit=1
}
