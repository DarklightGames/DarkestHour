//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHNation_Czechoslovakia extends DHNation;

defaultproperties
{
    NationName="Czechoslovakia"
    VoicePackClass=Class'DHCzechVoice'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.CS_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.CS_backpack'
    DefaultConstructionLoadoutClass=Class'DHConstructionLoadout_USSR'
    DeployMenuFlagTexture=Material'DH_GUI_tex.flag_czechoslovakia'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=32,X2=127,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Adam"
    DefaultSquadNames(1)="Bozena"
    DefaultSquadNames(2)="Cyril"
    DefaultSquadNames(3)="David"
    DefaultSquadNames(4)="Emil"
    DefaultSquadNames(5)="Frantisek"
    DefaultSquadNames(6)="Gustav"
    DefaultSquadNames(7)="Helena"
    RoundStartSound= Sound'DH_SundrySounds.Soviet_Start'
    SupplyTruckClass=Class'DH_GMCTruckSupport'
}
