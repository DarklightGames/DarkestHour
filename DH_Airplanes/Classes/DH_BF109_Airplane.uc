//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BF109_Airplane extends DHAirplane;

defaultproperties
{
    AirplaneName="Messerschmidt Bf 109"
    CannonInfos(0)=(CannonClass=class'DHMG151Cannon')
    HardpointInfos(0)=(HardpointClass=class'DHAirplaneHardpoint',HardpointBone="bomb.002",LocationOffset=(X=0.0,y=0.0,Z=-5.0))
}
