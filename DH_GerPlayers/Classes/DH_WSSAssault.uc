//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSAssault extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanSSPawnC',Weight=1.5)
    RolePawns(1)=(PawnClass=Class'DH_GermanSpringSmockSSPawnC',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.DotGreenSleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_STG44Weapon',AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
