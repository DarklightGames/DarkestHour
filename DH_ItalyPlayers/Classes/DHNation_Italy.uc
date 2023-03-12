//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHNation_Italy extends DHNation;

defaultproperties
{
    NationName="Kingdom of Italy"
    NativeNationName="Regno d'Italia"
    VoicePackClass=class'DH_ItalyPlayers.DHItalyVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.GER_flag_01'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_light_destro'

    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=64,X2=31,Y2=95),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))

    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_italy'
    
    // https://web.archive.org/web/20200620154809im_/http://www.milistory.net/Public/data/ciofatax/2007724164255_DSCN0158.JPG
    DefaultSquadNames(0)="Ancona"
    DefaultSquadNames(1)="Bari"
    DefaultSquadNames(2)="Como"
    DefaultSquadNames(3)="Derna"
    DefaultSquadNames(4)="Empoli"
    DefaultSquadNames(5)="Firenze"
    DefaultSquadNames(6)="Genova"
    DefaultSquadNames(7)="Acca"
}
