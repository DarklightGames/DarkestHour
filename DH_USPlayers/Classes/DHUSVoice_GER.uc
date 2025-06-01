//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Voice lines to use when facing German forces
//==============================================================================

class DHUSVoice_GER extends DHUSVoice;

defaultproperties
{
    // Spotted
    EnemySound(0)=SoundGroup'DH_US_Voice_Infantry.spotted.infantry_ger'
    EnemySound(1)=SoundGroup'DH_US_Voice_Infantry.spotted.MG_ger'
    EnemySound(2)=SoundGroup'DH_US_Voice_Infantry.spotted.sniper_ger'
    EnemySound(3)=SoundGroup'DH_US_Voice_Infantry.spotted.pioneer_ger'
    EnemySound(4)=SoundGroup'DH_US_Voice_Infantry.spotted.AT_soldier_ger'
    EnemySound(5)=SoundGroup'DH_US_Voice_Infantry.spotted.Vehicle_ger'
    EnemySound(6)=SoundGroup'DH_US_Voice_Infantry.spotted.tank_ger'
    EnemySound(7)=SoundGroup'DH_US_Voice_Infantry.spotted.heavy_tank_ger'

    // // Alerts
    AlertSound(0)=SoundGroup'DH_US_Voice_Infantry.alerts.Grenade_ger'
    AlertSound(8)=SoundGroup'DH_US_Voice_Infantry.alerts.under_attack_at_ger'

    // // Insults
    ExtraSound(0)=SoundGroup'DH_US_Voice_Infantry.insults.i_will_kill_you_ger'
    ExtraSound(2)=SoundGroup'DH_US_Voice_Infantry.insults.insult_ger'

    // // Vehicle Alerts
    VehicleAlertSound(0)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_forward_ger'
    VehicleAlertSound(1)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_left_ger'
    VehicleAlertSound(2)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_right_ger'
    VehicleAlertSound(3)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_behind_ger'
    VehicleAlertSound(4)=SoundGroup'DH_US_Voice_vehicle.alerts.enemy_infantry_ger'
}
