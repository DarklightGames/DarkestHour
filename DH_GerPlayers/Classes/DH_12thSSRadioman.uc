//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_12thSSRadioman extends DH_12thSS;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Radio Operator"
     AltName="Funktruppe"
     Article="a "
     PluralName="Radio Operator"
     InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Radioman'
     Models(0)="12SS_Radio_1"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     GivenItems(0)="DH_Equipment.DH_GerRadioItem"
     Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
     Limit=1
}
