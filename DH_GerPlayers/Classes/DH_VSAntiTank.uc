//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VSAntiTank extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_VSGreatCoatPawnB',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_VSGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'ROGermanHat'

    PrimaryWeapons(0)=(Item=Class'DH_VK98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=Class'ROKar98AmmoPouch')

    GivenItems(0)="DH_Weapons.DH_PanzerfaustWeapon"
    GivenItems(1)="none"
    
    bCanBeSquadLeader=false
}
