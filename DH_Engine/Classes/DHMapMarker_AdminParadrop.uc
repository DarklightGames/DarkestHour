//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_AdminParadrop extends DHMapMarker
    abstract;

defaultproperties
{
    MarkerName="ADMIN: Place paradrop mark"
    IconMaterial=Texture'DH_InterfaceArt2_tex.paratroopers'
    IconColor=(R=0,G=204,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=false
    Type=MT_Admin
    OverwritingRule=UNIQUE
    Scope=PERSONAL
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ADMIN)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=ERS_ADMIN)
    Permissions_CanPlace(0)=ERS_ADMIN
}
