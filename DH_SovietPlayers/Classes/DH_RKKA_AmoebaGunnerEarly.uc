//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaGunnerEarly extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaPawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.AmoebaGreenSleeves'
    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
