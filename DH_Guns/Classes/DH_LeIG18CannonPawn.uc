//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_LeIG18CannonPawn extends DHATGunCannonPawn;

simulated function DrawHUD(Canvas C)
{
    local float Elevation;
    local int Traverse;

    super.DrawHUD(C);
    
    if(DriverPositionIndex < GunsightPositions)
    {
        Elevation = -GetYawFromUnrealUnits(VehWep.CurrentAim.Pitch);
        Traverse = -GetYawFromUnrealUnits(VehWep.CurrentAim.Yaw);

        Log("VehWep: " @ VehWep);
        C.SetPos(50, 50);
        C.DrawText("Elevation: " @ Elevation);
        C.SetPos(50, 75);
        C.DrawText("Traverse: " @ Traverse);

        DrawRangeTable(C);
        DrawPitch(C,
            C.SizeX * 0.27, 
            C.SizeY * 0.5 - 150 + OverlayCorrectionY,
            300,
            -179,
            1297,
            Elevation,
            1476); // 1476 = (1297+179)
        
        DrawYaw(C, 
            C.SizeX * 0.5 - 150, 
            C.SizeY * 1.02 + OverlayCorrectionY, 
            300, 
            -107,
            107,
            Traverse,
            213);
    }
}

defaultproperties
{
    // TODO: change all the yaw limits etc.
    GunClass=class'DH_Guns.DH_LeIG18Cannon'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="optic_out",ViewLocation=(X=0.0,Y=-10.0,Z=40.0),ViewFOV=80.0,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="optic_in",bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_LeIG18_anm.leig18_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    CameraBone="turret" //changing here since we don't want pitch, only traverse/yaw of gunsight
    RaisedPositionIndex=2
    BinocPositionIndex=3
    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.RblF16_artillery_sight'   // TODO: REPLACE
    OverlayCorrectionX=-3
    OverlayCorrectionY=-80
    GunsightSize=0.40
    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'

    RangeTable(0)=(Mils=50,Range=100)
    RangeTable(1)=(Mils=85,Range=150)
    RangeTable(2)=(Mils=115,Range=200)
    RangeTable(3)=(Mils=150,Range=250)
    RangeTable(4)=(Mils=180,Range=300)
    RangeTable(5)=(Mils=210,Range=350)
    RangeTable(6)=(Mils=245,Range=400)
    RangeTable(7)=(Mils=280,Range=450)
    RangeTable(8)=(Mils=320,Range=500)
    RangeTable(9)=(Mils=355,Range=550)
    RangeTable(10)=(Mils=400,Range=600)
    RangeTable(11)=(Mils=450,Range=650)
    RangeTable(12)=(Mils=500,Range=700)
    RangeTable(13)=(Mils=570,Range=750)
    RangeTable(14)=(Mils=665,Range=800)
    RangeTable(15)=(Mils=775,Range=820)
    RangeTable(16)=(Mils=890,Range=800)
    RangeTable(17)=(Mils=990,Range=750)
    RangeTable(18)=(Mils=1055,Range=700)
    RangeTable(19)=(Mils=1110,Range=650)
    RangeTable(20)=(Mils=1160,Range=600)
    RangeTable(21)=(Mils=1200,Range=550)
    RangeTable(22)=(Mils=1240,Range=500)
    RangeTable(23)=(Mils=1280,Range=450)
}
