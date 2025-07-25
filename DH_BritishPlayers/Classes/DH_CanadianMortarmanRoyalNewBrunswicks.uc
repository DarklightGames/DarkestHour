//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CanadianMortarmanRoyalNewBrunswicks extends DHCWMortarmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CanadianBrunswicksPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_CanadianVestBrunswicksPawn',Weight=1.0)
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.CanadianSleeves'
}
