//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Voice lines to use when facing Soviet forces.
//==============================================================================

class DHItalyVoice_RUS extends DHItalyVoice;

defaultproperties
{
    EnemySound(0)=SoundGroup'DH_voice_ita_infantry.spotted.infantry_rus'
    EnemySound(2)=SoundGroup'DH_voice_ita_infantry.spotted.sniper_rus'
    EnemySound(3)=SoundGroup'DH_voice_ita_infantry.spotted.pioneer_rus'
    EnemySound(4)=SoundGroup'DH_voice_ita_infantry.spotted.AT_soldier_rus'
    
    VehicleAlertSound(0)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_forward_rus'
    VehicleAlertSound(1)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_left_rus'
    VehicleAlertSound(2)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_right_rus'
    VehicleAlertSound(3)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_behind_rus'
    VehicleAlertSound(4)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_infantry_rus'

    ExtraSound(0)=SoundGroup'DH_voice_ita_infantry.insults.i_will_kill_you_rus'
    ExtraSound(2)=SoundGroup'DH_voice_ita_infantry.insults.insult_rus'
}
