//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_AmoebaGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietAmoebaLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.AmoebaGreenSleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP27LateWeapon')
}
