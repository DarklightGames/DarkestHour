//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_StandardEngineerLate extends DHPOLEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPTunicNocoatLatePawn',Weight=3.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPTunicMixLatePawn',Weight=1.0)

    Headgear(0)=Class'DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'

    PrimaryWeapons(2)=(Item=Class'DH_M44Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
}
