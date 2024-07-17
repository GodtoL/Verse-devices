
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors/NamedColors }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
ResourceUIDevice := class(creative_device):

    S2M<localizes>(S:string):message ="{S}"

    @editable
    Playerspawner : []player_spawner_device = array{}

    @editable
    ConditButton : conditional_button_device = conditional_button_device{}

    @editable
    RefreshRate : float = 0.1

    var ResourceTextBlockPerAgent : [agent]?text_block = map{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for (PS: Playerspawner):
            PS.SpawnedEvent.Subscribe(PlayerSpawned)
        
    PlayerSpawned(Agent : agent) : void =
        Print("Un jugador aparecio")
        if (MyTextBlock :=ResourceTextBlockPerAgent[Agent]?){}
        else:
            AssignUI(Agent)

    AssignUI(Agent:agent): void =
        Print("Asignando UI")
        MyCanvas := MakeCanvas(Agent)
        if:
            PlayerUI := GetPlayerUI[player[Agent]]
        then:
            PlayerUI.AddWidget(MyCanvas)
            spawn{RefreshUI(Agent)}

    RefreshUI (Agent : agent)<suspends> : void=
        Print("Actualizando...")
        if(TextBlock := ResourceTextBlockPerAgent[Agent]?):
            loop:
                Sleep(RefreshRate)
                MyResource := ConditButton.GetItemCount(Agent,0)
                TextBlock.SetText(S2M("💰 {MyResource}"))

    MakeCanvas(Agent:agent):canvas =
        Print("Creando el lienzo")
        MyTextBlock := text_block{}
            DefaultTextColor := White
        
        if (set ResourceTextBlockPerAgent[Agent] = option{MyTextBlock}){}

        MyCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget:=MyTextBlock
                    Anchors := anchors{Minimum:=vector2{X :=0.0, Y:= 0.0},Maximum:=vector2{X:= 1.0, Y:=1.0}}
                    Offsets:=margin{Left:=100.0, Top:=724.0, Right:= 1721.921875, Bottom:=327.081055}
        return MyCanvas