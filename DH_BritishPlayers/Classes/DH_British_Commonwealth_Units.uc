// *************************************************************************
//
//	***  DH_British_Commonwealth_Units    ***
//
// *************************************************************************

class DH_British_Commonwealth_Units extends DH_RoleInfo
	abstract;

defaultproperties
{
     VoiceType="DH_BritishPlayers.DHBritishVoice"
     AltVoiceType="DH_BritishPlayers.DHBritishVoice"
     DetachedArmClass=Class'ROEffects.SeveredArmSovTunic'
     DetachedLegClass=Class'ROEffects.SeveredLegSovTunic'
     RolePawnClass="DH_BritishPlayers.DH_BritishPawn"
     Side=SIDE_Allies
}
