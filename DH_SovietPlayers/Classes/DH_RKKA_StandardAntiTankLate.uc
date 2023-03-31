//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_StandardAntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicNocoatLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicLatePawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43PawnA',Weight=1.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43PawnB',Weight=1.0)
    RolePawns(4)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43GreenPawnA',Weight=1.0)
    RolePawns(5)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43GreenPawnB',Weight=1.0)
    RolePawns(6)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43DarkPawnA',Weight=1.0)
    RolePawns(7)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43DarkPawnB',Weight=1.0)

    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.9
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
