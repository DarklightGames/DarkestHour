//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_GEGreatCoatPawn extends DHPawn;

static function xUtil.PlayerRecord GetModelRecord()
{
    local xUtil.PlayerRecord RecordToReturn;
    local int i;

    i = Rand(4);

    //class specific
    RecordToReturn.DefaultName = "GEGreatCoat";
    RecordToReturn.Species = class'ROEngine.ROSPECIES_Human';
    RecordToReturn.MeshName = "DH_ROCharacters.DH_ger_greatcoat";
    RecordToReturn.BodySkinName = "Characters_tex.ger_uniforms.ger_greatcoat";
    RecordToReturn.FaceSkinName = "Characters_tex.ger_heads.ger_face"$default.RandomFaceArray[i];
    RecordToReturn.Portrait = material'Characters_tex.ger_heads.ger_face01';
    RecordToReturn.TextName = "ROPlayers.HeerStandardSoldier";
    //RecordToReturn.VoiceClassName = "DH_GerPlayers.DHGerVoice";

    //Normal
    RecordToReturn.Sex = "Male";
    RecordToReturn.Menu = "ROSP";
    RecordToReturn.Tactics = "2.0";
    RecordToReturn.CombatStyle = "1";
    RecordToReturn.StrafingAbility = "-2.0";
    RecordToReturn.Accuracy = ".5";
    RecordToReturn.RagDoll = "German_tunic";
    RecordToReturn.BotUse = 1;
    RecordToReturn.Race = "German";

    return RecordToReturn;
}

defaultproperties
{
    RandomFaceArray[0]="02"
    RandomFaceArray[1]="04"
    RandomFaceArray[2]="06"
    RandomFaceArray[3]="08"
    mesh=SkeletalMesh'DH_ROCharacters.DH_ger_greatcoat'
    Skins(0)=Texture'Characters_tex.ger_uniforms.ger_greatcoat'
}
