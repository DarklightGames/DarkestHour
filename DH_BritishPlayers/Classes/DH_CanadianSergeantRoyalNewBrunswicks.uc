//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CanadianSergeantRoyalNewBrunswicks extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_CanadianSergeantBrunswicksPawn')
    RolePawns(1)=(PawnClass=class'DH_BritishPlayers.DH_CanadianVestSergeantBrunswicksPawn')
    Headgear(0)=class'DH_BritishPlayers.DH_CanadianInfantryBeretRoyalNewBrunswicks'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
}
