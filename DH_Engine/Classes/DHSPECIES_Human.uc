//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSPECIES_Human extends ROSPECIES_Human
    abstract;

// Modified to fix bug where VoiceType & VoiceClass were sometimes not set up on net client (if player is in vehicle when he spawns so DHPawn has no PRI)
// Also to avoid "accessed none" errors when don't have a PlayerRecord (handling new DH system of player models defined in DHPawn classes instead of PlayerRecords)
// (Matt) TODO: strip out deprecated PlayerRecord stuff (everywhere) & consolidate this, DHPawn.Setup() & LoadResources() into new DHPawn setup function
// Without PlayerRecords virtually all that's left is voice stuff that doesn't vary, certainly not within same nation, & it's in the pawn classes or can be
static function bool Setup(Pawn P, xUtil.PlayerRecord Rec)
{
    local ROPawn                  ROP;
    local ROPlayerReplicationInfo PRI;
    local Mesh                    NewMesh;
    local Class<VoicePack>        VoiceClass;
    local Class<DHVoicePack>      DHVC;
    local DH_LevelInfo            LI;
    local int                     EnemyTeamIndex;

    ROP = ROPawn(P);

    if (ROP == none)
    {
        Warn("DHSPECIES_Human.Setup() error: no ROPawn");

        return false;
    }

    // Legacy model setup from PlayerRecord - in DH an empty PlayerRecord will now be passed, so the DHPawn class handles the model setup
    if (Rec.MeshName != "")
    {
        NewMesh = Mesh(DynamicLoadObject(Rec.MeshName, Class'Mesh'));

        if (NewMesh != none)
        {
            ROP.LinkMesh(NewMesh);
            ROP.AssignInitialPose();
        }
    }

    if (Rec.BodySkinName != "")
    {
        ROP.Skins[0] = Material(DynamicLoadObject(Rec.BodySkinName, Class'Material'));
    }

    if (Rec.FaceSkinName != "")
    {
        ROP.Skins[1] = Material(DynamicLoadObject(Rec.FaceSkinName, Class'Material'));
    }

    // Fix to get PRI if player is in a vehicle when his DHPawn spawns on a net client (the vehicle, not the DHPawn, now holds the PRI reference)
    // Get PRI - but DHPawn may have been replicated to us with player in a vehicle, in which case we need to get the PRI from our controlled DrivenVehicle actor
    if (P.DrivenVehicle != none && P.DrivenVehicle.PlayerReplicationInfo != none)
    {
        PRI = ROPlayerReplicationInfo(P.DrivenVehicle.PlayerReplicationInfo);
    }
    else
    {
        PRI = ROPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    // Set voice classes
    ROP.SoundGroupClass = class<ROPawnSoundGroup>(DynamicLoadObject(default.MaleSoundGroup, Class'Class'));

    if (PRI != none && PRI.RoleInfo != none)
    {
        ROP.VoiceType = PRI.RoleInfo.default.VoiceType;

        if (ROP.VoiceType != "")
        {
            VoiceClass = class<VoicePack>(DynamicLoadObject(ROP.VoiceType, Class'Class'));
        }

        DHVC = class<DHVoicePack>(VoiceClass);

        if (DHVC != none)
        {
            LI = Class'DH_LevelInfo'.static.GetInstance(P.Level);
            EnemyTeamIndex = int(!bool(P.GetTeamNum()));
            VoiceClass = DHVC.static.GetVoicePackClass(LI.GetTeamNationClass(EnemyTeamIndex));
        }

        PRI.VoiceType = VoiceClass;
        ROP.VoiceClass = class<TeamVoicePack>(VoiceClass);
    }

    return true;
}

// Modified to avoid "accessed none" errors when don't have a PlayerRecord (handling new DH system of player models defined in DHPawn classes instead of PlayerRecords)
// Note that without a PlayerRecord this function no longer gets called from the PlayerController's PostNetReceive() or the PRI's UpdatePrecacheMaterials()
// So instead we call it from the DHPawn's Setup() function (can't simply add relevant bits of this to Species'Setup() because that's also static & can't pass Level)
static function LoadResources(xUtil.PlayerRecord Rec, LevelInfo Level, PlayerReplicationInfo PRI, int TeamNum)
{
    local class<VoicePack> VoiceClass;
    local mesh             CustomSkeleton;

    if (Rec.MeshName != "")
    {
        DynamicLoadObject(Rec.MeshName, Class'Mesh');
    }

    if (Rec.Skeleton != "")
    {
        CustomSkeleton = mesh(DynamicLoadObject(Rec.Skeleton, Class'Mesh'));
    }

    if (CustomSkeleton == none && default.MaleSkeleton != "")
    {
        DynamicLoadObject(default.MaleSkeleton, Class'Mesh');
    }

    if (default.MaleSoundGroup != "")
    {
        DynamicLoadObject(default.MaleSoundGroup, Class'Class');
    }

    if (Rec.VoiceClassName != "" && !Level.bLowSoundDetail)
    {
        VoiceClass = class<VoicePack>(DynamicLoadObject(Rec.VoiceClassName, Class'Class'));
    }

    if (VoiceClass == none && default.MaleVoice != "")
    {
        class<VoicePack>(DynamicLoadObject(default.MaleVoice, Class'Class'));
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Rec.BodySkinName != "")
        {
            Level.AddPrecacheMaterial(Material(DynamicLoadObject(Rec.BodySkinName, Class'Material')));
        }

        if (Rec.FaceSkinName != "")
        {
            Level.AddPrecacheMaterial(Material(DynamicLoadObject(Rec.FaceSkinName, Class'Material')));
        }

        if (Rec.Portrait != none)
        {
            Level.AddPrecacheMaterial(Rec.Portrait);
        }

        Class'DHPawn'.static.StaticPrecache(Level); // pre-cache the pawn's content
    }
}

defaultproperties
{
    PawnClassName="DH_Engine.DHPawn"
    MaleSoundGroup="DH_Engine.DHPawnSoundGroup"
    FemaleSoundGroup="DH_Engine.DHPawnSoundGroup"
}
