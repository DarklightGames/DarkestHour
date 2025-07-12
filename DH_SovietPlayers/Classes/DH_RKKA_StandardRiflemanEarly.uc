//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardRiflemanEarly extends DHSOVRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicBackpackEarlyPawn',Weight=6.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicBackpackEarlyDarkPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicEarlyPawn',Weight=3.0)

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    Headgear(0)=Class'DH_SovietSidecap'
}
