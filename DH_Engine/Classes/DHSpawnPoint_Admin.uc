//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSpawnPoint_Admin extends DHSpawnPointBase
    notplaceable;

defaultproperties
{
    SpawnPointStyle="DHSpawnAdminButtonStyle"
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_SpawnPoint_Admin'
    SpawnLocationOffset=(Z=52)
    BaseSpawnTimePenalty=0
    SpawnKillPenalty=30
    SpawnKillPenaltyForgivenessPerSecond=1
}
