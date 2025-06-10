 //==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardAntiTankGrey extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicNocoatGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicMixGreyPawn',Weight=1.0)
    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
