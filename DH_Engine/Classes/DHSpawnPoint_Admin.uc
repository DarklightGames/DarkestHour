//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
