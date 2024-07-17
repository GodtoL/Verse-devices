# fill this file with your verse-script
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/UI }

Custom_Player := class <unique>():
    StringToMessage<localizes>(value:string)<computes> : message = "{value}"

    Player : agent

    var SuperBucksScoreText : text_block = text_block{}
    var SuperBucks : int = 0

    InitiateUI():void=
        set SuperBucksScoreText = text_block{DefaultText := StringToMessage("SuperBucks : {SuperBucks}"), DefaultTextColor := NamedColors.White, DefaultShadowColor := NamedColors.Black}
        playerScoreWidget : canvas = CreateUserUI(SuperBucksScoreText)

        if(PlayerObj := player[Player], PlayerUI := GetPlayerUI[PlayerObj]):
                PlayerUI.AddWidget(playerScoreWidget)
    
    CreateUserUI(ScoreTextBlock : text_block) : canvas=
        UICanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.2}, Maximum := vector2{X := 0.5, Y := 0.2}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.0}
                    SizeToContent := true
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := color_block:
                                    DefaultColor := NamedColors.Black
                                    DefaultOpacity := 0.1
                                    DefaultDesiredSize := vector2{X := 300.0, Y := 40.0}
                            overlay_slot:
                                Widget := ScoreTextBlock
        return UICanvas

    AddSuperBucks(Amount:int):void=
        set SuperBucks += Amount
        UpdateUI()

    RemoveSuperBucks(Amount:int):void=
        set SuperBucks -= Amount
        UpdateUI()

    CheckSuperBucks(Amount:int):logic=
        if(SuperBucks = Amount):
            return false
        else:
            return true
    
    UpdateUI():void=
        SuperBucksScoreText.SetText(StringToMessage("SuperBucks: {SuperBucks}"))
    