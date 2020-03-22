//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
// M4A3E8/M4A3(76)W HVSS (Easy Eight) - Upgraded with widetrack Horizontal
// Volute Spring Suspension (HVSS), fitted with the 76mm M1 cannon.
//==============================================================================

class DH_ShermanTank_M4A3E8_Fury extends DH_ShermanTank_M4A3E8;

var StaticMesh LogsLeftStaticMesh;
var StaticMesh LogsRightStaticMesh;
var DHDestroyableStaticMesh LogsLeft;
var DHDestroyableStaticMesh LogsRight;

var array<Actor> Attachments;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    CreateAttachments();
}

exec function BreakLogs(string Side)
{
    if (Role == ROLE_Authority)
    {
        if (Side ~= "L" && LogsLeft != none)
        {
            LogsLeft.BreakMe();
        }
        else if (Side ~= "R" && LogsRight != none)
        {
            LogsRight.BreakMe();
        }
    }
}

// In the movie, Fury has some protective logs that absorb a Panzerfaust strike
// at one point, but then fall off as a result. Our Fury will do the same!
simulated function CreateAttachments()
{
    if (Role == ROLE_Authority)
    {
        // Left logs
        LogsLeft = Spawn(class'DHDestroyableStaticMesh', self);

        if (LogsLeft != none)
        {
            LogsLeft.DestroyedEmitterClass = class'DH_Effects.DHFuryLogsLeftEmitter';
            LogsLeft.SetStaticMesh(LogsLeftStaticMesh);
            AttachToBone(LogsLeft, 'body');
            Attachments[Attachments.Length] = LogsLeft;
        }

        // Right logs
        LogsRight = Spawn(class'DHDestroyableStaticMesh', self);

        if (LogsRight != none)
        {
            LogsRight.SetStaticMesh(LogsRightStaticMesh);
            LogsRight.DestroyedEmitterClass = class'DH_Effects.DHFuryLogsRightEmitter';
            AttachToBone(LogsRight, 'body');
            Attachments[Attachments.Length] = LogsRight;
        }
    }
}

function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    // TODO: i don't think this gets run on the client?
    DestroyAttachments();
}

simulated function DestroyAttachments()
{
    local int i;

    super.DestroyAttachments();

    for (i = 0; i < Attachments.Length; ++i)
    {
        if (Attachments[i] != none)
        {
            Attachments[i].Destroy();
        }
    }
}

defaultproperties
{
    VehicleNameString="Sherman M4A3E8 'Fury'"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A3E8_Fury')
    VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body.body_stowage',bHasCollision=false)

    LogsLeftStaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body.logs_L'
    LogsRightStaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body.logs_R'

    DestroyedVehicleMesh=StaticMesh'DH_ShermanM4A3E8_stc.Destroyed.fury_destroyed'

    VehicleHudImage=Texture'DH_ShermanM4A3E8_tex.Menu.body_fury'
    VehicleHudTurret=TexRotator'DH_ShermanM4A3E8_tex.Menu.turret_fury_look'
    VehicleHudTurretLook=TexRotator'DH_ShermanM4A3E8_tex.Menu.turret_fury_rot'
    SpawnOverlay(0)=Texture'DH_ShermanM4A3E8_tex.Menu.sherman_m4a3e8_fury'
}

