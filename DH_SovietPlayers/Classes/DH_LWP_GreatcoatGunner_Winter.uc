//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatGunner_Winter extends DHPOLMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPGreatcoatBrownBagPawn_Winter',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPGreatcoatGreyBagPawn_Winter',Weight=2.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_LWPCoatSleeves'
    Headgear(0)=Class'DH_LWPHelmet'
    HandType=Hand_Gloved
    
    PrimaryWeapons(0)=(Item=Class'DH_DP27LateWeapon')
}
