//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Halloween Special 2020

class DH_ZLeader extends DHGESergeantRoles;

defaultproperties
{
    MyName="Der Führer"
    AltName="Der Führer"
    Article=""
    PluralName=""
    Limit=1

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombieLeaderPawn',Weight=1.0)

    HandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.h_sleeves_zombie'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_ViSWeapon')
}
