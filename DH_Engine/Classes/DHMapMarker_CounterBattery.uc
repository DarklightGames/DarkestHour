//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_CounterBattery extends DHMapMarker
    abstract;

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    IconMaterial=MaterialSequence'DH_InterfaceArt2_tex.HitMarker'
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=6
    Type=MT_CounterBattery
    OverwritingRule=OFF
    Scope=PERSONAL
    LifetimeSeconds=3
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanPlace(0)=ERS_ALL
}
