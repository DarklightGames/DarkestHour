//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_LWP_StandardAntiTankLate extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicNocoatLatePawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'

    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"


}
