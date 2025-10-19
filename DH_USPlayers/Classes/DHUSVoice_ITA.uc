//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Voice lines to use when facing Italian forces.
//==============================================================================

class DHUSVoice_ITA extends DHUSVoice;

defaultproperties
{
    // Spotted
    EnemySound(0)=SoundGroup'DH_US_Voice_Infantry.infantry_ita'
    EnemySound(1)=SoundGroup'DH_US_Voice_Infantry.MG_ita'
    EnemySound(2)=SoundGroup'DH_US_Voice_Infantry.sniper_ita'
    EnemySound(3)=SoundGroup'DH_US_Voice_Infantry.pioneer_ita'
    EnemySound(4)=SoundGroup'DH_US_Voice_Infantry.AT_soldier_ita'
    EnemySound(5)=SoundGroup'DH_US_Voice_Infantry.Vehicle_ita'
    EnemySound(6)=SoundGroup'DH_US_Voice_Infantry.tank_ita'
    EnemySound(7)=SoundGroup'DH_US_Voice_Infantry.heavy_tank_ita'

    // Alerts
    AlertSound(0)=SoundGroup'DH_US_Voice_Infantry.Grenade_ita'
    AlertSound(8)=SoundGroup'DH_US_Voice_Infantry.under_attack_at_ita'

    // Insults
    ExtraSound(0)=SoundGroup'DH_US_Voice_Infantry.i_will_kill_you_ita'
    ExtraSound(2)=SoundGroup'DH_US_Voice_Infantry.insult_ita'

    // Vehicle Alerts
    VehicleAlertSound(0)=SoundGroup'DH_US_Voice_vehicle.enemy_forward_ita'
    VehicleAlertSound(1)=SoundGroup'DH_US_Voice_vehicle.enemy_left_ita'
    VehicleAlertSound(2)=SoundGroup'DH_US_Voice_vehicle.enemy_right_ita'
    VehicleAlertSound(3)=SoundGroup'DH_US_Voice_vehicle.enemy_behind_ita'
    VehicleAlertSound(4)=SoundGroup'DH_US_Voice_vehicle.enemy_infantry_ita'
}
