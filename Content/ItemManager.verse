
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /Verse.org/Random }
using { /Fortnite.com/Game }

using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level



ItemManager := class(creative_device):
    @editable Collectibles : []item_data = array{}
    #@editable  : []collectible_object_device = array{}
    @editable PointsPerCollect : int = 10
    @editable RespawnDelay : float = 10.0

    var ActiveCollectibles : []collectible_object_device = array{}
    #var PlayerScores : map[player, int] = map{}

    OnBegin<override>() : void =
        HideAll()
        Show3()
        #RandomizeCollectibles(3)
        # Włącza wyświetlanie punktów na HUD
        #for (p : GetPlayspace().GetPlayers()):
            #ShowScore(p)



    HideAll() : void = 
        for (c : Collectibles):
            c.item.Hide()
            set c.bVisible = false

    Show3() : void = 
        X := GetRandomInt(0,5)
        var i :int= 0
        loop:
            if(i > 3):
                break;
            if(c := Collectibles[X]):
                if(c.bVisible = false):
                    c.item.Show()
                    set c.bVisible = true
                    set i += 1
                    Print("Message", ?Duration:=6.0)
        

   # RandomizeCollectibles(num : int) : void =
   #     # Ukryj wszystkie na starcie
   #     for (c : Collectibles):
   #         c.Hide()
#
#
   #     #ActiveCollectibles = array{}
#
   #     #var shuffled := Collectibles.Shuffled()
#
   #     X := GetRandomInt(0,5)
   #     if (c := Collectibles[X]):
   #         c.Show()
#
   #     i := 0
   #     loop: 
   #         if(i < num):
   #             break
   #         else:
   #             GetRandomInt(0,5)
   #             
#
#
   #     while (i < num):
   #         var collectible := shuffled[i]
   #         collectible.SetVisible(true)
   #         HandleCollectible(collectible)
   #         ActiveCollectibles.PushBack(collectible)
   #         i := i + 1
#
   # HandleCollectible(c : collectible_device) : void =
   #     c.CollectedEvent.Subscribe( fun(p : player): void =
   #         AddScore(p)
   #         c.SetVisible(false)
   #         ActiveCollectibles.Remove(c)
#
   #         SpawnNewCollectibleAfterDelay()
   #     )
#
   # AddScore(p : player) : void =
   #     var current := 0
   #     if(PlayerScores.Length > 0):
   #         current := PlayerScores[p]
   #         
   #     
   #     PlayerScores[p] = current + PointsPerCollect
   #    # SaveScore(p, PlayerScores[p])
   #     #UpdateHUD(p)
#
   # SpawnNewCollectibleAfterDelay() : void =
   #     Sleep(RespawnDelay)
   # 
   #     # Zbierz nieaktywne collectible
   #     var remaining : []collectible_device = array{}
   #     for (c : Collectibles):
   #         if (not ActiveCollectibles.Contains(c)):
   #             remaining.PushBack(c)
   # 
   #     if (remaining.Length() > 0):
   #         var newC := remaining.Shuffled()[0]
   #         newC.SetVisible(true)
   #         HandleCollectible(newC)
   #         ActiveCollectibles.PushBack(newC)
        

    #ShowScore(p : player) : void =
    #    var saved := LoadScore(p)
    #    PlayerScores[p] = saved
    #    UpdateHUD(p)
#
    #UpdateHUD(p : player) : void =
    #    var score := PlayerScores[p]
    #    UI.ShowMessage("{score} POINTS", p)
#
    #SaveScore(p : player, score : int) : void =
    #    persistent_stat_int{StatName: "PlayerPoints"}.SetValue(p, score)
#
    #LoadScore(p : player) : int =
    #    # Jeśli GetValue zwróci wartość, przypisz ją do saved i zwróć.
    #    if (saved := persistent_stat_int{StatName: "PlayerPoints"}.GetValue(p)?):
    #        return saved
    #    # W przeciwnym razie zwróć 0
    #    return 0