//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHEasterEgg extends DHDestroyableSM;

var Shader          SkinRef;
var TexEnvMap       SkinEnvMap;
var Texture         SkinSpecMask;
var array<Material> MaterialArray;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SkinRef = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
    SkinRef.Diffuse = MaterialArray[Rand(MaterialArray.Length)];
    SkinRef.Specular = SkinEnvMap;
    SkinRef.SpecularityMask = SkinSpecMask;

    Skins[0] = SkinRef;
}

auto state Working
{
    // Allows vehicles to run over eggs (Player Pawns do not work!)
    event Touch(Actor Other)
    {
        if (Vehicle(Other) != none)
        {
            TakeDamage(default.Health, Vehicle(Other), Location, Vect(0,0,0), class'Crushed');
        }
    }


    function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        local DarkestHourGame G;
        local DHMetricsEvent E;
        local DHPlayer PC;

        if (!bActive)
        {
            return;
        }

        if (TeamCanDamage == TD_Axis && GetDamagingTeamIndex(InstigatedBy) != AXIS_TEAM_INDEX)
        {
            return;
        }

        if (TeamCanDamage == TD_Allies && GetDamagingTeamIndex(InstigatedBy) != ALLIES_TEAM_INDEX)
        {
            return;
        }

        if (!ShouldTakeDamage(DamageType))
        {
            return;
        }

        if (InstigatedBy != none)
        {
            MakeNoise(1.0);
        }

        Health -= Damage;

        if (Health <= 0)
        {
            TriggerEvent(DestroyedEvent, self, InstigatedBy);
            BroadcastCriticalMessage(InstigatedBy);
            BreakApart(HitLocation, Momentum);

            PC = DHPlayer(InstigatedBy.Controller);
            G = DarkestHourGame(Level.Game);

            if (PC != none && G != none && G.Metrics != none)
            {
                E = new class'DHMetricsEvent';
                E.Type = "egg_found";
                E.Data = (new class'JSONObject')
                    .PutString("player_id", PC.GetPlayerIDHash())
                    .PutString("damage_type", DamageType.Name);
                G.Metrics.AddEvent(E);
            }
        }
    }
}

state Broken
{
    function BeginState()
    {
        super.BeginState();
    }
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Event_stc.Easter.Easter_Egg'
    DestroyedEffect=class'DH_Effects.DHChickenExplosion'
    TypesCanDamage(0)=class'Engine.DamageType' // All Damage Types
    DrawScale=0.3333
    Health=10
    bUseDamagedMesh=false
    bNoDelete=false

    bPathColliding=false
    bWorldGeometry=false

    SkinEnvMap=TexEnvMap'DH_Cubemaps.Beach1.Beach1_Envmap'
    SkinSpecMask=Texture'DHEngine_Tex.Transparency.Trans_80';

    MaterialArray(0)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Loser'
    MaterialArray(1)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Theel_Dye1'
    MaterialArray(2)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_American_Flag'
    MaterialArray(3)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Soviet_Flag'
    MaterialArray(4)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_British_Flag'
    MaterialArray(5)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Canadian_Flag'
    MaterialArray(6)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_German_Flag'
    MaterialArray(7)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Churchill'
    MaterialArray(8)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_FDR'
    MaterialArray(9)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Hitler'
    MaterialArray(10)=Material'DH_Event_tex.Easter_Egg_Paintings.Egg_Stalin'
}
