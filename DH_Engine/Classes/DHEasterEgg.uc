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
                // Increase Eggs Found For Player
                PC.NumberOfEggsFound++;

                // Warn player we don't count eggs with less than 32 players
                if (G.GetNumPlayers() < 32)
                {
                    PC.ClientMessage("Eggs found with under 32 players do not count for event!", 'Say');
                }

                // Handle Metrics
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
    MaterialArray(11)=Material'DH_Event_tex.Easter_Egg_Paintings.Ciccseven_DrStrangelove'
    MaterialArray(12)=Material'DH_Event_tex.Easter_Egg_Paintings.Dan06_DogFace'
    MaterialArray(13)=Material'DH_Event_tex.Easter_Egg_Paintings.DirtyBirdy_BiteMe'
    MaterialArray(14)=Material'DH_Event_tex.Easter_Egg_Paintings.DirtyBirdy_Scooby1'
    MaterialArray(15)=Material'DH_Event_tex.Easter_Egg_Paintings.DirtyBirdy_Scooby2'
    MaterialArray(16)=Material'DH_Event_tex.Easter_Egg_Paintings.DLG_Logo'
    MaterialArray(17)=Material'DH_Event_tex.Easter_Egg_Paintings.Doc_Opossum_Possum'
    MaterialArray(18)=Material'DH_Event_tex.Easter_Egg_Paintings.Mazur_Bear'
    MaterialArray(19)=Material'DH_Event_tex.Easter_Egg_Paintings.Patison_GetThere'
    MaterialArray(20)=Material'DH_Event_tex.Easter_Egg_Paintings.Patison_Pinup'
    MaterialArray(21)=Material'DH_Event_tex.Easter_Egg_Paintings.Saulniv_Camo'
    MaterialArray(22)=Material'DH_Event_tex.Easter_Egg_Paintings.Saulniv_ConfusedSoldier'
    MaterialArray(23)=Material'DH_Event_tex.Easter_Egg_Paintings.Space_Cowboy_GooglyEyes'
    MaterialArray(24)=Material'DH_Event_tex.Easter_Egg_Paintings.Space_Cowboy_Rafterman'
    MaterialArray(25)=Material'DH_Event_tex.Easter_Egg_Paintings.Space_Cowboy_ScaredFace'
    MaterialArray(26)=Material'DH_Event_tex.Easter_Egg_Paintings.Space_Cowboy_ScareStance'
    MaterialArray(27)=Material'DH_Event_tex.Easter_Egg_Paintings.TonkaVD_Pinup'
    MaterialArray(28)=Material'DH_Event_tex.Easter_Egg_Paintings.WatermelonProtector_DogFace'
    MaterialArray(29)=Material'DH_Event_tex.Easter_Egg_Paintings.Zahnpastachaf_Bubbles'
    MaterialArray(30)=Material'DH_Event_tex.Easter_Egg_Paintings.Zodd_Noward_MP40'
}
