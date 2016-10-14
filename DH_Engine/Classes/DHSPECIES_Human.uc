//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSPECIES_Human extends ROSPECIES_Human
    abstract;

// Modified to fix bug where VoiceType & VoiceClass were sometimes not set up on net client (if player is in vehicle when he spawns so DHPawn has no PRI)
// Also to avoid "accessed none" errors, handling the new DH system of player models defined in DHPawn classes instead of PlayerRecords
static function bool Setup(Pawn P, xUtil.PlayerRecord Rec)
{
    local ROPawn                  ROP;
    local ROPlayerReplicationInfo PRI;
    local mesh                    NewMesh;
    local class<VoicePack>        VoiceClass;

    ROP = ROPawn(P);

    if (ROP == none)
    {
        Warn("DHSPECIES_Human.Setup() error: no ROPawn");

        return false;
    }

    ROP.SoundGroupClass = class<ROPawnSoundGroup>(DynamicLoadObject(default.MaleSoundGroup, class'Class'));

    // Legacy model setup from PlayerRecord - in DH an empty PlayerRecord will now be passed, so the DHPawn class handles the model setup
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

    // Set up VoiceType & VoiceClass
    if (PRI != none && PRI.RoleInfo != none)
    {
        ROP.VoiceType = PRI.RoleInfo.default.VoiceType;

        if (ROP.VoiceType != "")
        {
            VoiceClass = class<VoicePack>(DynamicLoadObject(ROP.VoiceType, class'Class'));
        }

        PRI.VoiceType = VoiceClass;
        ROP.VoiceClass = class<TeamVoicePack>(VoiceClass);

        if (P.PlayerReplicationInfo == none && P.DrivenVehicle != none)
            log(PRI.PlayerName @ "Species.SetUp(): AVERTED VOICE COMMANDS BUG when player was in a vehicle & DHPawn has no PRI"); // TEMPDEBUG
    }
    else // TEMPDEBUG
    {
        if (PRI != none) log(PRI.PlayerName @ "Species.Setup(): NO VOICE SETUP due to no PRI.RoleInfo - SHOULD NOT HAPPEN!!!");
        else log(P.name @ "Species.Setup(): NO VOICE SETUP due to no PRI - SHOULD NOT HAPPEN!!!");
    }

    return true;
}

defaultproperties
{
    PawnClassName="DH_Engine.DHPawn"
}
