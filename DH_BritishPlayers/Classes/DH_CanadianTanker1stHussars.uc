//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CanadianTanker1stHussars extends DHCWTankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_Canadian1stHussarsPawn',Weight=1.0)
    Headgear(0)=Class'DH_CanadianTankerBeret'
    VoiceType="DH_BritishPlayers.DHCanadianVoice"
    AltVoiceType="DH_BritishPlayers.DHCanadianVoice"
    SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'

    PrimaryWeapons(0)=(Item=Class'DH_StenMkIICWeapon')
    PrimaryWeapons(1)=(Item=Class'DH_StenMkIICWeapon')
    PrimaryWeapons(2)=(Item=Class'DH_StenMkIICWeapon')
}
