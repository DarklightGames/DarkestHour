//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardRadioOperatorLate extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicStrapsLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicM43PawnAStraps',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43GreenPawnAStraps',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43DarkPawnAStraps',Weight=1.0)

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    Headgear(0)=Class'DH_SovietSidecap'
	Backpacks(0)=(BackpackClass=Class'DH_SovRadioBackpack',LocationOffset=(X=-0.1))

}
