//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelItem_Italian extends DHShovelItem;

defaultproperties
{
    AttachmentClass=class'DHShovelAttachment_German'
    Mesh=SkeletalMesh'DH_Shovel_1st.shovel_italian_1st'
    NativeItemName="Pala Vanga"
    DisplayFOV=90.0

    // TODO: put these in the parent class when we convert all the old shovels to the new animations
    SprintStartAnim="sprint_in"
    SprintEndAnim="sprint_out"
    SprintLoopAnim="sprint_middle"
}
