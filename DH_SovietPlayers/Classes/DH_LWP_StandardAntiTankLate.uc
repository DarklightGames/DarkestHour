//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LWP_StandardAntiTankLate extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicNocoatLatePawn',Weight=3.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicMixLatePawn',Weight=1.0)

    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
