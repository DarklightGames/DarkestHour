//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LWP_StandardGunnerGrey extends DHPOLMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLGreyPawn',Weight=4.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicGreyPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicMixGreyPawn',Weight=1.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicMixBGreyPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'
    
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP27LateWeapon')
}
