//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSPECIES_Human extends ROSPECIES_Human
    abstract;

// Modified to avoid "accessed none" errors
static function bool Setup(Pawn P, xUtil.PlayerRecord Rec)
{
    local ROPawn                ROP;
    local PlayerReplicationInfo PRI;
    local mesh                  NewMesh;
    local class<VoicePack>      VoiceClass;

    ROP = ROPawn(P);

    if (ROP == none)
    {
        Log("DHSPECIES_Human.Setup() error: no ROPawn");

        return false;
    }

    if (Rec.MeshName != "")
    {
        NewMesh = Mesh(DynamicLoadObject(Rec.MeshName, class'Mesh'));
    }

    if (NewMesh == none)
    {
        return false;
    }

    PRI = ROP.PlayerReplicationInfo;

    ROP.LinkMesh(NewMesh);
    ROP.AssignInitialPose();
    ROP.bIsFemale = false;

    if (PRI != none)
    {
        PRI.bIsFemale = false;
    }

    ROP.SoundGroupClass = class<ROPawnSoundGroup>(DynamicLoadObject(default.MaleSoundGroup, class'Class'));

    if (Rec.BodySkinName != "")
    {
        ROP.Skins[0] = material(DynamicLoadObject(Rec.BodySkinName, class'Material'));
    }

    if (Rec.FaceSkinName != "")
    {
        ROP.Skins[1] = material(DynamicLoadObject(Rec.FaceSkinName, class'Material'));
    }

    if (ROPlayerReplicationInfo(PRI) != none && ROPlayerReplicationInfo(PRI).RoleInfo != none)
    {
        ROP.VoiceType = ROPlayerReplicationInfo(PRI).RoleInfo.default.VoiceType;
        VoiceClass = class<VoicePack>(DynamicLoadObject(ROP.VoiceType, class'Class'));
        PRI.VoiceType = VoiceClass;
        ROP.VoiceClass = class<TeamVoicePack>(VoiceClass);
    }

    return true;
}

defaultproperties
{
}
