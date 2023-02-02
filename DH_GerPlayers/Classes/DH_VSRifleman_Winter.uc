//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_VSRifleman_Winter extends DHGERiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB_Winter',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Volkssturm_sleeve'
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'ROInventory.ROGermanHat'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_VK98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    HandType=Hand_Gloved
}
