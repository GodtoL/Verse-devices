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

Game_Manager := class(creative_device):
    var PlayersMap : [player]Custom_Player = map{}

    @editable
    GetWeaponButton : button_device = button_device{}

    @editable
    MessageDevice : hud_message_device = hud_message_device{}

    @editable
    WeaponGranter : item_granter_device = item_granter_device{}

    @editable
    SuperBucksTimer : timer_device = timer_device{}

    @editable
    Collectible1 : collectible_object_device = collectible_object_device{}

    @editable
    Collectible2 : collectible_object_device = collectible_object_device{}

    @editable
    Collectible3 : collectible_object_device = collectible_object_device{}

    @editable
    P1Spawner : player_spawner_device = player_spawner_device{}

    CollectibleValue : int = 50
    TimerValue:int = 5

    WeaponCost : int = 100

    OnBegin<override>()<suspends>:void=
        P1Spawner.SpawnedEvent.Subscribe(OnPlayerAdded)
        Collectible1.CollectedEvent.Subscribe(OnCollect)
        Collectible2.CollectedEvent.Subscribe(OnCollect)
        Collectible3.CollectedEvent.Subscribe(OnCollect)
        GetWeaponButton.InteractedWithEvent.Subscribe(OnWeaponButton)
        SuperBucksTimer.SuccessEvent.Subscribe(OnSuperBucksTimer)

    OnPlayerAdded(Agent:agent): void =
        if:
            PlayerObj := player[Agent]
        then:
            if(PlayerExists := PlayersMap[PlayerObj]):
            
            else:
                if:
                    FC := Agent.GetFortCharacter[]
                then:
                    CustomPlayer : Custom_Player = Custom_Player{Player := Agent}
                    option:
                        set PlayersMap[PlayerObj] = CustomPlayer
                    CustomPlayer.InitiateUI()
    
    OnWeaponButton(Agent : agent): void=
        if(PlayerObj := player[Agent]):
            if (CustomPlayer : Custom_Player = PlayersMap[PlayerObj]):
                DoWeHaveEnough : logic = CustomPlayer.CheckSuperBucks(WeaponCost)
                if(DoWeHaveEnough = true):
                    WeaponGranter.GrantItem(Agent)
                else:
                    MessageDevice.Show(Agent)
        
    OnCollect(Agent:agent): void= 
        if(PlayerObj := player[Agent]):
            if(CustomPlayer : Custom_Player = PlayersMap[PlayerObj]):
                CustomPlayer.AddSuperBucks(CollectibleValue)
            
    OnSuperBucksTimer(Agent : ?agent): void =
        for(CustomPlayer : PlayersMap):
            CustomPlayer.AddSuperBucks(TimerValue)
        
        block: