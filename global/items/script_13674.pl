# Thank you to Skomag over at EQTitan for this.

# handles Vibrating Gauntlets/Hammer of Infuse
# clicking the items transmutes back and forth
# script file is used to bypass the lore check error
# 
# item 11668 Vibrating Gauntlets of Infuse
# item 11669 Vibrating Hammer of Infuse
# summons items instead of casting spell
# to avoid possible fizzle

sub EVENT_ITEM_CLICK_CAST {
        my %transmute = ();
        $transmute[11668] = 11669;
        $transmute[11669] = 11668;

        if($itemid && $transmute[$itemid]) {
                $client->NukeItem($itemid);
                quest::summonitem($transmute[$itemid]);
        }
}
