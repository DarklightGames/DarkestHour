//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSGunner extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanSSPawnB',Weight=1.5)
    //RolePawns(1)=(PawnClass=Class'DH_GermanSpringSmockSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.DotGreenSleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    PrimaryWeapons(2)=(Item=Class'DH_ZB30Weapon')
    SecondaryWeapons(2)=(Item=Class'DH_C96Weapon')
}
