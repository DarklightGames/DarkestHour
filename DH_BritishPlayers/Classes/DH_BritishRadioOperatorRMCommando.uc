//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishRadioOperatorRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
    MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_RadOp'
    Models(0)="RMCRad1"
    Models(1)="RMCRad2"
    Models(2)="RMCRad3"
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
    GivenItems(0)="DH_Equipment.DH_USRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
