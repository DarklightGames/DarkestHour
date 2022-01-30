//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKF_SniperBlackSea extends DHSOVSniperRoles;  //this role wears a naval cap, which has a different writing on it depending on the fleet, so this role is separated on fleets

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietMarineBushlatPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietNavalCap_BlackSea'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.NavalSleeves2'


    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40ScopedWeapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}
