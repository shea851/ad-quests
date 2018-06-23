sub EVENT_SPAWN {
    quest::settimer("final",59);
}

sub EVENT_TIMER {
    if($timer eq "final" && defined plugin::ReadQGlobal("vine_ring_final") && defined plugin::ReadQGlobal("mud_ring_final") && defined plugin::ReadQGlobal("stone_ring_final") && defined plugin::ReadQGlobal("dust_ring_final") && !defined plugin::ReadQGlobal("arbitor_of_earth")) {
        quest::setglobal("arbitor_of_earth", 1, 3, "H4");
        quest::spawn2(218053,0,0,1520.9,-2745.2,6.1,188.2);
        }
}