//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_Leaf1942AntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietLeaf1942LatePawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.Leaf1942Sleeves'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
