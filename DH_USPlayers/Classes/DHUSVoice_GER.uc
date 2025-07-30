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
    EnemySound(0)=SoundGroup'DH_US_Voice_Infantry.infantry_ger'
    EnemySound(1)=SoundGroup'DH_US_Voice_Infantry.MG_ger'
    EnemySound(2)=SoundGroup'DH_US_Voice_Infantry.sniper_ger'
    EnemySound(3)=SoundGroup'DH_US_Voice_Infantry.pioneer_ger'
    EnemySound(4)=SoundGroup'DH_US_Voice_Infantry.AT_soldier_ger'
    EnemySound(5)=SoundGroup'DH_US_Voice_Infantry.Vehicle_ger'
    EnemySound(6)=SoundGroup'DH_US_Voice_Infantry.tank_ger'
    EnemySound(7)=SoundGroup'DH_US_Voice_Infantry.heavy_tank_ger'

    // // Alerts
    AlertSound(0)=SoundGroup'DH_US_Voice_Infantry.Grenade_ger'
    AlertSound(8)=SoundGroup'DH_US_Voice_Infantry.under_attack_at_ger'

    // // Insults
    ExtraSound(0)=SoundGroup'DH_US_Voice_Infantry.i_will_kill_you_ger'
    ExtraSound(2)=SoundGroup'DH_US_Voice_Infantry.insult_ger'

    // // Vehicle Alerts
    VehicleAlertSound(0)=SoundGroup'DH_US_Voice_vehicle.enemy_forward_ger'
    VehicleAlertSound(1)=SoundGroup'DH_US_Voice_vehicle.enemy_left_ger'
    VehicleAlertSound(2)=SoundGroup'DH_US_Voice_vehicle.enemy_right_ger'
    VehicleAlertSound(3)=SoundGroup'DH_US_Voice_vehicle.enemy_behind_ger'
    VehicleAlertSound(4)=SoundGroup'DH_US_Voice_vehicle.enemy_infantry_ger'
}
