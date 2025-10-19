//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardGunnerLate extends DHPOLMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicNocoatLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicMixLatePawn',Weight=2.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicLatePawn',Weight=2.0)

    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
}
