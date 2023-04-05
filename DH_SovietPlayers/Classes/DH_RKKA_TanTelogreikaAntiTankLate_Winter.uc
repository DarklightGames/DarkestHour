//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_TanTelogreikaAntiTankLate_Winter extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloLatePawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
    HandType=Hand_Gloved
}
