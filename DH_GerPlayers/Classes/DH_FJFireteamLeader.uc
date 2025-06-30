//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_FJFireteamLeader extends DHGECorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanFJPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.FJ_Sleeve'
    Headgear(0)=Class'DH_FJHelmetOne'
    Headgear(1)=Class'DH_FJHelmetTwo'
    Headgear(2)=Class'DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_FG42Weapon')
    SecondaryWeapons(0)=(Item=Class'DH_P38Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_BHPWeapon')
}
