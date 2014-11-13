//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_American_Units extends DH_RoleInfo
    abstract;

defaultproperties
{
     VoiceType="DH_USPlayers.DHUSVoice"
     AltVoiceType="DH_USPlayers.DHUSVoice"
     DetachedArmClass=class'ROEffects.SeveredArmSovTunic'
     DetachedLegClass=class'ROEffects.SeveredLegSovTunic'
     RolePawnClass="DH_USPlayers.DH_AmericanPawn"
     Side=SIDE_Allies
}
