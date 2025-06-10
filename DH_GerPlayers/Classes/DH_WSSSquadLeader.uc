//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    AltName="Scharführer"

    RolePawns(0)=(PawnClass=Class'DH_GermanSSPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSpringSmockSSPawn',Weight=1.5)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.DotGreenSleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')

    SecondaryWeapons(0)=(Item=Class'DH_BHPWeapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_C96Weapon')
}
