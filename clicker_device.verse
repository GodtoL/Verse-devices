
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Clicker_device := class(creative_device):
    
    @editable
    PropManipulator : prop_manipulator_device = prop_manipulator_device{}
    
    @editable
    ClickerProp : creative_prop = creative_prop{}

    @editable
    ItemGranter : item_granter_device = item_granter_device{}

    var AnimationKeyFrames : []keyframe_delta = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        
        PropManipulator.DamagedEvent.Subscribe(OnPropDamaged)

        TargetScale : float = 0.8
        InverseTargetScale : float = 1.0/0.8

        DownScaleKeyFrame : keyframe_delta = keyframe_delta
        {
            DeltaLocation := vector3{ X:= 0.0, Y := 0.0, Z:= 0.0}

            DeltaRotation := IdentityRotation()

            DeltaScale := vector3{X := TargetScale, Y:= TargetScale, Z:= TargetScale}

            Time := 0.2

            Interpolation := EaseIn     
        }

        UpScaleKeyFrame : keyframe_delta = keyframe_delta
        {
            DeltaLocation := vector3{ X:= 0.0, Y := 0.0, Z:= 0.0}

            DeltaRotation := IdentityRotation()

            DeltaScale := vector3{X := InverseTargetScale, Y:= InverseTargetScale, Z:= InverseTargetScale}

            Time := 0.2

            Interpolation := EaseIn
        }

        set AnimationKeyFrames = array{ DownScaleKeyFrame, UpScaleKeyFrame}

    OnPropDamaged (Agent : agent): void=
        
        ItemGranter.GrantItem(Agent)

        if (PropAnimController := ClickerProp.GetAnimationController[]):
            
            AnimState := PropAnimController.GetState()

            if (AnimState = animation_controller_state.AnimationNotSet or AnimState = animation_controller_state.Stopped):

                PropAnimController.SetAnimation(AnimationKeyFrames, ?Mode := animation_mode.OneShot)

                PropAnimController.Play()