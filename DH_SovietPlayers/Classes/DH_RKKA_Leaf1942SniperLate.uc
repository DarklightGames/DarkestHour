//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_Leaf1942SniperLate extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietLeaf1942LatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.Leaf1942Sleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
  
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')  
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_Nagant1895BramitWeapon')
}
