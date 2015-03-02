//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishTanker7th extends DH_British_7thArmouredDivision;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Tank Crewman"
    Article="a "
    PluralName="Tank Crewmen"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_TankCrew'
    Models(0)="Brit_Tanker1"
    Models(1)="Brit_Tanker2"
    Models(2)="Brit_Tanker3"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTankerBeret'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=3
}
