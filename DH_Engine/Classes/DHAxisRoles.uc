//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHAxisRoles extends DHRoleInfo
    abstract;

defaultproperties
{
    Texture=Texture'DHEngine_Tex.Axis_RoleInfo'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    VoiceType="DH_GerPlayers.DHGerVoice"
    AltVoiceType="DH_GerPlayers.DHGerVoice"
    DetachedArmClass=class'ROEffects.SeveredArmGerTunic'
    DetachedLegClass=class'ROEffects.SeveredLegGerTunic'
}
