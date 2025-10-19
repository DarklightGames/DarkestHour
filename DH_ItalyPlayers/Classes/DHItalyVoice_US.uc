//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Voice lines to use when facing US forces.
//==============================================================================

class DHItalyVoice_US extends DHItalyVoice;

defaultproperties
{
    EnemySound(0)=SoundGroup'DH_voice_ita_infantry.infantry_us'
    EnemySound(2)=SoundGroup'DH_voice_ita_infantry.sniper_us'
    EnemySound(3)=SoundGroup'DH_voice_ita_infantry.pioneer_us'
    EnemySound(4)=SoundGroup'DH_voice_ita_infantry.AT_soldier_us'
    
    VehicleAlertSound(0)=SoundGroup'DH_voice_ita_vehicle.enemy_forward_us'
    VehicleAlertSound(1)=SoundGroup'DH_voice_ita_vehicle.enemy_left_us'
    VehicleAlertSound(2)=SoundGroup'DH_voice_ita_vehicle.enemy_right_us'
    VehicleAlertSound(3)=SoundGroup'DH_voice_ita_vehicle.enemy_behind_us'
    VehicleAlertSound(4)=SoundGroup'DH_voice_ita_vehicle.enemy_infantry_us'

    ExtraSound(0)=SoundGroup'DH_voice_ita_infantry.i_will_kill_you_us'
    ExtraSound(2)=SoundGroup'DH_voice_ita_infantry.insult_us'
}
