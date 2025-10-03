//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSVoice extends DHVoicePack;

static function class<DHVoicePack> GetVoicePackClass(class<DHNation> EnemyNationClass)
{
    if (EnemyNationClass.Name == 'DHNation_Germany')
    {
        return Class'DHUSVoice_GER';
    }
    else if (EnemyNationClass.Name == 'DHNation_Italy')
    {
        return Class'DHUSVoice_ITA';
    }

    return default.Class;
}

defaultproperties
{
    SupportSound(0)=SoundGroup'DH_US_Voice_Infantry.need_help'
    SupportSound(1)=SoundGroup'DH_US_Voice_Infantry.need_help_at'
    SupportSound(2)=SoundGroup'DH_US_Voice_Infantry.need_ammo'
    SupportSound(3)=SoundGroup'DH_US_Voice_Infantry.need_sniper'
    SupportSound(4)=SoundGroup'DH_US_Voice_Infantry.need_MG'
    SupportSound(5)=SoundGroup'DH_US_Voice_Infantry.need_AT'
    SupportSound(6)=SoundGroup'DH_US_Voice_Infantry.need_demolitions'
    SupportSound(7)=SoundGroup'DH_US_Voice_Infantry.need_tank'
    SupportSound(8)=SoundGroup'DH_US_Voice_Infantry.need_artillery'
    SupportSound(9)=SoundGroup'DH_US_Voice_Infantry.need_transport'
    SupportString(5)="We need a Bazooka!"
    SupportAbbrev(5)="Need a Bazooka"
    EnemySound(0)=SoundGroup'DH_US_Voice_Infantry.infantry'
    EnemySound(1)=SoundGroup'DH_US_Voice_Infantry.MG'
    EnemySound(2)=SoundGroup'DH_US_Voice_Infantry.sniper'
    EnemySound(3)=SoundGroup'DH_US_Voice_Infantry.pioneer'
    EnemySound(4)=SoundGroup'DH_US_Voice_Infantry.AT_soldier'
    EnemySound(5)=SoundGroup'DH_US_Voice_Infantry.Vehicle'
    EnemySound(6)=SoundGroup'DH_US_Voice_Infantry.tank'
    EnemySound(7)=SoundGroup'DH_US_Voice_Infantry.heavy_tank'
    EnemySound(8)=SoundGroup'DH_US_Voice_Infantry.Artillery'
    AlertSound(0)=SoundGroup'DH_US_Voice_Infantry.Grenade'
    AlertSound(1)=SoundGroup'DH_US_Voice_Infantry.gogogo'
    AlertSound(2)=SoundGroup'DH_US_Voice_Infantry.take_cover'
    AlertSound(3)=SoundGroup'DH_US_Voice_Infantry.Stop'
    AlertSound(4)=SoundGroup'DH_US_Voice_Infantry.follow_me'
    AlertSound(5)=SoundGroup'DH_US_Voice_Infantry.satchel_planted'
    AlertSound(6)=SoundGroup'DH_US_Voice_Infantry.covering_fire'
    AlertSound(7)=SoundGroup'DH_US_Voice_Infantry.friendly_fire'
    AlertSound(8)=SoundGroup'DH_US_Voice_Infantry.under_attack_at'
    AlertSound(9)=SoundGroup'DH_US_Voice_Infantry.retreat'
    VehicleDirectionSound(0)=SoundGroup'DH_US_Voice_vehicle.go_to_objective'
    VehicleDirectionSound(1)=SoundGroup'DH_US_Voice_vehicle.forwards'
    VehicleDirectionSound(2)=SoundGroup'DH_US_Voice_vehicle.Stop'
    VehicleDirectionSound(3)=SoundGroup'DH_US_Voice_vehicle.Reverse'
    VehicleDirectionSound(4)=SoundGroup'DH_US_Voice_vehicle.Left'
    VehicleDirectionSound(5)=SoundGroup'DH_US_Voice_vehicle.Right'
    VehicleDirectionSound(6)=SoundGroup'DH_US_Voice_vehicle.nudge_forward'
    VehicleDirectionSound(7)=SoundGroup'DH_US_Voice_vehicle.nudge_back'
    VehicleDirectionSound(8)=SoundGroup'DH_US_Voice_vehicle.nudge_left'
    VehicleDirectionSound(9)=SoundGroup'DH_US_Voice_vehicle.nudge_right'
    VehicleAlertSound(0)=SoundGroup'DH_US_Voice_vehicle.enemy_forward'
    VehicleAlertSound(1)=SoundGroup'DH_US_Voice_vehicle.enemy_left'
    VehicleAlertSound(2)=SoundGroup'DH_US_Voice_vehicle.enemy_right'
    VehicleAlertSound(3)=SoundGroup'DH_US_Voice_vehicle.enemy_behind'
    VehicleAlertSound(4)=SoundGroup'DH_US_Voice_vehicle.enemy_infantry'
    VehicleAlertSound(5)=SoundGroup'DH_US_Voice_vehicle.yes'
    VehicleAlertSound(6)=SoundGroup'DH_US_Voice_vehicle.no'
    VehicleAlertSound(7)=SoundGroup'DH_US_Voice_vehicle.we_are_burning'
    VehicleAlertSound(8)=SoundGroup'DH_US_Voice_vehicle.get_out'
    VehicleAlertSound(9)=SoundGroup'DH_US_Voice_vehicle.Loaded'
    ExtraSound(0)=SoundGroup'DH_US_Voice_Infantry.i_will_kill_you'
    ExtraSound(1)=SoundGroup'DH_US_Voice_Infantry.no_retreat'
    ExtraSound(2)=SoundGroup'DH_US_Voice_Infantry.insult'
    AckSound(0)=SoundGroup'DH_US_Voice_Infantry.yes'
    AckSound(1)=SoundGroup'DH_US_Voice_Infantry.no'
    AckSound(2)=SoundGroup'DH_US_Voice_Infantry.thanks'
    AckSound(3)=SoundGroup'DH_US_Voice_Infantry.sorry'
    OrderSound(0)=SoundGroup'DH_US_Voice_Infantry.attack_objective'
    OrderSound(1)=SoundGroup'DH_US_Voice_Infantry.defend_objective'
    OrderSound(2)=SoundGroup'DH_US_Voice_Infantry.hold_this_position'
    OrderSound(3)=SoundGroup'DH_US_Voice_Infantry.follow_me'
    OrderSound(4)=SoundGroup'DH_US_Voice_Infantry.Attack'
    OrderSound(5)=SoundGroup'DH_US_Voice_Infantry.retreat'
    OrderSound(6)=SoundGroup'DH_US_Voice_Infantry.fire_at_will'
    OrderSound(7)=SoundGroup'DH_US_Voice_Infantry.cease_fire'
    RadioRequestSound=SoundGroup'DH_ArtillerySounds.USrequest'
    RadioResponseConfirmSound=SoundGroup'DH_US_Voice_Infantry.confirm'
    RadioResponseDenySound=SoundGroup'DH_US_Voice_Infantry.Deny'
}
