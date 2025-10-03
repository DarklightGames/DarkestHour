//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardEngineerGrey extends DHPOLEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicNocoatGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicMixGreyPawn',Weight=2.0)
    RolePawns(2)=(PawnClass=Class'DH_LWPTunicMixBGreyPawn',Weight=2.0)
    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.LWP_grey_sleeves'

    PrimaryWeapons(2)=(Item=Class'DH_M44Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
}
