//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_British_Commonwealth_Units extends DH_RoleInfo
    abstract;

defaultproperties
{
     VoiceType="DH_BritishPlayers.DHBritishVoice"
     AltVoiceType="DH_BritishPlayers.DHBritishVoice"
     DetachedArmClass=class'ROEffects.SeveredArmSovTunic'
     DetachedLegClass=class'ROEffects.SeveredLegSovTunic'
     RolePawnClass="DH_BritishPlayers.DH_BritishPawn"
     Side=SIDE_Allies
}
