//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHItalyVoice extends DHVoicePack;

static function class<DHVoicePack> GetVoicePackClass(class<DHNation> EnemyNationClass)
{
    if (EnemyNationClass.Name == 'DHNation_USSR')
    {
        return Class'DHItalyVoice_RUS';
    }
    else if (EnemyNationClass.Name == 'DHNation_USA')
    {
        return Class'DHItalyVoice_US';
    }

    return default.Class;
}

defaultproperties
{
    // Support sound groups
    SupportSound(0)=SoundGroup'DH_voice_ita_infantry.requests.need_help'
    SupportSound(1)=SoundGroup'DH_voice_ita_infantry.requests.need_help_at'
    SupportSound(2)=SoundGroup'DH_voice_ita_infantry.requests.need_ammo'
    SupportSound(3)=SoundGroup'DH_voice_ita_infantry.requests.need_sniper'
    SupportSound(4)=SoundGroup'DH_voice_ita_infantry.requests.need_MG'
    SupportSound(5)=SoundGroup'DH_voice_ita_infantry.requests.need_AT'
    SupportSound(6)=SoundGroup'DH_voice_ita_infantry.requests.need_demolitions'
    SupportSound(7)=SoundGroup'DH_voice_ita_infantry.requests.need_tank'
    SupportSound(8)=SoundGroup'DH_voice_ita_infantry.requests.need_artillery'
    SupportSound(9)=SoundGroup'DH_voice_ita_infantry.requests.need_transport'
    // Ack sound groups
    AckSound(0)=SoundGroup'DH_voice_ita_infantry.responses.yes'
    AckSound(1)=SoundGroup'DH_voice_ita_infantry.responses.no'
    AckSound(2)=SoundGroup'DH_voice_ita_infantry.responses.thanks'
    AckSound(3)=SoundGroup'DH_voice_ita_infantry.responses.sorry'
    // Enemy sound groups
    EnemySound(0)=SoundGroup'DH_voice_ita_infantry.spotted.infantry'
    EnemySound(1)=SoundGroup'DH_voice_ita_infantry.spotted.MG'
    EnemySound(2)=SoundGroup'DH_voice_ita_infantry.spotted.sniper'
    EnemySound(3)=SoundGroup'DH_voice_ita_infantry.spotted.pioneer'
    EnemySound(4)=SoundGroup'DH_voice_ita_infantry.spotted.AT_soldier'
    EnemySound(5)=SoundGroup'DH_voice_ita_infantry.spotted.Vehicle'
    EnemySound(6)=SoundGroup'DH_voice_ita_infantry.spotted.tank'
    EnemySound(7)=SoundGroup'DH_voice_ita_infantry.spotted.heavy_tank'
    EnemySound(8)=SoundGroup'DH_voice_ita_infantry.spotted.artillery'
    // Alert sound groups
    AlertSound(0)=SoundGroup'DH_voice_ita_infantry.alerts.Grenade'
    AlertSound(1)=SoundGroup'DH_voice_ita_infantry.alerts.gogogo'
    AlertSound(2)=SoundGroup'DH_voice_ita_infantry.alerts.take_cover'
    AlertSound(3)=SoundGroup'DH_voice_ita_infantry.alerts.Stop'
    AlertSound(4)=SoundGroup'DH_voice_ita_infantry.commander.follow_me'
    AlertSound(5)=SoundGroup'DH_voice_ita_infantry.alerts.satchel_planted'
    AlertSound(6)=SoundGroup'DH_voice_ita_infantry.alerts.covering_fire'
    AlertSound(7)=SoundGroup'DH_voice_ita_infantry.alerts.friendly_fire'
    AlertSound(8)=SoundGroup'DH_voice_ita_infantry.alerts.under_attack_at'
    AlertSound(9)=SoundGroup'DH_voice_ita_infantry.commander.retreat'
    // Vehicle direction sound groups
    vehicleDirectionSound(0)=SoundGroup'DH_voice_ita_vehicle.directions.go_to_objective'
    vehicleDirectionSound(1)=SoundGroup'DH_voice_ita_vehicle.directions.forwards'
    vehicleDirectionSound(2)=SoundGroup'DH_voice_ita_vehicle.directions.Stop'
    vehicleDirectionSound(3)=SoundGroup'DH_voice_ita_vehicle.directions.Reverse'
    vehicleDirectionSound(4)=SoundGroup'DH_voice_ita_vehicle.directions.Left'
    vehicleDirectionSound(5)=SoundGroup'DH_voice_ita_vehicle.directions.Right'
    vehicleDirectionSound(6)=SoundGroup'DH_voice_ita_vehicle.directions.nudge_forward'
    vehicleDirectionSound(7)=SoundGroup'DH_voice_ita_vehicle.directions.nudge_back'
    vehicleDirectionSound(8)=SoundGroup'DH_voice_ita_vehicle.directions.nudge_left'
    vehicleDirectionSound(9)=SoundGroup'DH_voice_ita_vehicle.directions.nudge_right'
    // Vehicle alert sound groups
    vehicleAlertSound(0)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_forward'
    vehicleAlertSound(1)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_left'
    vehicleAlertSound(2)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_right'
    vehicleAlertSound(3)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_behind'
    vehicleAlertSound(4)=SoundGroup'DH_voice_ita_vehicle.alerts.enemy_infantry'
    vehicleAlertSound(5)=SoundGroup'DH_voice_ita_vehicle.alerts.yes'
    vehicleAlertSound(6)=SoundGroup'DH_voice_ita_vehicle.alerts.no'
    vehicleAlertSound(7)=SoundGroup'DH_voice_ita_vehicle.alerts.we_are_burning'
    vehicleAlertSound(8)=SoundGroup'DH_voice_ita_vehicle.alerts.get_out'
    vehicleAlertSound(9)=SoundGroup'DH_voice_ita_vehicle.alerts.Loaded'
    // Commander sound groups
    OrderSound(0)=SoundGroup'DH_voice_ita_infantry.commander.attack_objective'
    OrderSound(1)=SoundGroup'DH_voice_ita_infantry.commander.defend_objective'
    OrderSound(2)=SoundGroup'DH_voice_ita_infantry.commander.hold_position'
    OrderSound(3)=SoundGroup'DH_voice_ita_infantry.commander.follow_me'
    OrderSound(4)=SoundGroup'DH_voice_ita_infantry.commander.Attack'
    OrderSound(5)=SoundGroup'DH_voice_ita_infantry.commander.retreat'
    OrderSound(6)=SoundGroup'DH_voice_ita_infantry.commander.fire_at_will'
    OrderSound(7)=SoundGroup'DH_voice_ita_infantry.commander.cease_fire'
    // Extras sound groups
    ExtraSound(0)=SoundGroup'DH_voice_ita_infantry.insults.i_will_kill_you'
    ExtraSound(1)=SoundGroup'DH_voice_ita_infantry.insults.no_retreat'
    ExtraSound(2)=SoundGroup'DH_voice_ita_infantry.insults.insult'
    bUseAxisStrings=true
    SupportStringAxis(5)="We need an anti-tank rifle!"
    SupportAbbrevAxis(5)="Need an Anti-Tank Rifle"

    RadioRequestSound=SoundGroup'DH_voice_ita_artillery.artillery.request'
    RadioResponseConfirmSound=SoundGroup'DH_voice_ita_artillery.artillery.confirm'
    RadioResponseDenySound=SoundGroup'DH_voice_ita_artillery.artillery.deny'
}
