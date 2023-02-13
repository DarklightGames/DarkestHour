//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USRifleman82nd extends DHUSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USAB82ndPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'


    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
}
