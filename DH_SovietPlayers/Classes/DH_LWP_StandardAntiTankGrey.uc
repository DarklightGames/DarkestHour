//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWP_StandardAntiTankGrey extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicNocoatGreyPawn',Weight=2.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
