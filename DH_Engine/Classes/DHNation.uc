//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation extends Object
    abstract;

// Name
var localized string            NationName;
var localized string            NativeNationName;

var Texture                     FlagIconTexture;        // The icon used for the nation on the map.
var Texture                     TeamSelectTexture;      // TODO: set this up on the team select page!

var class<DHVoicePack>          VoicePackClass;

// Platoon HQ
var StaticMesh                  PlatoonHQConstructedStaticMesh;
var StaticMesh                  PlatoonHQBrokenStaticMesh;
var StaticMesh                  PlatoonHQUnpackedStaticMesh;
var StaticMesh                  PlatoonHQTatteredStaticMesh;
var Texture                     PlatoonHQFlagTexture;

// Supply Cache
var StaticMesh                  SupplyCacheStaticMesh;

// Rally Point
var StaticMesh                  RallyPointStaticMesh;
var StaticMesh                  RallyPointStaticMeshActive;

// Resupply Point
var StaticMesh                  InfantryResupplyStaticMesh;

// Flags
var Material                    DeployMenuFlagTexture;
var HudBase.SpriteWidget        MapFlagIconSpriteWidget;

var class<DHInventorySpawner>   GrenadeCrateClass;

// Squads
var string                      DefaultSquadNames[8];

var Sound                       RoundStartSound;

var class<DHHealthFigure>       HealthFigureClass;

defaultproperties
{
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.flags_01_blank'
}
