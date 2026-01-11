//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHNation_Germany extends DHNation;

defaultproperties
{
    NationName="Germany"
    NativeNationName="Deutschland"
    VoicePackClass=Class'DHGerVoice'
    RallyPointClass=Class'DH_GerPlayers.DHSquadRallyPoint_German'
    DefaultConstructionLoadoutClass=Class'DHConstructionLoadout_Germany'
    DeployMenuFlagTexture=Material'DH_GUI_tex.flag_germany'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Anton"
    DefaultSquadNames(1)="Berta"
    DefaultSquadNames(2)="Caesar"
    DefaultSquadNames(3)="Dora"
    DefaultSquadNames(4)="Emil"
    DefaultSquadNames(5)="Fritz"
    DefaultSquadNames(6)="Gustav"
    DefaultSquadNames(7)="Heinrich"
    RoundStartSound=Sound'DH_SundrySounds.Axis_Start'
    SupplyTruckClass=Class'DH_OpelBlitzSupport'
    SquadSize=8
}
