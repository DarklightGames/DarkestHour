//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSovietVoice extends DHVoicePack;

defaultproperties
{
    // Support sound groups
    SupportSound[0]=SoundGroup'voice_sov_infantry.requests.need_help'
    SupportSound[1]=SoundGroup'voice_sov_infantry.requests.need_help_at'
    SupportSound[2]=SoundGroup'voice_sov_infantry.requests.need_ammo'
    SupportSound[3]=SoundGroup'voice_sov_infantry.requests.need_sniper'
    SupportSound[4]=SoundGroup'voice_sov_infantry.requests.need_MG'
    SupportSound[5]=SoundGroup'voice_sov_infantry.requests.need_AT'
    SupportSound[6]=SoundGroup'voice_sov_infantry.requests.need_demolitions'
    SupportSound[7]=SoundGroup'voice_sov_infantry.requests.need_tank'
    SupportSound[8]=SoundGroup'voice_sov_infantry.requests.need_artillery'
    SupportSound[9]=SoundGroup'voice_sov_infantry.requests.need_transport'

    // Ack sound groups
    AckSound[0]=SoundGroup'voice_sov_infantry.responses.yes'
    AckSound[1]=SoundGroup'voice_sov_infantry.responses.no'
    AckSound[2]=SoundGroup'voice_sov_infantry.responses.thanks'
    AckSound[3]=SoundGroup'voice_sov_infantry.responses.sorry'

    // Enemy sound groups
    EnemySound[0]=SoundGroup'voice_sov_infantry.spotted.infantry'
    EnemySound[1]=SoundGroup'voice_sov_infantry.spotted.MG'
    EnemySound[2]=SoundGroup'voice_sov_infantry.spotted.sniper'
    EnemySound[3]=SoundGroup'voice_sov_infantry.spotted.pioneer'
    EnemySound[4]=SoundGroup'voice_sov_infantry.spotted.AT_soldier'
    EnemySound[5]=SoundGroup'voice_sov_infantry.spotted.Vehicle'
    EnemySound[6]=SoundGroup'voice_sov_infantry.spotted.tank'
    EnemySound[7]=SoundGroup'voice_sov_infantry.spotted.heavy_tank'
    EnemySound[8]=SoundGroup'voice_sov_infantry.spotted.artillery'

    // Alert sound groups
    AlertSound[0]=SoundGroup'voice_sov_infantry.alerts.Grenade'
    AlertSound[1]=SoundGroup'voice_sov_infantry.alerts.gogogo'
    AlertSound[2]=SoundGroup'voice_sov_infantry.alerts.take_cover'
    AlertSound[3]=SoundGroup'voice_sov_infantry.alerts.Stop'
    AlertSound[4]=SoundGroup'voice_sov_infantry.commander.follow_me'
    AlertSound[5]=SoundGroup'voice_sov_infantry.alerts.satchel_planted'
    AlertSound[6]=SoundGroup'voice_sov_infantry.alerts.covering_fire'
    AlertSound[7]=SoundGroup'voice_sov_infantry.alerts.friendly_fire'
    AlertSound[8]=SoundGroup'voice_sov_infantry.alerts.under_attack_at'
    AlertSound[9]=SoundGroup'voice_sov_infantry.commander.retreat'

    // Vehicle direction sound groups
    vehicleDirectionSound[0]=SoundGroup'voice_sov_vehicle.directions.go_to_objective'
    vehicleDirectionSound[1]=SoundGroup'voice_sov_vehicle.directions.forwards'
    vehicleDirectionSound[2]=SoundGroup'voice_sov_vehicle.directions.Stop'
    vehicleDirectionSound[3]=SoundGroup'voice_sov_vehicle.directions.Reverse'
    vehicleDirectionSound[4]=SoundGroup'voice_sov_vehicle.directions.Left'
    vehicleDirectionSound[5]=SoundGroup'voice_sov_vehicle.directions.Right'
    vehicleDirectionSound[6]=SoundGroup'voice_sov_vehicle.directions.nudge_forward'
    vehicleDirectionSound[7]=SoundGroup'voice_sov_vehicle.directions.nudge_back'
    vehicleDirectionSound[8]=SoundGroup'voice_sov_vehicle.directions.nudge_left'
    vehicleDirectionSound[9]=SoundGroup'voice_sov_vehicle.directions.nudge_right'

    // Vehicle alert sound groups
    vehicleAlertSound[0]=SoundGroup'voice_sov_vehicle.alerts.enemy_forward'
    vehicleAlertSound[1]=SoundGroup'voice_sov_vehicle.alerts.enemy_left'
    vehicleAlertSound[2]=SoundGroup'voice_sov_vehicle.alerts.enemy_right'
    vehicleAlertSound[3]=SoundGroup'voice_sov_vehicle.alerts.enemy_behind'
    vehicleAlertSound[4]=SoundGroup'voice_sov_vehicle.alerts.enemy_infantry'
    vehicleAlertSound[5]=SoundGroup'voice_sov_vehicle.alerts.yes'
    vehicleAlertSound[6]=SoundGroup'voice_sov_vehicle.alerts.no'
    vehicleAlertSound[7]=SoundGroup'voice_sov_vehicle.alerts.we_are_burning'
    vehicleAlertSound[8]=SoundGroup'voice_sov_vehicle.alerts.get_out'
    vehicleAlertSound[9]=SoundGroup'voice_sov_vehicle.alerts.Loaded'

    // Commander sound groups
    OrderSound[0]=SoundGroup'voice_sov_infantry.commander.attack_objective'
    OrderSound[1]=SoundGroup'voice_sov_infantry.commander.defend_objective'
    OrderSound[2]=SoundGroup'voice_sov_infantry.commander.hold_this_position'
    OrderSound[3]=SoundGroup'voice_sov_infantry.commander.follow_me'
    OrderSound[6]=SoundGroup'voice_sov_infantry.commander.Attack'
    OrderSound[5]=SoundGroup'voice_sov_infantry.commander.retreat'
    OrderSound[4]=SoundGroup'voice_sov_infantry.commander.fire_at_will' //attack and fire at will are swapped as they were wrong in RO
    OrderSound[7]=SoundGroup'voice_sov_infantry.commander.cease_fire'

    // Extras sound groups
    ExtraSound[0]=SoundGroup'voice_sov_infantry.insults.i_will_kill_you'
    ExtraSound[1]=SoundGroup'voice_sov_infantry.insults.no_retreat'
    ExtraSound[2]=SoundGroup'voice_sov_infantry.insults.insult'


    RadioRequestSound=SoundGroup'Artillery.Request.RusRequest'
    RadioResponseConfirmSound=SoundGroup'voice_sov_infantry.artillery.confirm'
    RadioResponseDenySound=SoundGroup'voice_sov_infantry.artillery.Deny'
}
