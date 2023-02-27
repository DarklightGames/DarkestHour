//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCzechVoice extends DHVoicePack; //to do: vehicle voices; may be slovak voice pack?

defaultproperties
{
    SupportSound(0)=SoundGroup'DH_voice_cz_Infantry.requests.need_help'
    SupportSound(1)=SoundGroup'DH_voice_cz_Infantry.requests.need_help'
    SupportSound(2)=SoundGroup'DH_voice_cz_Infantry.requests.need_ammo'
    SupportSound(3)=SoundGroup'DH_voice_cz_Infantry.requests.need_sniper'
    SupportSound(4)=SoundGroup'DH_voice_cz_Infantry.requests.need_MG'
    SupportSound(5)=SoundGroup'DH_voice_cz_Infantry.requests.need_AT'
    SupportSound(6)=SoundGroup'DH_voice_cz_Infantry.requests.need_demolitions'
    SupportSound(7)=SoundGroup'DH_voice_cz_Infantry.requests.need_tank'
    SupportSound(8)=SoundGroup'DH_voice_cz_Infantry.requests.need_artillery'
    SupportSound(9)=SoundGroup'DH_voice_cz_Infantry.requests.need_transport'

    EnemySound(0)=SoundGroup'DH_voice_cz_Infantry.spotted.infantry'
    EnemySound(1)=SoundGroup'DH_voice_cz_Infantry.spotted.MG'
    EnemySound(2)=SoundGroup'DH_voice_cz_Infantry.spotted.sniper'
    EnemySound(3)=SoundGroup'DH_voice_cz_Infantry.spotted.AT_soldier'
    EnemySound(4)=SoundGroup'DH_voice_cz_Infantry.spotted.AT_soldier'
    EnemySound(5)=SoundGroup'DH_voice_cz_Infantry.spotted.Vehicle'
    EnemySound(6)=SoundGroup'DH_voice_cz_Infantry.spotted.tank'
    EnemySound(7)=SoundGroup'DH_voice_cz_Infantry.spotted.heavy_tank'
    EnemySound(8)=SoundGroup'DH_voice_cz_Infantry.spotted.Artillery'
    AlertSound(0)=SoundGroup'DH_voice_cz_Infantry.alerts.Grenade'
    AlertSound(1)=SoundGroup'DH_voice_cz_Infantry.alerts.gogogo'
    AlertSound(2)=SoundGroup'DH_voice_cz_Infantry.alerts.take_cover'
    AlertSound(3)=SoundGroup'DH_voice_cz_Infantry.alerts.Stop'
    AlertSound(4)=SoundGroup'DH_voice_cz_Infantry.commander.follow_me'
    AlertSound(5)=SoundGroup'DH_voice_cz_Infantry.alerts.satchel_planted'
    AlertSound(6)=SoundGroup'DH_voice_cz_Infantry.alerts.covering_fire'
    AlertSound(7)=SoundGroup'DH_voice_cz_Infantry.alerts.friendly_fire'
    AlertSound(8)=SoundGroup'DH_voice_cz_Infantry.alerts.under_attack_at'
    AlertSound(9)=SoundGroup'DH_voice_cz_Infantry.commander.retreat'
    //VehicleDirectionSound(0)=SoundGroup'DH_voice_cz_vehicle.directions.go_to_objective' //add veh sounds
    //VehicleDirectionSound(1)=SoundGroup'DH_voice_cz_vehicle.directions.forward'
    //VehicleDirectionSound(2)=SoundGroup'DH_voice_cz_vehicle.directions.Stop'
    //VehicleDirectionSound(3)=SoundGroup'DH_voice_cz_vehicle.directions.Reverse'
    //VehicleDirectionSound(4)=SoundGroup'DH_voice_cz_vehicle.directions.Left'
    //VehicleDirectionSound(5)=SoundGroup'DH_voice_cz_vehicle.directions.Right'
    //VehicleDirectionSound(6)=SoundGroup'DH_voice_cz_vehicle.directions.nudge_forward'
    //VehicleDirectionSound(7)=SoundGroup'DH_voice_cz_vehicle.directions.nudge_backward'
    //VehicleDirectionSound(8)=SoundGroup'DH_voice_cz_vehicle.directions.nudge_left'
    //VehicleDirectionSound(9)=SoundGroup'DH_voice_cz_vehicle.directions.nudge_right'
    //VehicleAlertSound(0)=SoundGroup'DH_voice_cz_vehicle.alerts.enemy_forward'
    //VehicleAlertSound(1)=SoundGroup'DH_voice_cz_vehicle.alerts.enemy_left'
    //VehicleAlertSound(2)=SoundGroup'DH_voice_cz_vehicle.alerts.enemy_right'
    //VehicleAlertSound(3)=SoundGroup'DH_voice_cz_vehicle.alerts.enemy_behind'
    //VehicleAlertSound(4)=SoundGroup'DH_voice_cz_vehicle.alerts.enemy_infantry'
    //VehicleAlertSound(5)=SoundGroup'DH_voice_cz_vehicle.alerts.yes'
    //VehicleAlertSound(6)=SoundGroup'DH_voice_cz_vehicle.alerts.no'
    //VehicleAlertSound(7)=SoundGroup'DH_voice_cz_vehicle.alerts.we_are_burning'
    //VehicleAlertSound(8)=SoundGroup'DH_voice_cz_vehicle.alerts.get_out'
    //VehicleAlertSound(9)=SoundGroup'DH_voice_cz_vehicle.alerts.Loaded'
    ExtraSound(0)=SoundGroup'DH_voice_cz_Infantry.insult.i_will_kill_you'
    ExtraSound(1)=SoundGroup'DH_voice_cz_Infantry.insult.no_retreat'
    ExtraSound(2)=SoundGroup'DH_voice_cz_Infantry.insult.insult'
    AckSound(0)=SoundGroup'DH_voice_cz_Infantry.responses.yes'
    AckSound(1)=SoundGroup'DH_voice_cz_Infantry.responses.no'
    AckSound(2)=SoundGroup'DH_voice_cz_Infantry.responses.thanks'
    AckSound(3)=SoundGroup'DH_voice_cz_Infantry.responses.sorry'
    OrderSound(0)=SoundGroup'DH_voice_cz_Infantry.commander.Attack'
    OrderSound(1)=SoundGroup'DH_voice_cz_Infantry.commander.hold_this_position'
    OrderSound(2)=SoundGroup'DH_voice_cz_Infantry.commander.hold_this_position'
    OrderSound(3)=SoundGroup'DH_voice_cz_Infantry.commander.follow_me'
    OrderSound(4)=SoundGroup'DH_voice_cz_Infantry.commander.Attack'
    OrderSound(5)=SoundGroup'DH_voice_cz_Infantry.commander.retreat'
    OrderSound(6)=SoundGroup'DH_voice_cz_Infantry.commander.Attack' //was fire at will
    OrderSound(7)=SoundGroup'DH_voice_cz_Infantry.commander.cease_fire'

    RadioRequestSound=SoundGroup'DH_voice_cz_Infantry.requests.csrusrequest'  //russian request with czech accent
    RadioResponseConfirmSound=SoundGroup'voice_sov_infantry.artillery.confirm' //russian response from soviet artillery units
    RadioResponseDenySound=SoundGroup'voice_sov_infantry.artillery.Deny'
}
