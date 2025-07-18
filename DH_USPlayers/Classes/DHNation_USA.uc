//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHNation_USA extends DHNation;

defaultproperties
{
    NationName="United States of America"
    VoicePackClass=Class'DHUSVoice'
    
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.USA_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.USA_backpack'

    DefaultConstructionLoadoutClass=Class'DHConstructionLoadout_USA'

    DeployMenuFlagTexture=Material'DH_GUI_tex.flag_usa'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=0,X2=127,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Able"
    DefaultSquadNames(1)="Baker"
    DefaultSquadNames(2)="Charlie"
    DefaultSquadNames(3)="Dog"
    DefaultSquadNames(4)="Easy"
    DefaultSquadNames(5)="Fox"
    DefaultSquadNames(6)="Red Ball Express"
    DefaultSquadNames(7)="How"
    RoundStartSound= Sound'DH_SundrySounds.US_Start'
    SupplyTruckClass=Class'DH_GMCTruckSupport'
}
