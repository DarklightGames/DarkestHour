//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WSSGreatcoatFireteamLeader_Winter extends DHGECorporalRoles;

defaultproperties
{
    AltName="Rottenführer"
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanGreatCoatSSPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    DetachedArmClass=class'ROEffects.SeveredArmGerGreat'
    DetachedLegClass=class'ROEffects.SeveredLegGerGreat'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetNoCover'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G41Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_M712Weapon')
    HandType=Hand_Gloved
}
