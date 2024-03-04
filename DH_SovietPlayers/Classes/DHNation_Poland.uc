//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_Poland extends DHNation;

defaultproperties
{
    NationName="Polish People's Army"
    NativeNationName="Ludowe Wojsko Polskie"
    VoicePackClass=class'DH_SovietPlayers.DHPolishVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.POL_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.POL_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box'
    PlatoonHQClass=class'DHConstruction_PlatoonHQ_Poland'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_poland'
    GrenadeCrateClass=class'DH_Weapons.DH_F1GrenadeSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=32,X2=95,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Adam"
    DefaultSquadNames(1)="Barbara"
    DefaultSquadNames(2)="Celina"
    DefaultSquadNames(3)="Dorota"
    DefaultSquadNames(4)="Ewa"
    DefaultSquadNames(5)="Franciszek"
    DefaultSquadNames(6)="Genowefa"
    DefaultSquadNames(7)="Henryk"
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.Soviet_Start'
    SupplyTruckClass=class'DH_Vehicles.DH_GMCTruckSupport'
}
