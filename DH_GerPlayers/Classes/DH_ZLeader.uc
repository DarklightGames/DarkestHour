//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Halloween Special 2020

class DH_ZLeader extends DHAxisRoles;

defaultproperties
{
    MyName="Der F�hrer"
    AltName="Der F�hrer"
    Article=""
    PluralName=""
    Limit=1

    bIsLeader=true
    bRequiresSL=true

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombieLeaderPawn',Weight=1.0)

    HandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.h_sleeves_zombie'

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
}
