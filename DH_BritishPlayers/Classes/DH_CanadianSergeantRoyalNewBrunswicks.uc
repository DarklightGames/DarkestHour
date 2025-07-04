//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CanadianSergeantRoyalNewBrunswicks extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CanadianSergeantBrunswicksPawn')
    RolePawns(1)=(PawnClass=Class'DH_CanadianVestSergeantBrunswicksPawn')
    Headgear(0)=Class'DH_CanadianInfantryBeretRoyalNewBrunswicks'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.CanadianSleeves'
}
