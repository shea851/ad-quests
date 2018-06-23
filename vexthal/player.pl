sub EVENT_ENTERZONE {
	if (defined $qglobals{"atencooldown"}) {
		$client->Message (15, "Aten Ha Ra has ".plugin::TimeToQglobalExpiration("atencooldown")." remaining on cool-down!");
	}
	else {
		$client->Message (15, "You sense unimaginable terror but can't explain it...");
	}
}