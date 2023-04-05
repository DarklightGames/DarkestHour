//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_StandardAssaultEarly extends DHSOVAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicBackpackEarlyPawn',Weight=6.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicBackpackEarlyDarkPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicEarlyPawn',Weight=6.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicEarlyDarkPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPD40Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
}
