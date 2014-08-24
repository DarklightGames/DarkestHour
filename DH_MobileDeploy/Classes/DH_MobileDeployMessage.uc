//MDV messages used by teleporter and vehicle (deny entry)

class DH_MobileDeployMessage extends LocalMessage;

//=============================================================================
// Variables
//=============================================================================

var(Messages) localized string IsFull;
var(Messages) localized string IsDestroyed;
var(Messages) localized string IsInCapture;
var(Messages) localized string EnemyNear;
var(Messages) localized string MustBeSquadLeader;

//=============================================================================
// Functions
//=============================================================================

//-----------------------------------------------------------------------------
// GetString
//-----------------------------------------------------------------------------

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0:
            return default.IsFull;
        case 1:
            return default.IsDestroyed;
        case 2:
            return default.IsInCapture;
        case 3:
            return default.EnemyNear;
        case 4:
            return default.MustBeSquadLeader;
        default:
            return default.IsFull;
    }

}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     IsFull="The Mobile Deploy Vehicle is full."
     IsDestroyed="The Mobile Deploy Vehicle is destroyed."
     IsInCapture="The Mobile Deploy Vehicle is in a capture area."
     EnemyNear="The Mobile Deploy Vehicle has enemies nearby."
     MustBeSquadLeader="You must be a Squad Leader to drive this mobile deploy vehicle."
     bFadeMessage=true
     DrawColor=(B=36,G=28,R=214)
     PosY=0.750000
     FontSize=2
}
