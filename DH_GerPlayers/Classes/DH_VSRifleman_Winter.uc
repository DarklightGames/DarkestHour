//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VSRifleman_Winter extends DHGERiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_VSGreatCoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_VSGreatCoatPawnB_Winter',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.Volkssturm_sleeve'
    Headgear(0)=Class'ROGermanHat'
    Headgear(1)=Class'ROGermanHat'
    PrimaryWeapons(0)=(Item=Class'DH_G98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=Class'ROKar98AmmoPouch')
    HandType=Hand_Gloved
    
    bCanBeSquadLeader=false
}
