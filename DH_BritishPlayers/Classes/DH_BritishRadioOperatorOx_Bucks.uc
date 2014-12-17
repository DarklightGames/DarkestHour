//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishRadioOperatorOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
    MenuImage=texture'DHBritishCharactersTex.Icons.Para_RadOp'
    Models(0)="paraRad1"
    Models(1)="paraRad2"
    Models(2)="paraRad3"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_BritishRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
