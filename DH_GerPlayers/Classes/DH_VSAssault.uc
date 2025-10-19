//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VSAssault extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_VSGreatCoatPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_VSGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.GermanCoatSleeves'
    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'ROGermanHat'

    PrimaryWeapons(0)=(Item=Class'DH_VG15weapon',AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_GeratPweapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_MP3008weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
}
