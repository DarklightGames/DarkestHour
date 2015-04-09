//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_American_Units extends DHRoleInfo
    abstract;

defaultproperties
{
    Texture=texture'DHEngine_Tex.Allies_RoleInfo'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    DetachedArmClass=class'ROEffects.SeveredArmSovTunic'
    DetachedLegClass=class'ROEffects.SeveredLegSovTunic'
    RolePawnClass="DH_USPlayers.DH_AmericanPawn"
    Side=SIDE_Allies
}
