//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardGunnerGrey extends DHPOLMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicSLGreyPawn',Weight=4.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicGreyPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicMixGreyPawn',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_LWPTunicMixBGreyPawn',Weight=1.0)
    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'
    
    PrimaryWeapons(0)=(Item=Class'DH_DP27LateWeapon')
}
