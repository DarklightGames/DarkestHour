//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_12thSSGunner extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_German12thSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    SecondaryWeapons(2)=(Item=Class'DH_C96Weapon')
}
