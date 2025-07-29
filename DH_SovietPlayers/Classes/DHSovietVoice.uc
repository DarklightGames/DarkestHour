//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSovietVoice extends DHVoicePack;

defaultproperties
{
    // Support sound groups
    SupportSound[0]=SoundGroup'voice_sov_infantry.need_help'
    SupportSound[1]=SoundGroup'voice_sov_infantry.need_help_at'
    SupportSound[2]=SoundGroup'voice_sov_infantry.need_ammo'
    SupportSound[3]=SoundGroup'voice_sov_infantry.need_sniper'
    SupportSound[4]=SoundGroup'voice_sov_infantry.need_MG'
    SupportSound[5]=SoundGroup'voice_sov_infantry.need_AT'
    SupportSound[6]=SoundGroup'voice_sov_infantry.need_demolitions'
    SupportSound[7]=SoundGroup'voice_sov_infantry.need_tank'
    SupportSound[8]=SoundGroup'voice_sov_infantry.need_artillery'
    SupportSound[9]=SoundGroup'voice_sov_infantry.need_transport'

    // Ack sound groups
    AckSound[0]=SoundGroup'voice_sov_infantry.yes'
    AckSound[1]=SoundGroup'voice_sov_infantry.no'
    AckSound[2]=SoundGroup'voice_sov_infantry.thanks'
    AckSound[3]=SoundGroup'voice_sov_infantry.sorry'

    // Enemy sound groups
    EnemySound[0]=SoundGroup'voice_sov_infantry.infantry'
    EnemySound[1]=SoundGroup'voice_sov_infantry.MG'
    EnemySound[2]=SoundGroup'voice_sov_infantry.sniper'
    EnemySound[3]=SoundGroup'voice_sov_infantry.pioneer'
    EnemySound[4]=SoundGroup'voice_sov_infantry.AT_soldier'
    EnemySound[5]=SoundGroup'voice_sov_infantry.Vehicle'
    EnemySound[6]=SoundGroup'voice_sov_infantry.tank'
    EnemySound[7]=SoundGroup'voice_sov_infantry.heavy_tank'
    EnemySound[8]=SoundGroup'voice_sov_infantry.artillery'

    // Alert sound groups
    AlertSound[0]=SoundGroup'voice_sov_infantry.Grenade'
    AlertSound[1]=SoundGroup'voice_sov_infantry.gogogo'
    AlertSound[2]=SoundGroup'voice_sov_infantry.take_cover'
    AlertSound[3]=SoundGroup'voice_sov_infantry.Stop'
    AlertSound[4]=SoundGroup'voice_sov_infantry.follow_me'
    AlertSound[5]=SoundGroup'voice_sov_infantry.satchel_planted'
    AlertSound[6]=SoundGroup'voice_sov_infantry.covering_fire'
    AlertSound[7]=SoundGroup'voice_sov_infantry.friendly_fire'
    AlertSound[8]=SoundGroup'voice_sov_infantry.under_attack_at'
    AlertSound[9]=SoundGroup'voice_sov_infantry.retreat'

    // Vehicle direction sound groups
    vehicleDirectionSound[0]=SoundGroup'voice_sov_vehicle.go_to_objective'
    vehicleDirectionSound[1]=SoundGroup'voice_sov_vehicle.forwards'
    vehicleDirectionSound[2]=SoundGroup'voice_sov_vehicle.Stop'
    vehicleDirectionSound[3]=SoundGroup'voice_sov_vehicle.Reverse'
    vehicleDirectionSound[4]=SoundGroup'voice_sov_vehicle.Left'
    vehicleDirectionSound[5]=SoundGroup'voice_sov_vehicle.Right'
    vehicleDirectionSound[6]=SoundGroup'voice_sov_vehicle.nudge_forward'
    vehicleDirectionSound[7]=SoundGroup'voice_sov_vehicle.nudge_back'
    vehicleDirectionSound[8]=SoundGroup'voice_sov_vehicle.nudge_left'
    vehicleDirectionSound[9]=SoundGroup'voice_sov_vehicle.nudge_right'

    // Vehicle alert sound groups
    vehicleAlertSound[0]=SoundGroup'voice_sov_vehicle.enemy_forward'
    vehicleAlertSound[1]=SoundGroup'voice_sov_vehicle.enemy_left'
    vehicleAlertSound[2]=SoundGroup'voice_sov_vehicle.enemy_right'
    vehicleAlertSound[3]=SoundGroup'voice_sov_vehicle.enemy_behind'
    vehicleAlertSound[4]=SoundGroup'voice_sov_vehicle.enemy_infantry'
    vehicleAlertSound[5]=SoundGroup'voice_sov_vehicle.yes'
    vehicleAlertSound[6]=SoundGroup'voice_sov_vehicle.no'
    vehicleAlertSound[7]=SoundGroup'voice_sov_vehicle.we_are_burning'
    vehicleAlertSound[8]=SoundGroup'voice_sov_vehicle.get_out'
    vehicleAlertSound[9]=SoundGroup'voice_sov_vehicle.Loaded'

    // Commander sound groups
    OrderSound[0]=SoundGroup'voice_sov_infantry.attack_objective'
    OrderSound[1]=SoundGroup'voice_sov_infantry.defend_objective'
    OrderSound[2]=SoundGroup'voice_sov_infantry.hold_this_position'
    OrderSound[3]=SoundGroup'voice_sov_infantry.follow_me'
    OrderSound[6]=SoundGroup'voice_sov_infantry.Attack'
    OrderSound[5]=SoundGroup'voice_sov_infantry.retreat'
    OrderSound[4]=SoundGroup'voice_sov_infantry.fire_at_will' //attack and fire at will are swapped as they were wrong in RO
    OrderSound[7]=SoundGroup'voice_sov_infantry.cease_fire'

    // Extras sound groups
    ExtraSound[0]=SoundGroup'voice_sov_infantry.i_will_kill_you'
    ExtraSound[1]=SoundGroup'voice_sov_infantry.no_retreat'
    ExtraSound[2]=SoundGroup'voice_sov_infantry.insult'


    RadioRequestSound=SoundGroup'Artillery.RusRequest'
    RadioResponseConfirmSound=SoundGroup'voice_sov_infantry.confirm'
    RadioResponseDenySound=SoundGroup'voice_sov_infantry.Deny'
}
