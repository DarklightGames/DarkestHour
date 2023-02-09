//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_StandardGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43SergeantPawnB',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43SergeantGreenPawnB',Weight=1.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43SergeantDarkPawnB',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP27LateWeapon')
}
