//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BritishSergeantOx_Bucks extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishAirbornSergeantPawn')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'

    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkVWeapon')
    PrimaryWeapons(2)=(Item=none)
}
