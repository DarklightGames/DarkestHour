//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_FJSniper extends DHGESniperRoles;

defaultproperties
{
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_FG42ScopedWeapon')
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanFJPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamoOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamoTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33
}
