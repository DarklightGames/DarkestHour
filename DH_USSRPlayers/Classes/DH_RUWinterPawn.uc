//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RUWinterPawn extends DHPawn;

static function xUtil.PlayerRecord GetModelRecord()
{
    local xUtil.PlayerRecord RecordToReturn;
    local int i;

    i = Rand(4);

    //class specific
    RecordToReturn.DefaultName = "RUWinter";
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
    RandomFaceArray(0)="06"
    RandomFaceArray(1)="07"
    RandomFaceArray(2)="08"
    RandomFaceArray(3)="09"
    mesh=SkeletalMesh'DH_ROCharacters.DH_rus_snowcamo'
    Skins(0)=Texture'Characters_tex.rus_uniforms.rus_snowcamo'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face01'
}
