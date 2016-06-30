//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RUTankerPawn extends DHPawn;

static function xUtil.PlayerRecord GetModelRecord()
{
    local xUtil.PlayerRecord RecordToReturn;
    local int i;

    i = Rand(4);

    //class specific
    RecordToReturn.DefaultName = "RUTanker";
    RecordToReturn.Species = class'ROEngine.ROSPECIES_Human';
    RecordToReturn.MeshName = "DH_ROCharacters.DH_rus_tanker";
    RecordToReturn.BodySkinName = "Characters_tex.rus_uniforms.Russian_Tanker";
    RecordToReturn.FaceSkinName = "Characters_tex.rus_heads.rus_face"$default.RandomFaceArray[i];
    RecordToReturn.Portrait = material'Characters_tex.ger_heads.ger_face01';
    RecordToReturn.TextName = "ROPlayers.RkkaStandardSoldier";
    //RecordToReturn.VoiceClassName = "ROGame.RORussian1Voice";

    //Normal
    RecordToReturn.Sex = "Male";
    RecordToReturn.Menu = "ROSP";
    RecordToReturn.Tactics = "2.0";
    RecordToReturn.CombatStyle = "1";
    RecordToReturn.StrafingAbility = "-2.0";
    RecordToReturn.Accuracy = ".5";
    RecordToReturn.RagDoll = "German_tunic";
    RecordToReturn.BotUse = 1;
    RecordToReturn.Race = "Soviet";

    return RecordToReturn;
}

defaultproperties
{
    RandomFaceArray(0)="11"
    RandomFaceArray(1)="12"
    RandomFaceArray(2)="13"
    RandomFaceArray(3)="14"
    mesh=SkeletalMesh'DH_ROCharacters.DH_rus_tanker'
    Skins(0)=Texture'Characters_tex.rus_uniforms.Russian_Tanker'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face01'
}
