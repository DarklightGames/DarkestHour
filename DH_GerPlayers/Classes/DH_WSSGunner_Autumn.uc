//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSGunner_Autumn extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=Class'DH_GermanAutumnSmockSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetCover'

    PrimaryWeapons(2)=(Item=Class'DH_ZB30Weapon')
    SecondaryWeapons(2)=(Item=Class'DH_C96Weapon')
}
