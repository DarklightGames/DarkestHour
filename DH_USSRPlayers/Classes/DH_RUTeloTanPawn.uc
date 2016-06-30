//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RUTeloTanPawn extends DHPawn;

static function xUtil.PlayerRecord GetModelRecord()
{
    local xUtil.PlayerRecord RecordToReturn;
    local int i, t;

    i = Rand(4);
    t = Rand(2) + 1;

    //class specific
    RecordToReturn.DefaultName = "RUTelogreikaTan";
    RecordToReturn.Species = class'ROEngine.ROSPECIES_Human';
    RecordToReturn.MeshName = "DH_ROCharacters.DH_rus_rifleman_tunic";
    RecordToReturn.BodySkinName = "DH_ROUniformTex.RussianTunics.DH_rus_telogreika_tan0"$t;
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
    RandomFaceArray(0)="05"
    RandomFaceArray(1)="07"
    RandomFaceArray(2)="09"
    RandomFaceArray(3)="13"
    mesh=SkeletalMesh'DH_ROCharacters.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DH_ROUniformTex.RussianTunics.DH_rus_telogreika_tan01'
    Skins(1)=texture'Characters_tex.rus_heads.rus_face01'
}
