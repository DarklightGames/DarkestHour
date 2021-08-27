//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWP_GreatcoatAntiTank_Winter extends DHPOLAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatBrownBagPawn_Winter',Weight=3.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatGreyBagPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
    
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
    BareHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
    CustomHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}
