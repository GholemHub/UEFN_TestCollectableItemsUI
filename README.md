# UEFN_TestCollectableItemsUI


using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /Verse.org/Random }
using { /Fortnite.com/Game }
using {/UnrealEngine.com/Temporary/UI}

using { /UnrealEngine.com/Temporary/Diagnostics }

item_data := class<concrete>:
    @editable
    var item :collectible_object_device = collectible_object_device{}
    @editable
    var bVisible : logic =  false

hello_world_device := class(creative_device):

    @editable Collectibles : []item_data = array{}
    @editable ScoreManager : score_manager_device = score_manager_device{}
    @editable Spawner :player_spawner_device = player_spawner_device{}

    SetDynamicText<localizes>(Value: string): message = "{Value}"

    var MainWidget: MainHUD = MainHUD{}
    var CoinCounter : int = 3;
    var Time : float = 10.0;
    var ActiveCollectibles : []collectible_object_device = array{}

    OnBegin<override>()<suspends> : void =
        Spawner.Enable()
        Spawner.SpawnedEvent.Subscribe(AddUI)
        HideAll()
        Show3()
        OnCollectedListen()

    AddUI(MyAgent: agent):void =
        score:= ScoreManager.GetCurrentScore(MyAgent)
        set MainWidget.Score = SetDynamicText("score {score}")
        Print("AddUI-")
        if:
            Agent := MyAgent
            Player := player[Agent]
            PlayerUI := GetPlayerUI[Player]
        then:
            PlayerUI.AddWidget(MainWidget)
            
    OnCollectedListen()<suspends>: void = 
        for (c : Collectibles):
            c.item.CollectedEvent.Subscribe(OnCollectedEvent)
    
    OnCollectedEvent(Agent: agent) : void = 
        if (PlayerObj := player[Agent]):
            AddScore(Agent)
            set CoinCounter -= 1
            Print("OnCollectedEvent- CoinCounter:: {CoinCounter}")
            if(CoinCounter <= 0):
                set CoinCounter = 3;
                spawn{ OnCollectedEventTask(Agent)}

    AddScore(Agent: agent): void =
        ScoreManager.SetScoreAward(10)
        ScoreManager.Activate(Agent)
        score:= ScoreManager.GetCurrentScore(Agent)
        Print("AddScore- score:::{score}")
        
        set MainWidget.Score = SetDynamicText("score {score}")
                
    OnCollectedEventTask(Agent: agent)<suspends> : void =
        Sleep(10.0)
        Print("OnCollectedEventTask- Delayed logic after 5 sec")
        RespawnAll()

    RespawnAll() <suspends>: void = 
        for (c : Collectibles):
            c.item.RespawnForAll()
            c.item.Show()
            set c.bVisible = true
            Print("RespawnAll- Len::: {Collectibles.Length}")
        
        HideAll()
        Sleep(0.1)
        Show3()
       
    HideAll() : void = 
        for (c : Collectibles):
            c.item.Hide()
            set c.bVisible = false

    Show3() <suspends>: void = 
        var i :int= 0
        loop:
            if(i >= 3):
                break;
            R := GetRandomInt(0,5)
            if(c := Collectibles[R]):
                if(c.bVisible <> true):
                    c.item.Show()
                    set c.bVisible = true
                    set i += 1
                    Print("Show3- Rand:: {R} :: iteration:: {i}")

    
