//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_AmoebaAutumnGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietAmoebaAutumnLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.AmoebaSleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP27LateWeapon')
}
