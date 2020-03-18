//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu
dependson(DHGameReplicationInfo);

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    PC = GetPlayerController();
    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    GRI.GetMapCoords(Location, MapLocation.X, MapLocation.Y);
    switch (Index)
    {
        case 0: // Artillery barrage
            PC.ServerSaveArtilleryPosition();
            break;
        case 1: // Fire request (HE)
            Log("pre HE PC.AddArtilleryRequest(Marker)");
            PC.ServerAddArtilleryMarker(class'DH_Engine.DHMarker_ArtilleryRequest_HE', MapLocation.X, MapLocation.Y);
            Log("post HE PC.AddArtilleryRequest(Marker)");
            break;
        case 2: // Fire request (Smoke)
            //Log("pre smoke PC.ServerAddArtilleryMarker(Marker)");
            PC.ServerAddArtilleryMarker(class'DH_Engine.DHMarker_ArtilleryRequest_Smoke', MapLocation.X, MapLocation.Y);
            Log("post smoke PC.ServerAddArtilleryMarker(Marker)");
            break;
    }

    Interaction.Hide();
}

defaultproperties
{
    // TODO: Icons
    Options(0)=(ActionText="Artillery Barrage",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(1)=(ActionText="Fire Request (HE)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(ActionText="Fire Request (Smoke)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
}
