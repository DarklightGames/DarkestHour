//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BritishAssaultOx_Bucks extends DHCWAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishAirbornePawn',Weight=1.0)
    Headgear(0)=class'DH_BritishPlayers.DH_BritishParaHelmetOne'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishParaHelmetTwo'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishParaHelmetOne'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkVWeapon')
    PrimaryWeapons(1)=(Item=none)
    PrimaryWeapons(2)=(Item=none)
}
