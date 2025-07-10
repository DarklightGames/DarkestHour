//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGerVoice extends DHVoicePack;

defaultproperties
{
    // Support sound groups
    SupportSound[0]=SoundGroup'voice_ger_infantry.need_help'
    SupportSound[1]=SoundGroup'voice_ger_infantry.need_help_at'
    SupportSound[2]=SoundGroup'voice_ger_infantry.need_ammo'
    SupportSound[3]=SoundGroup'voice_ger_infantry.need_sniper'
    SupportSound[4]=SoundGroup'voice_ger_infantry.need_MG'
    SupportSound[5]=SoundGroup'voice_ger_infantry.need_AT'
    SupportSound[6]=SoundGroup'voice_ger_infantry.need_demolitions'
    SupportSound[7]=SoundGroup'voice_ger_infantry.need_tank'
    SupportSound[8]=SoundGroup'voice_ger_infantry.need_artillery'
    SupportSound[9]=SoundGroup'voice_ger_infantry.need_transport'
    // Ack sound groups
    AckSound[0]=SoundGroup'voice_ger_infantry.yes'
    AckSound[1]=SoundGroup'voice_ger_infantry.no'
    AckSound[2]=SoundGroup'voice_ger_infantry.thanks'
    AckSound[3]=SoundGroup'voice_ger_infantry.sorry'
    // Enemy sound groups
    EnemySound[0]=SoundGroup'voice_ger_infantry.infantry'
    EnemySound[1]=SoundGroup'voice_ger_infantry.MG'
    EnemySound[2]=SoundGroup'voice_ger_infantry.sniper'
    EnemySound[3]=SoundGroup'voice_ger_infantry.pioneer'
    EnemySound[4]=SoundGroup'voice_ger_infantry.AT_soldier'
    EnemySound[5]=SoundGroup'voice_ger_infantry.Vehicle'
    EnemySound[6]=SoundGroup'voice_ger_infantry.tank'
    EnemySound[7]=SoundGroup'voice_ger_infantry.heavy_tank'
    EnemySound[8]=SoundGroup'voice_ger_infantry.artillery'
    // Alert sound groups
    AlertSound[0]=SoundGroup'voice_ger_infantry.Grenade'
    AlertSound[1]=SoundGroup'voice_ger_infantry.gogogo'
    AlertSound[2]=SoundGroup'voice_ger_infantry.take_cover'
    AlertSound[3]=SoundGroup'voice_ger_infantry.Stop'
    AlertSound[4]=SoundGroup'voice_ger_infantry.follow_me'
    AlertSound[5]=SoundGroup'voice_ger_infantry.satchel_planted'
    AlertSound[6]=SoundGroup'voice_ger_infantry.covering_fire'
    AlertSound[7]=SoundGroup'voice_ger_infantry.friendly_fire'
    AlertSound[8]=SoundGroup'voice_ger_infantry.under_attack_at'
    AlertSound[9]=SoundGroup'voice_ger_infantry.retreat'
    // Vehicle direction sound groups
    vehicleDirectionSound[0]=SoundGroup'voice_ger_vehicle.go_to_objective'
    vehicleDirectionSound[1]=SoundGroup'voice_ger_vehicle.forwards'
    vehicleDirectionSound[2]=SoundGroup'voice_ger_vehicle.Stop'
    vehicleDirectionSound[3]=SoundGroup'voice_ger_vehicle.Reverse'
    vehicleDirectionSound[4]=SoundGroup'voice_ger_vehicle.Left'
    vehicleDirectionSound[5]=SoundGroup'voice_ger_vehicle.Right'
    vehicleDirectionSound[6]=SoundGroup'voice_ger_vehicle.nudge_forward'
    vehicleDirectionSound[7]=SoundGroup'voice_ger_vehicle.nudge_back'
    vehicleDirectionSound[8]=SoundGroup'voice_ger_vehicle.nudge_left'
    vehicleDirectionSound[9]=SoundGroup'voice_ger_vehicle.nudge_right'
    // Vehicle alert sound groups
    vehicleAlertSound[0]=SoundGroup'voice_ger_vehicle.enemy_forward'
    vehicleAlertSound[1]=SoundGroup'voice_ger_vehicle.enemy_left'
    vehicleAlertSound[2]=SoundGroup'voice_ger_vehicle.enemy_right'
    vehicleAlertSound[3]=SoundGroup'voice_ger_vehicle.enemy_behind'
    vehicleAlertSound[4]=SoundGroup'voice_ger_vehicle.enemy_infantry'
    vehicleAlertSound[5]=SoundGroup'voice_ger_vehicle.yes'
    vehicleAlertSound[6]=SoundGroup'voice_ger_vehicle.no'
    vehicleAlertSound[7]=SoundGroup'voice_ger_vehicle.we_are_burning'
    vehicleAlertSound[8]=SoundGroup'voice_ger_vehicle.get_out'
    vehicleAlertSound[9]=SoundGroup'voice_ger_vehicle.Loaded'
    // Commander sound groups
    OrderSound[0]=SoundGroup'voice_ger_infantry.attack_objective'
    OrderSound[1]=SoundGroup'voice_ger_infantry.defend_objective'
    OrderSound[2]=SoundGroup'voice_ger_infantry.hold_this_position'
    OrderSound[3]=SoundGroup'voice_ger_infantry.follow_me'
    OrderSound[4]=SoundGroup'voice_ger_infantry.Attack'
    OrderSound[5]=SoundGroup'voice_ger_infantry.retreat'
    OrderSound[6]=SoundGroup'voice_ger_infantry.fire_at_will'
    OrderSound[7]=SoundGroup'voice_ger_infantry.cease_fire'
    // Extras sound groups
    ExtraSound[0]=SoundGroup'voice_ger_infantry.i_will_kill_you'
    ExtraSound[1]=SoundGroup'voice_ger_infantry.no_retreat'
    ExtraSound[2]=SoundGroup'DH_Ger_Voice_Infantry.insult'
    bUseAxisStrings=true
    SupportStringAxis(5)="We need a Panzerschreck!"
    SupportAbbrevAxis(5)="Need a Panzerschreck"

    RadioRequestSound=SoundGroup'Artillery.GerRequest'
    RadioResponseConfirmSound=SoundGroup'voice_ger_infantry.confirm'
    RadioResponseDenySound=SoundGroup'voice_ger_infantry.Deny'
}
