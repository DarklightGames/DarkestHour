//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSGreatcoatFireteamLeader_Winter extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=Class'DH_GermanGreatCoatSSPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    DetachedArmClass=Class'SeveredArmGerGreat'
    DetachedLegClass=Class'SeveredLegGerGreat'
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetNoCover'
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_G41Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M712Weapon')
    HandType=Hand_Gloved
}
