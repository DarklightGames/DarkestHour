//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHNation_USSR extends DHNation;

defaultproperties
{
    NationName="Union of Soviet Socialist Republics"
    VoicePackClass=Class'DHSovietVoice'
    DefaultConstructionLoadoutClass=Class'DHConstructionLoadout_USSR'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.RUS_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.RUS_backpack'
    DeployMenuFlagTexture=Material'DH_GUI_tex.flag_ussr'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=32,X2=63,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Almaz"
    DefaultSquadNames(1)="Berezka"
    DefaultSquadNames(2)="Vostok"
    DefaultSquadNames(3)="Grach"
    DefaultSquadNames(4)="Dub"
    DefaultSquadNames(5)="Yenisey"
    DefaultSquadNames(6)="Zvezda"
    DefaultSquadNames(7)="Iskra"
    RoundStartSound=Sound'DH_SundrySounds.Soviet_Start'
    SupplyTruckClass=Class'DH_GMCTruckSupport'
}
