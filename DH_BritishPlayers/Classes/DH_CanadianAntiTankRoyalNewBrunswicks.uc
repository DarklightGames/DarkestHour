//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CanadianAntiTankRoyalNewBrunswicks extends DHCWAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_CanadianBrunswicksPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_BritishPlayers.DH_CanadianVestBrunswicksPawn',Weight=1.0)
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIICWeapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_StenMkIICWeapon')
}
