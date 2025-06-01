//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CanadianEngineerRoyalNewBrunswicks extends DHCWEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_CanadianBrunswicksPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_BritishPlayers.DH_CanadianVestBrunswicksPawn',Weight=1.0)
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
}
