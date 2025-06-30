//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCzechVoice extends DHVoicePack; //to do: vehicle voices; may be slovak voice pack?

defaultproperties
{
    SupportSound(0)=SoundGroup'DH_voice_cz_Infantry.need_help'
    SupportSound(1)=SoundGroup'DH_voice_cz_Infantry.need_help'
    SupportSound(2)=SoundGroup'DH_voice_cz_Infantry.need_ammo'
    SupportSound(3)=SoundGroup'DH_voice_cz_Infantry.need_sniper'
    SupportSound(4)=SoundGroup'DH_voice_cz_Infantry.need_MG'
    SupportSound(5)=SoundGroup'DH_voice_cz_Infantry.need_AT'
    SupportSound(6)=SoundGroup'DH_voice_cz_Infantry.need_demolitions'
    SupportSound(7)=SoundGroup'DH_voice_cz_Infantry.need_tank'
    SupportSound(8)=SoundGroup'DH_voice_cz_Infantry.need_artillery'
    SupportSound(9)=SoundGroup'DH_voice_cz_Infantry.need_transport'

    EnemySound(0)=SoundGroup'DH_voice_cz_Infantry.infantry'
    EnemySound(1)=SoundGroup'DH_voice_cz_Infantry.MG'
    EnemySound(2)=SoundGroup'DH_voice_cz_Infantry.sniper'
    EnemySound(3)=SoundGroup'DH_voice_cz_Infantry.AT_soldier'
    EnemySound(4)=SoundGroup'DH_voice_cz_Infantry.AT_soldier'
    EnemySound(5)=SoundGroup'DH_voice_cz_Infantry.Vehicle'
    EnemySound(6)=SoundGroup'DH_voice_cz_Infantry.tank'
    EnemySound(7)=SoundGroup'DH_voice_cz_Infantry.heavy_tank'
    EnemySound(8)=SoundGroup'DH_voice_cz_Infantry.Artillery'
    AlertSound(0)=SoundGroup'DH_voice_cz_Infantry.Grenade'
    AlertSound(1)=SoundGroup'DH_voice_cz_Infantry.gogogo'
    AlertSound(2)=SoundGroup'DH_voice_cz_Infantry.take_cover'
    AlertSound(3)=SoundGroup'DH_voice_cz_Infantry.Stop'
    AlertSound(4)=SoundGroup'DH_voice_cz_Infantry.follow_me'
    AlertSound(5)=SoundGroup'DH_voice_cz_Infantry.satchel_planted'
    AlertSound(6)=SoundGroup'DH_voice_cz_Infantry.covering_fire'
    AlertSound(7)=SoundGroup'DH_voice_cz_Infantry.friendly_fire'
    AlertSound(8)=SoundGroup'DH_voice_cz_Infantry.under_attack_at'
    AlertSound(9)=SoundGroup'DH_voice_cz_Infantry.retreat'
    //VehicleDirectionSound(0)=SoundGroup'DH_voice_cz_vehicle.go_to_objective' //add veh sounds
    //VehicleDirectionSound(1)=SoundGroup'DH_voice_cz_vehicle.forward'
    //VehicleDirectionSound(2)=SoundGroup'DH_voice_cz_vehicle.Stop'
    //VehicleDirectionSound(3)=SoundGroup'DH_voice_cz_vehicle.Reverse'
    //VehicleDirectionSound(4)=SoundGroup'DH_voice_cz_vehicle.Left'
    //VehicleDirectionSound(5)=SoundGroup'DH_voice_cz_vehicle.Right'
    //VehicleDirectionSound(6)=SoundGroup'DH_voice_cz_vehicle.nudge_forward'
    //VehicleDirectionSound(7)=SoundGroup'DH_voice_cz_vehicle.nudge_backward'
    //VehicleDirectionSound(8)=SoundGroup'DH_voice_cz_vehicle.nudge_left'
    //VehicleDirectionSound(9)=SoundGroup'DH_voice_cz_vehicle.nudge_right'
    //VehicleAlertSound(0)=SoundGroup'DH_voice_cz_vehicle.enemy_forward'
    //VehicleAlertSound(1)=SoundGroup'DH_voice_cz_vehicle.enemy_left'
    //VehicleAlertSound(2)=SoundGroup'DH_voice_cz_vehicle.enemy_right'
    //VehicleAlertSound(3)=SoundGroup'DH_voice_cz_vehicle.enemy_behind'
    //VehicleAlertSound(4)=SoundGroup'DH_voice_cz_vehicle.enemy_infantry'
    //VehicleAlertSound(5)=SoundGroup'DH_voice_cz_vehicle.yes'
    //VehicleAlertSound(6)=SoundGroup'DH_voice_cz_vehicle.no'
    //VehicleAlertSound(7)=SoundGroup'DH_voice_cz_vehicle.we_are_burning'
    //VehicleAlertSound(8)=SoundGroup'DH_voice_cz_vehicle.get_out'
    //VehicleAlertSound(9)=SoundGroup'DH_voice_cz_vehicle.Loaded'
    ExtraSound(0)=SoundGroup'DH_voice_cz_Infantry.i_will_kill_you'
    ExtraSound(1)=SoundGroup'DH_voice_cz_Infantry.no_retreat'
    ExtraSound(2)=SoundGroup'DH_voice_cz_Infantry.insult'
    AckSound(0)=SoundGroup'DH_voice_cz_Infantry.yes'
    AckSound(1)=SoundGroup'DH_voice_cz_Infantry.no'
    AckSound(2)=SoundGroup'DH_voice_cz_Infantry.thanks'
    AckSound(3)=SoundGroup'DH_voice_cz_Infantry.sorry'
    OrderSound(0)=SoundGroup'DH_voice_cz_Infantry.Attack'
    OrderSound(1)=SoundGroup'DH_voice_cz_Infantry.hold_this_position'
    OrderSound(2)=SoundGroup'DH_voice_cz_Infantry.hold_this_position'
    OrderSound(3)=SoundGroup'DH_voice_cz_Infantry.follow_me'
    OrderSound(4)=SoundGroup'DH_voice_cz_Infantry.Attack'
    OrderSound(5)=SoundGroup'DH_voice_cz_Infantry.retreat'
    OrderSound(6)=SoundGroup'DH_voice_cz_Infantry.Attack' //was fire at will
    OrderSound(7)=SoundGroup'DH_voice_cz_Infantry.cease_fire'

    RadioRequestSound=SoundGroup'DH_voice_cz_Infantry.csrusrequest'  //russian request with czech accent
    RadioResponseConfirmSound=SoundGroup'voice_sov_infantry.confirm' //russian response from soviet artillery units
    RadioResponseDenySound=SoundGroup'voice_sov_infantry.Deny'
}
