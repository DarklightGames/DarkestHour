//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardRadioOperatorEarly extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicStrapsEarlyPawn',Weight=6.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicStrapsEarlyDarkPawn',Weight=1.0)

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
	Backpacks(0)=(BackpackClass=class'DH_SovietPlayers.DH_SovRadioBackpack',LocationOffset=(X=-0.1))
}
