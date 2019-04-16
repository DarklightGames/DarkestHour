//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment extends Actor;

var DHGameReplicationInfo DHGRI;
var int                   MapIconAttachmentsIndex;
var byte                  TeamIndex;

// Permissions
enum ETeamPermissions
{
    TP_None,
    TP_All,
    TP_Same,
    TP_Opposite,
};

var ETeamPermissions  TeamPermissions;

// Icon style
var Material IconMaterial;
var IntBox   IconCoords;
var color    IconTeamColors[2];

// Location / Rotation
var bool     bShowRotation;

simulated function PostBeginPlay()
{
    local DarkestHourGame DHG;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        DHG = DarkestHourGame(Level.Game);

        if (DHG == none)
        {
            return;
        }

        DHGRI = DHGameReplicationInfo(DHG.GameReplicationInfo);

        if (DHGRI == none)
        {
            return;
        }

        MapIconAttachmentsIndex = DHGRI.AddMapIconAttachment(self);

        OnLazyUpdate();
        SetTimer(1.0, true);
    }
}

simulated event Destroyed()
{
    if (Role == ROLE_Authority)
    {
        if (DHGRI != none)
        {
           DHGRI.RemoveMapIconAttachment(MapIconAttachmentsIndex);
        }
    }
}

function OwnerDied()
{
    Destroy();
}

// TODO:
simulated function vector GetPosition(optional out float Yaw)
{
    local vector L;

    if (bShowRotation)
    {
        Yaw = Owner.Rotation.Yaw;
    }

    L.X = Owner.Location.X;
    L.Y = Owner.Location.Y;
    L.Z = 0.0;

    return L;
}

// This delegate is called when a one-time update is required (e.g. on spawn or
// when danger zone updates).
//
// Default behavior:
// * Flip permissions when inside Danger Zone
simulated delegate OnLazyUpdate()
{
    if (Role == ROLE_Authority)
    {
        if (DHGRI == none || Owner == none)
        {
            return;
        }

        if (DHGRI.IsInDangerZone(Owner.Location.X, Owner.Location.Y, TeamIndex))
        {
            if (TeamPermissions == TP_Same)
            {
                TeamPermissions = TP_Opposite;
            }
        }
        else if (TeamPermissions == TP_Opposite)
        {
            TeamPermissions = TP_Same;
        }
    }
}

// This one defines who's allowed to see the icon and when.
//
// Default behavior:
// * Show for the friendly team
// * Hidden for spectator unless both teams can see the icon
simulated delegate bool OnHasPermissions(DHPlayer PC)
{
    if (PC == none)
    {
        return false;
    }

    if (PC.GetTeamNum() == 255)
    {
        return TeamPermissions == TP_All;
    }
    else if (PC.GetTeamNum() == TeamIndex)
    {
        return TeamPermissions == TP_Same;
    }
    else
    {
        return TeamPermissions == TP_Opposite;
    }
}

// ICON STYLE:
//
// Color, material, and all that stuff can be set via their respective variables;
// For more sophisticated rules assign the delegates.
//
// Default behavior:
// +-----------+-----------+-----------+
// | TEAM      | SPECTATOR | COLOR     |
// +-----------+-----------+-----------+
// | Opposite  | Axis      | Red       |
// +-----------+-----------+-----------+
// | Same      | Allies    | Blue      |
// +-----------+-----------+-----------+
simulated delegate color OnGetIconColor(optional DHPlayer PC)
{
    if ((PC == none || PC.GetTeamNum() == 255) && TeamIndex <= 1)
    {
        return IconTeamColors[0];
    }
    else if (PC.GetTeamNum() == TeamIndex)
    {
        return IconTeamColors[1];
    }
    else
    {
        return IconTeamColors[0];
    }
}

simulated delegate Material OnGetIconMaterial(DHPlayer PC)
{
    return IconMaterial;
}

simulated delegate IntBox OnGetIconCoords(DHPlayer PC)
{
    return IconCoords;
}

defaultproperties
{
    DrawType=DT_None
    RemoteRole=ROLE_DumbProxy
    MapIconAttachmentsIndex=-1
    TeamPermissions=TP_Same

    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    IconTeamColors[0]=(R=255,G=0,B=0,A=255)
    IconTeamColors[1]=(R=0,G=124,B=252,A=255)
}
