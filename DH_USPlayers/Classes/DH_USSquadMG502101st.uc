//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_USSquadMG502101st extends DHUSAutoRifleRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USAB101stPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stEMb'

    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_BARNoBipodWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
}
