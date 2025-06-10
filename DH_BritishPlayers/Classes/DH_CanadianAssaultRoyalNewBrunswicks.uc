//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CanadianAssaultRoyalNewBrunswicks extends DHCWAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CanadianBrunswicksPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_CanadianVestBrunswicksPawn',Weight=1.0)
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'

    PrimaryWeapons(0)=(Item=Class'DH_StenMkIICWeapon')
    PrimaryWeapons(1)=(Item=Class'DH_StenMkIICWeapon')
    PrimaryWeapons(2)=(Item=Class'DH_StenMkIICWeapon')
}
