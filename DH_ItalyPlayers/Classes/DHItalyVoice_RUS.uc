//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Voice lines to use when facing Soviet forces.
//==============================================================================

class DHItalyVoice_RUS extends DHItalyVoice;

defaultproperties
{
    EnemySound(0)=SoundGroup'DH_voice_ita_infantry.infantry_rus'
    EnemySound(2)=SoundGroup'DH_voice_ita_infantry.sniper_rus'
    EnemySound(3)=SoundGroup'DH_voice_ita_infantry.pioneer_rus'
    EnemySound(4)=SoundGroup'DH_voice_ita_infantry.AT_soldier_rus'
    
    VehicleAlertSound(0)=SoundGroup'DH_voice_ita_vehicle.enemy_forward_rus'
    VehicleAlertSound(1)=SoundGroup'DH_voice_ita_vehicle.enemy_left_rus'
    VehicleAlertSound(2)=SoundGroup'DH_voice_ita_vehicle.enemy_right_rus'
    VehicleAlertSound(3)=SoundGroup'DH_voice_ita_vehicle.enemy_behind_rus'
    VehicleAlertSound(4)=SoundGroup'DH_voice_ita_vehicle.enemy_infantry_rus'

    ExtraSound(0)=SoundGroup'DH_voice_ita_infantry.i_will_kill_you_rus'
    ExtraSound(2)=SoundGroup'DH_voice_ita_infantry.insult_rus'
}
