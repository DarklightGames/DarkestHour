//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_BritcoatAssault_Winter extends DHCSAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CSAZbritcoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_CSAZbritcoatSidorPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_BritishTommyHelmetSnow'
    SleeveTexture=Texture'DHBritishCharactersTex.Brit_Coat_Sleeves'
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
}
