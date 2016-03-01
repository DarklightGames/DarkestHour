//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Transport_Armored extends DH_Sdkfz105Transport;

defaultproperties
{
    ArmorAttachmentStaticMesh=StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_armor'
    DriverPositions(0)=(TransitionUpAnim="Driver_out")
    DriverPositions(1)=(TransitionDownAnim="Driver_in")
}
