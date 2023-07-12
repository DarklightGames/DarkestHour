//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_VSAssault_Winter extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB_Winter',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanGreatCoatPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'ROInventory.ROGermanHat'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_VG15weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_GeratPweapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP3008weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')

    HandType=Hand_Gloved
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    BareHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    CustomHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}
