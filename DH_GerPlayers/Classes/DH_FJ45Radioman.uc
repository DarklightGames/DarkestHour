//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_FJ45Radioman extends DHGERadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanRadioFJPawn')
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamoOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamoTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33

    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M712Weapon')
}
