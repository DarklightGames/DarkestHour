//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CanadianTanker1stHussars extends DHCWTankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_Canadian1stHussarsPawn',Weight=1.0)
    Headgear(0)=class'DH_BritishPlayers.DH_CanadianTankerBeret'
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIICWeapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIICWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_StenMkIICWeapon')
}
