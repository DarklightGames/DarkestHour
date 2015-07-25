//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBulletWhipAttachment extends ROBulletWhipAttachment;

defaultproperties
{
    RemoteRole=ROLE_None // Matt: to stop this actor replicating to net clients, as it's spawned independently on clients & server
    CollisionRadius=300.0
    CollisionHeight=300.0
}
