//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarAttachment extends DHWeaponAttachment;

defaultproperties
{
    PA_MortarDeployAnim="deploy_M2Mortar"
    WA_MortarDeployAnim="Deploy"
    WA_Idle="Idle"
    WA_Fire="Idle"
    PA_MovementAnims(0)="stand_jogF_M2Mortar"
    PA_MovementAnims(1)="stand_jogB_M2Mortar"
    PA_MovementAnims(2)="stand_jogL_M2Mortar"
    PA_MovementAnims(3)="stand_jogR_M2Mortar"
    PA_MovementAnims(4)="stand_jogFL_M2Mortar"
    PA_MovementAnims(5)="stand_jogFR_M2Mortar"
    PA_MovementAnims(6)="stand_jogBL_M2Mortar"
    PA_MovementAnims(7)="stand_jogBR_M2Mortar"
    PA_CrouchAnims(0)="crouch_walkF_M2Mortar"
    PA_CrouchAnims(1)="crouch_walkB_M2Mortar"
    PA_CrouchAnims(2)="crouch_walkL_M2Mortar"
    PA_CrouchAnims(3)="crouch_walkR_M2Mortar"
    PA_CrouchAnims(4)="crouch_walkFL_M2Mortar"
    PA_CrouchAnims(5)="crouch_walkFR_M2Mortar"
    PA_CrouchAnims(6)="crouch_walkBL_M2Mortar"
    PA_CrouchAnims(7)="crouch_walkBR_M2Mortar"
    PA_WalkAnims(0)="stand_walkF_M2Mortar"
    PA_WalkAnims(1)="stand_walkB_M2Mortar"
    PA_WalkAnims(2)="stand_walkL_M2Mortar"
    PA_WalkAnims(3)="stand_walkR_M2Mortar"
    PA_WalkAnims(4)="stand_walkFL_M2Mortar"
    PA_WalkAnims(5)="stand_walkFR_M2Mortar"
    PA_WalkAnims(6)="stand_walkBL_M2Mortar"
    PA_WalkAnims(7)="stand_walkBR_M2Mortar"
    PA_TurnRightAnim="stand_turnR_M2Mortar"
    PA_TurnLeftAnim="stand_turnL_M2Mortar"
    PA_CrouchTurnRightAnim="crouch_turnR_M2Mortar"
    PA_CrouchTurnLeftAnim="crouch_turnL_M2Mortar"
    PA_CrouchIdleRestAnim="crouch_idle_M2Mortar"
    PA_IdleCrouchAnim="crouch_idle_M2Mortar"
    PA_IdleRestAnim="stand_idle_M2Mortar"
    PA_IdleWeaponAnim="stand_idle_M2Mortar"
    MenuImage=Texture'DH_Mortars_tex.60mmMortarM2.60mmMortarM2'
    Mesh=SkeletalMesh'DH_Mortars_3rd.M2Mortar_carried'
    CullDistance=0.0 // no cull as it's too big
}
