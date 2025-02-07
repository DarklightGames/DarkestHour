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
    EnemySound(0)=SoundGroup'DH_US_Voice_Infantry.spotted.infantry_ita'
    EnemySound(1)=SoundGroup'DH_US_Voice_Infantry.spotted.MG_ita'
    EnemySound(2)=SoundGroup'DH_US_Voice_Infantry.spotted.sniper_ita'
    EnemySound(3)=SoundGroup'DH_US_Voice_Infantry.spotted.pioneer_ita'
    EnemySound(4)=SoundGroup'DH_US_Voice_Infantry.spotted.AT_soldier_ita'
    EnemySound(5)=SoundGroup'DH_US_Voice_Infantry.spotted.Vehicle_ita'
    EnemySound(6)=SoundGroup'DH_US_Voice_Infantry.spotted.tank_ita'
    EnemySound(7)=SoundGroup'DH_US_Voice_Infantry.spotted.heavy_tank_ita'

    // Alerts
    AlertSound(0)=SoundGroup'DH_US_Voice_Infantry.alerts.Grenade_ita'
    AlertSound(8)=SoundGroup'DH_US_Voice_Infantry.alerts.under_attack_at_ita'

    // Insults
    ExtraSound(0)=SoundGroup'DH_US_Voice_Infantry.insults.i_will_kill_you_ita'
    ExtraSound(2)=SoundGroup'DH_US_Voice_Infantry.insults.insult_ita'

    // Vehicle Alerts
    VehicleAlertSound(0)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_forward_ita'
    VehicleAlertSound(1)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_left_ita'
    VehicleAlertSound(2)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_right_ita'
    VehicleAlertSound(3)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_behind_ita'
    VehicleAlertSound(4)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_infantry_ita'
}
