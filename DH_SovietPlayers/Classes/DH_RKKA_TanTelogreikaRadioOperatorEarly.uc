//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaRadioOperatorEarly extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloStrapsEarlyPawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietFurHat'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
	Backpacks(0)=(BackpackClass=Class'DH_SovRadioBackpack',LocationOffset=(X=-0.1))
}
