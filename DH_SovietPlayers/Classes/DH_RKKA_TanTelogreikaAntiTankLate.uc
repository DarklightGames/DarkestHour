//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_RKKA_TanTelogreikaAntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloLatePawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
