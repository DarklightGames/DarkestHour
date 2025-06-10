//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSGunner_Snow extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowSSPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve' //to do
    Headgear(0)=Class'DH_SSHelmetSnow'
    HeadgearProbabilities(0)=1.0
    
    PrimaryWeapons(2)=(Item=Class'DH_ZB30Weapon')
    SecondaryWeapons(2)=(Item=Class'DH_C96Weapon')
    HandType=Hand_Gloved
}
