//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHRomRoles extends DHRoleInfo
    abstract;

defaultproperties
{
    Texture=Texture'DH_InterfaceArt_tex.deathicons.Andy' //something neutral since they can be either axis and allies
    VoiceType="DH_RomPlayers.DHRomaniaVoice"
    AltVoiceType="DH_RomPlayers.DHRomaniaVoice"
    DetachedArmClass=Class'DHSeveredArm_Rom'
    DetachedLegClass=Class'DHSeveredLeg_Rom

    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves' //?
}
