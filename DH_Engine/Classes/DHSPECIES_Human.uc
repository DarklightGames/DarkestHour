//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSPECIES_Human extends ROSPECIES_Human
    abstract;

// Modified to avoid "accessed none" errors and allow for Pawn setup system instead of Record
static function bool Setup(Pawn P, xUtil.PlayerRecord Rec)
{
    local ROPawn                    ROP;
    local ROPlayerReplicationInfo   PRI;
    local mesh                      NewMesh;
    local class<VoicePack>          VoiceClass;

    ROP = ROPawn(P);

    if (ROP == none)
    {
        Warn("DHSPECIES_Human.Setup() error: no ROPawn");

        return false;
    }

    ROP.SoundGroupClass = class<ROPawnSoundGroup>(DynamicLoadObject(default.MaleSoundGroup, class'Class'));

    // Check if the record has a mesh, otherwise we need to setup from Pawn
    if (Rec.MeshName != "")
    {
        NewMesh = Mesh(DynamicLoadObject(Rec.MeshName, class'Mesh'));

        if (NewMesh != none)
        {
            ROP.LinkMesh(NewMesh);
            ROP.AssignInitialPose();
        }
    }

    if (Rec.BodySkinName != "")
    {
        ROP.Skins[0] = material(DynamicLoadObject(Rec.BodySkinName, class'Material'));
    }

    if (Rec.FaceSkinName != "")
    {
        ROP.Skins[1] = material(DynamicLoadObject(Rec.FaceSkinName, class'Material'));
    }

    PRI = ROPlayerReplicationInfo(P.PlayerReplicationInfo);

    if (PRI != none && PRI.RoleInfo != none)
    {
        ROP.VoiceType = PRI.RoleInfo.default.VoiceType;
        VoiceClass = class<VoicePack>(DynamicLoadObject(ROP.VoiceType, class'Class'));
        PRI.VoiceType = VoiceClass;
        ROP.VoiceClass = class<TeamVoicePack>(VoiceClass);
    }

    return true;
}

defaultproperties
{
    PawnClassName="DH_Engine.DHPawn"
}
